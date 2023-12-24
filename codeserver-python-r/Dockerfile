# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<codeserver-python>
FROM $BASE_IMG

ARG R_TIDYVERSE_VERSION="2.0.0"
ARG R_TIDYMODELS_VERSION="1.1.1"
ARG R_MLR3VERSE_VERSION="0.2.8"

USER root

# # args - software versions
# ARG CODESERVER_PYTHON_VERSION=2021.5.842923320
# ARG MINIFORGE_ARCH="x86_64"
#  # renovate: datasource=github-tags depName=conda-forge/miniforge versioning=loose
# ARG MINIFORGE_VERSION=23.1.0-3
# ARG PIP_VERSION=23.0.1
# ARG PYTHON_VERSION=3.10.4
# ARG R_BASE_VERSION=4.3.0
# ARG R_RETICULATE_VERSION=1.30
# ARG R_PNG_VERSION=0.1_8

# # nvidia configs
# # ENV NVIDIA_VISIBLE_DEVICES all
# # ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# # ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# # setup environment for conda
# ENV CONDA_DIR /opt/conda
# ENV PATH "${CONDA_DIR}/bin:${PATH}"
# RUN mkdir -p ${CONDA_DIR} \
#  && chown -R ${NB_USER}:users ${CONDA_DIR}

# USER $NB_UID

# # install - conda, pip, python
# RUN curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh" -o /tmp/Miniforge3.sh \
#  && curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh.sha256" -o /tmp/Miniforge3.sh.sha256 \
#  && echo "$(cat /tmp/Miniforge3.sh.sha256 | awk '{ print $1; }') /tmp/Miniforge3.sh" | sha256sum --check \
#  && rm /tmp/Miniforge3.sh.sha256 \
#  && /bin/bash /tmp/Miniforge3.sh -b -f -p ${CONDA_DIR} \
#  && rm /tmp/Miniforge3.sh \
#  && conda config --system --set auto_update_conda false \
#  && conda config --system --set show_channel_urls true \
#  && echo "conda ${MINIFORGE_VERSION:0:-2}" >> ${CONDA_DIR}/conda-meta/pinned \
#  && echo "python ${PYTHON_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
#  && echo "r-base ${R_BASE_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
#  && conda install -y -q \
#     python=${PYTHON_VERSION} \
#     conda=${MINIFORGE_VERSION:0:-2} \
#     pip=${PIP_VERSION} \ 
#     r-base=${R_BASE_VERSION} \
#     r-reticulate=${R_RETICULATE_VERSION} \
#     r-png=${R_PNG_VERSION} \
#     radian



# USER root
# RUN conda update -y -q --all \
#  && conda clean -a -f -y \
#  && chown -R ${NB_USER}:users ${CONDA_DIR} \
#  && chown -R ${NB_USER}:users ${HOME}

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp
RUN python3 -m pip install -r /tmp/requirements.txt --no-cache-dir \
 && rm -f /tmp/requirements.txt

# set default CRAN repo to RSPM (it has pre-compiled R packages, increasing user install speed)
# RUN echo 'options(repos=c(CRAN="https://packagemanager.rstudio.com/all/__linux__/focal/latest"))' >> ${R_HOME}/etc/Rprofile.site \
#  && echo 'options(HTTPUserAgent=sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> ${R_HOME}/etc/Rprofile.site

# R needs TZ set
# ENV TZ Etc/UTC
# RUN echo "TZ=${TZ}" >> ${R_HOME}/etc/Renviron.site

# install - codeserver extensions
# RUN curl -# -L -o /tmp/ms-python-release.vsix "https://github.com/microsoft/vscode-python/releases/download/${CODESERVER_PYTHON_VERSION}/ms-python-release.vsix" \
#  && code-server --install-extension /tmp/ms-python-release.vsix \
#  && code-server --list-extensions --show-versions

# install r packages
RUN conda install -y -q \
    r-tidyverse=${R_TIDYVERSE_VERSION} \
    r-tidymodels=${R_TIDYMODELS_VERSION} \
    r-mlr3verse=${R_MLR3VERSE_VERSION} \
    radian
ADD r-packages-install.sh /tmp/r-packages-install.sh
ADD r-packages.txt /tmp/r-packages.txt
RUN chmod 777 /tmp/r-packages-install.sh
RUN R -e "install.packages('mlr3proba', repos = 'https://mlr-org.r-universe.dev')"
RUN R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('strboul/caseconverter')"
RUN R -e "remotes::install_github('matt-dray/quartostamp')"
RUN R -e "remotes::install_github('matt-dray/snorkel')"
RUN R -e "remotes::install_github('gesistsa/rio')"
RUN R -e "rio::install_formats(repos='http://cran.rstudio.com/')"
RUN bash /tmp/r-packages-install.sh

# RUN mkdir -p ${HOME}/Llama-2-7b-chat-hf
# COPY --chown=jovyan:users Llama-2-7b-chat-hf/* ${HOME}/Llama-2-7b-chat-hf

RUN chown -R jovyan:root /home/jovyan/.local/share/code-server

# # s6 - copy scripts
# COPY --chown=jovyan:users s6/ /etc

# # s6 - 01-copy-tmp-home
# USER root
# RUN mkdir -p /tmp_home \
#  && cp -r ${HOME} /tmp_home \
#  && chown -R ${NB_USER}:users /tmp_home
# USER ${NB_UID}
