TAG ?= $(shell git describe --tags --always)
REGISTRY ?= anan0329

docker-build-base:
	$(MAKE) docker-build -C ../base TAG=${TAG}

docker-build: docker-build-base
	docker build -t ${REGISTRY}/rstudio:${TAG} --build-arg BASE_IMG=${REGISTRY}/base:${TAG} -f Dockerfile . 

docker-push:
	docker push ${REGISTRY}/rstudio:${TAG}
