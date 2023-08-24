TAG ?= $(shell git describe --tags --always)
REGISTRY ?= anan0329

docker-build-jupyter-pytorch-cuda:
	$(MAKE) docker-build-cuda -C ../jupyter-pytorch TAG=${TAG} 

docker-build-cuda: docker-build-jupyter-pytorch-cuda
	docker build -t ${REGISTRY}/jupyter-pytorch-cuda-kaldi:${TAG} --build-arg BASE_IMG=${REGISTRY}/jupyter-pytorch-cuda:${TAG} -f cuda.Dockerfile . 

docker-push-cuda:
	docker push ${REGISTRY}/jupyter-pytorch-cuda-kaldi:${TAG}
