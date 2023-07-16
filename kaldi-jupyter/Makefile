TAG ?= $(shell git describe --tags --always --dirty)
REGISTRY ?= anan0329

docker-build:
	docker build -t ${REGISTRY}/kaldi-jupyter:${TAG} -f Dockerfile . 
