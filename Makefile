
SHELL = /bin/bash

all: build package


build:
	docker build -f Dockerfile --tag remotepixel:latest .

run:
	docker run \
		-w /var/task/ \
		--name remotepixel \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_REGION=us-west-2 \
		--env PYTHONPATH=/var/task/vendored \
		-itd \
		remotepixel:latest


package:
	docker run \
		-w /var/task/ \
		--name remotepixel \
		-itd \
		remotepixel:latest
	docker cp remotepixel:/tmp/package.zip package.zip
	docker stop remotepixel
	docker rm remotepixel


shell:
	docker run \
		--name remotepixel  \
		--volume $(shell pwd)/:/data \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_REGION=us-west-2 \
		--env PYTHONPATH=/var/task/vendored \
		--rm \
		-it \
		remotepixel:latest /bin/bash


clean:
	docker stop remotepixel
	docker rm remotepixel
