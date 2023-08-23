TAG ?= $(shell git describe --tags --always)
REGISTRY ?= anan0329

docker-build-codeserver:
	$(MAKE) docker-build -C ../codeserver TAG=${TAG}

docker-build: docker-build-codeserver
	docker build -t ${REGISTRY}/codeserver-python-r:${TAG} --build-arg BASE_IMG=${REGISTRY}/codeserver:${TAG} -f Dockerfile . 

docker-push:
	docker push ${REGISTRY}/codeserver-python-r:${TAG}
