TAG ?= $(shell git describe --tags --always)
REGISTRY ?= anan0329

docker-build:
	docker build -t ${REGISTRY}/base:${TAG} -f Dockerfile .

docker-push:
	docker push ${REGISTRY}/base:${TAG}
