FROM kaldiasr/kaldi:latest

WORKDIR /jup

RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python-pip
RUN apt-get install -y python3-pip

RUN pip install --upgrade pip
RUN pip3 install --upgrade pip
# RUN pip3 install jupyter
RUN pip3 install numpy
RUN pip3 install jupyterlab

# RUN jupyter lab --generate-config

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root","--NotebookApp.token=''","--NotebookApp.password=''","--NotebookApp.allow_origin=''"]