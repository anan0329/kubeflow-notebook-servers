# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<jupyter-pytorch-cuda>
FROM $BASE_IMG

USER 

RUN apt-get update \ 
 && apt-get install -y --no-install-recommends \
    g++ \
    automake \
    autoconf \
    sox \
    libtool \
    subversion \
    python2.7 \
    python3 \
    zlib1g-dev \
    gfortran \
    ca-certificates \
    patch \
    ffmpeg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python2.7 /usr/bin/python

RUN git clone --depth 1 https://github.com/kaldi-asr/kaldi.git /opt/kaldi \
 && cd /opt/kaldi/tools \
 && ./extras/install_mkl.sh \
 && make -j $(nproc) \
 && cd /opt/kaldi/src \
 && ./configure --shared --use-cuda \
 && make depend -j $(nproc) \
 && make -j $(nproc) \
 && find /opt/kaldi  -type f \( -name "*.o" -o -name "*.la" -o -name "*.a" \) -exec rm {} \; \
 && find /opt/intel -type f -name "*.a" -exec rm {} \; \
 && find /opt/intel -type f -regex '.*\(_mc.?\|_mic\|_thread\|_ilp64\)\.so' -exec rm {} \; \
 && rm -rf /opt/kaldi/.git

WORKDIR /opt/kaldi/
