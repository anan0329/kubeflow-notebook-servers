# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<jupyter-pytorch-cuda>
FROM $BASE_IMG

USER root

RUN git clone https://github.com/timdettmers/bitsandbytes.git
WORKDIR /bitsandbytes
RUN CUDA_VERSION=117 make cuda11x
RUN python setup.py install

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt
