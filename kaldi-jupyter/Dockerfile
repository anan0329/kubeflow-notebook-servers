FROM kaldiasr/kaldi:latest

WORKDIR /jup

RUN set -xe \
    && apt-get update -y \
    && apt-get install -y python3-pip
RUN pip3  install --upgrade pip

RUN pip3  install jupyter -U && pip3 install jupyterlab 

RUN jupyter lab --generate-config

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root","--ServerApp.token=''","--ServerApp.password=''","--ServerApp.allow_origin=''"]