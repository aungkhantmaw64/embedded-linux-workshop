DOCKER_IMG_NAME=embedded_linux

docker-image-build:
	docker build -t ${DOCKER_IMG_NAME} --progress tty .

docker-container-bash:
	docker container run --rm -it -v ${PWD}:/app -w /app ${DOCKER_IMG_NAME} bash

