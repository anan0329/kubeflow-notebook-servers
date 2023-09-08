TAG ?= $(shell git describe --tags --always)
REGISTRY ?= anan0329

docker-build-rstudio:
	$(MAKE) docker-build -C ../rstudio TAG=${TAG} 

docker-build: docker-build-rstudio
	docker build -t ${REGISTRY}/rstudio-full:${TAG} --build-arg BASE_IMG=${REGISTRY}/rstudio:${TAG} -f Dockerfile . 

docker-push:
	docker push ${REGISTRY}/rstudio-full:${TAG}
