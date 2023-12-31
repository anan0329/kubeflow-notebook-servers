# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<base>
FROM $BASE_IMG

USER root

# args - software versions
ARG MINIFORGE_ARCH="x86_64"
# renovate: datasource=github-tags depName=conda-forge/miniforge versioning=loose
ARG MINIFORGE_VERSION=23.3.1-1
ARG PIP_VERSION=23.1.2
ARG PYTHON_VERSION=3.11.5
ARG RSTUDIO_ARCH="amd64"
# renovate: datasource=github-tags depName=rstudio/rstudio versioning=semver
ARG RSTUDIO_VERSION=2023.12.0+369
ARG R_BASE_VERSION=4.3.2
ARG R_RETICULATE_VERSION=1.34
ARG R_PNG_VERSION=0.1_8

# install - binary rstudio dependencies
RUN apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
#  build-essential \
    dpkg-sig \
    libapparmor1 \
    libc6 \
    libclang-dev \
    libedit2 \
    libpq5 \
    psmisc \
    rrdtool \
    sudo \ 
    gdebi-core \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# RUN apt-get install --only-upgrade libstdc++6

RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -yq update
RUN apt-get -yq upgrade
RUN apt-get -yq dist-upgrade

RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX

# setup environment for conda
ENV CONDA_DIR /opt/conda
ENV PATH "${CONDA_DIR}/bin:${PATH}"
RUN mkdir -p ${CONDA_DIR} \
 && echo ". /opt/conda/etc/profile.d/conda.sh" >> ${HOME}/.bashrc \
 && echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile \
 && echo "conda activate base" >> ${HOME}/.bashrc \
 && echo "conda activate base" >> /etc/profile \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# setup environment for R
ENV R_HOME ${CONDA_DIR}/lib/R

USER ${NB_UID}

# install - conda, pip, python, r-base
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
   #  libgcc=5.2.0 \
 && conda update -y -q --all \
 && conda clean -a -f -y \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# set default CRAN repo to RSPM (it has pre-compiled R packages, increasing user install speed)
RUN echo 'options(repos=c(CRAN="https://packagemanager.rstudio.com/all/__linux__/focal/latest"))' >> ${R_HOME}/etc/Rprofile.site \
 && echo 'options(HTTPUserAgent=sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> ${R_HOME}/etc/Rprofile.site

# R needs TZ set
ENV TZ Etc/UTC
RUN echo "TZ=${TZ}" >> ${R_HOME}/etc/Renviron.site

USER root

# install - rstudio-server
# Affero General Public License may apply to RStudio: https://www.gnu.org/licenses/agpl-3.0.en.html
# RUN curl -sL "https://download2.rstudio.org/server/bionic/${RSTUDIO_ARCH}/rstudio-server-${RSTUDIO_VERSION//+/-}-${RSTUDIO_ARCH}.deb" -o /tmp/rstudio-server.deb \
RUN curl -sL "https://download2.rstudio.org/server/focal/${RSTUDIO_ARCH}/rstudio-server-${RSTUDIO_VERSION//+/-}-${RSTUDIO_ARCH}.deb" -o /tmp/rstudio-server.deb \
    # add rstudio public code-signing key
 && gpg --keyserver keys.gnupg.net --keyserver pgp.surfnet.nl --recv-keys 3F32EE77E331692F \
    # validate the build signature
#  && dpkg-sig --verify /tmp/rstudio-server.deb \
 && dpkg -i /tmp/rstudio-server.deb \
 && rm -f /tmp/rstudio-server.deb \
    # our Kaniko build excludes `/var/run/*` but RStudio needs those files,
    # so we move them to `/run`, wich is actually the same place due to symbolic links
 && mv -n /var/run/rstudio-server* /run \
    # use advisory file-locks to improve PVC support
 && echo "lock-type=advisory" > /etc/rstudio/file-locks \
    # allow kubeflow to display rstudio in an iframe
 && echo "www-frame-origin=same" >> /etc/rstudio/rserver.conf \
    # allows the non-root NB_USER to run rstudio
 && chown -R ${NB_USER}:users /etc/rstudio \
 && chown -R ${NB_USER}:users /run/rstudio-server* \
 && chown -R ${NB_USER}:users /usr/lib/rstudio-server \
 && chown -R ${NB_USER}:users /var/lib/rstudio-server

# tell rstudio to use conda python by setting `RETICULATE_PYTHON` with `--rsession-path=/opt/rsession.sh`
COPY --chown=jovyan:users rsession.sh /opt
RUN chmod +x /opt/rsession.sh

RUN R -e "install.packages('rstudioapi')"
RUN git clone https://github.com/lusignan/RStudio-Material-Theme.git


# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc

# s6 - 01-copy-tmp-home
RUN mkdir -p /tmp_home \
 && cp -r ${HOME} /tmp_home \
 && chown -R ${NB_USER}:users /tmp_home

# USER ${NB_UID}
USER root

EXPOSE 8888

ENTRYPOINT ["/init"]
