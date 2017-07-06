FROM amazonlinux:latest

# Configure SHELL
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV SHELL /bin/bash

# Install apt dependencies
RUN yum install -y gcc \
                   gcc-c++ \
                   freetype-devel \
                   yum-utils \
                   findutils \
                   openssl-devel

RUN yum -y groupinstall development

RUN curl https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz | tar -xJ \
    && cd Python-3.6.1 \
    && ./configure --prefix=/usr/local --enable-shared \
    && make \
    && make install \
    && cd .. \
    && rm -rf Python-3.6.1

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN pip3 install numpy --no-binary numpy #numpy header are needed to build rasterio from source

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt --no-binary numpy -t /tmp/vendored #Install numpy from source to save some space

COPY handler.py /tmp/vendored/handler.py

#Reduce Lambda package size (<250Mb)
RUN echo "package original size $(du -sh /tmp/vendored | cut -f1)"
RUN find /tmp/vendored \
    \( -type d -a -name test -o -name tests \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -print0 | xargs -0 rm -f
RUN echo "package new size $(du -sh /tmp/vendored | cut -f1)"

RUN cd /tmp \
    && zip -r9q /tmp/package.zip vendored/*

RUN rm -rf /tmp/vendored/
