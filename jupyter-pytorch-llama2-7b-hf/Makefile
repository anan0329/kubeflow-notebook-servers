TAG ?= $(shell git describe --tags --always)
REGISTRY ?= anan0329

docker-build-jupyter-pytorch-cuda-full:
	$(MAKE) docker-build-cuda -C ../jupyter-pytorch-full TAG=${TAG} 

docker-build: docker-build-jupyter-pytorch-cuda-full
	# docker build -t ${REGISTRY}/jupyter-pytorch-full-llama2-7b-hf:${TAG} --build-arg BASE_IMG=${REGISTRY}/jupyter-pytorch-cuda-full:${TAG} -f Dockerfile . 
	docker build --progress=plain -t ${REGISTRY}/jupyter-pytorch-full-llama2-7b-hf:${TAG} --build-arg BASE_IMG=${REGISTRY}/jupyter-pytorch-cuda-full:${TAG} -f Dockerfile . 

docker-push:
	docker push ${REGISTRY}/jupyter-pytorch-cuda-full:${TAG}
