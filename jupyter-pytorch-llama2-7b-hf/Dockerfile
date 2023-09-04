ARG BASE_IMG=<jupyter-pytorch-cuda-full>
FROM $BASE_IMG

USER root

COPY ./token.yml /
RUN chmod +x /token.yml

COPY ./get_model.py /
RUN chmod +x /get_model.py
RUN python3 /get_model.py
