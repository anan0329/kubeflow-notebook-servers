# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<codeserver>
FROM $BASE_IMG

USER root

# args - software versions
ARG CODESERVER_PYTHON_VERSION=2021.5.842923320
ARG MINIFORGE_ARCH="x86_64"
 # renovate: datasource=github-tags depName=conda-forge/miniforge versioning=loose
ARG MINIFORGE_VERSION=23.1.0-3
ARG PIP_VERSION=23.0.1
ARG PYTHON_VERSION=3.10.4
ARG R_BASE_VERSION=4.3.0
ARG R_RETICULATE_VERSION=1.30
ARG R_PNG_VERSION=0.1_8

# nvidia configs
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# setup environment for conda
ENV CONDA_DIR /opt/conda
ENV PATH "${CONDA_DIR}/bin:${PATH}"
RUN mkdir -p ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${CONDA_DIR}

USER $NB_UID

# install - conda, pip, python
RUN curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh" -o /tmp/Miniforge3.sh \
 && curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh.sha256" -o /tmp/Miniforge3.sh.sha256 \
 && echo "$(cat /tmp/Miniforge3.sh.sha256 | awk '{ print $1; }') /tmp/Miniforge3.sh" | sha256sum --check \
 && rm /tmp/Miniforge3.sh.sha256 \
 && /bin/bash /tmp/Miniforge3.sh -b -f -p ${CONDA_DIR} \
 && rm /tmp/Miniforge3.sh \
 && conda config --system --set auto_update_conda false \
 && conda config --system --set show_channel_urls true \
 && echo "conda ${MINIFORGE_VERSION:0:-2}" >> ${CONDA_DIR}/conda-meta/pinned \
 && echo "python ${PYTHON_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
 && echo "r-base ${R_BASE_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
 && conda install -y -q \
    python=${PYTHON_VERSION} \
    conda=${MINIFORGE_VERSION:0:-2} \
    pip=${PIP_VERSION} \ 
    r-base=${R_BASE_VERSION} \
    r-reticulate=${R_RETICULATE_VERSION} \
    r-png=${R_PNG_VERSION} \
    radian

RUN conda install -y -q \
    r-assertthat \
    r-blob \
    r-callr \
    r-caret \
    r-cli \
    r-clipr \
    r-clock \
    r-codetools \
    r-cpp11 \
    r-DALEX \
    r-data.table \
    r-dbi \
    r-devtools \
    r-e1071 \
    r-fastmap \
    r-forcats \
    r-foreign \
    r-formatr \
    r-ggmap \
    r-glmnet \
    r-gt \
    r-gtExtras \
    r-ggvis \
    r-glue

RUN conda install -y -q \
    r-haven \
    r-highr \
    r-httpgd \
    r-htmlwidgets \
    r-httr2 \
    r-jsonlite \
    r-knitr \
    r-languageserver \
    r-lightgbm \
    r-lintr \
    r-magrittr \
    r-maps \
    r-maptools \
    r-matrixstats \
    r-memoise \
    r-mlr3verse \
    r-multcomp \
    r-odbc

RUN conda install -y -q \
    r-parallelly \
    r-pins \
    r-plotly \
    r-plumber \
    r-ps \
    r-quantmod \
    r-quarto \
    r-r6 \ 
    r-randomforest \
    r-readxl \
    r-rcpp \
    r-rgl \
    r-rlang \
    r-rmarkdown \
    r-rprojroot \
    r-roxygen2 \
    r-rpart \
    r-rsqlite \
    r-shiny \
    r-shinyWidgets \
    r-showtext \
    r-sp

RUN conda install -y -q \
    r-tidymodels \
    r-tidyquant \
    r-tidyverse

RUN conda install -y -q \
    r-testthat \
    r-torch \
    r-vctrs

RUN R -e "install.packages('vetiver',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('xgboost',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('patchwork',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('flexdashboard',dependencies=TRUE, repos='http://cran.rstudio.com/')"

# RUN conda install -y -q \
#     r-vetiver \
#     r-xgboost-gpu

RUN conda install -y -q \
    r-xml \
    r-xml2 \
    r-xts \
    r-waldo \
    r-vcd \
    r-zoo

USER root
RUN conda update -y -q --all \
 && conda clean -a -f -y \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# set default CRAN repo to RSPM (it has pre-compiled R packages, increasing user install speed)
RUN echo 'options(repos=c(CRAN="https://packagemanager.rstudio.com/all/__linux__/focal/latest"))' >> ${R_HOME}/etc/Rprofile.site \
 && echo 'options(HTTPUserAgent=sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> ${R_HOME}/etc/Rprofile.site

# R needs TZ set
ENV TZ Etc/UTC
RUN echo "TZ=${TZ}" >> ${R_HOME}/etc/Renviron.site

# install - codeserver extensions
RUN curl -# -L -o /tmp/ms-python-release.vsix "https://github.com/microsoft/vscode-python/releases/download/${CODESERVER_PYTHON_VERSION}/ms-python-release.vsix" \
 && code-server --install-extension /tmp/ms-python-release.vsix \
 && code-server --list-extensions --show-versions

# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc

# s6 - 01-copy-tmp-home
USER root
RUN mkdir -p /tmp_home \
 && cp -r ${HOME} /tmp_home \
 && chown -R ${NB_USER}:users /tmp_home
USER ${NB_UID}
