
SHELL = /bin/bash

build:
	docker build --tag lambda:latest .
	docker run --name lambda -itd lambda:latest /bin/bash
	docker cp lambda:/tmp/package.zip package.zip
	docker stop lambda
	docker rm lambda

shell:
	docker build --tag lambda:latest .
	docker run --name docker  \
		--volume $(shell pwd)/:/local \
		--rm -it lambda:latest bash

test: build
	docker run \
		--name lambda \
		--volume $(shell pwd)/:/local \
		--env GDAL_DATA=/var/task/share/gdal \
		-itd \
		lambci/lambda:build-python3.6 bash
	docker exec -it lambda bash -c 'unzip -q /local/package.zip -d /var/task/'
	docker exec -it lambda python3 -c 'from handler import main; print(main({"scene": "LC08_L1TP_013030_20170520_20170520_01_RT"}, None))'
	docker stop lambda
	docker rm lambda

clean:
	docker stop lambda
	docker rm lambda
