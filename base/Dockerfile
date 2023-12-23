# Use the respective Makefile to build the image.
FROM nvidia/cuda:12.2.0-devel-ubuntu20.04
# FROM nvidia/cuda:11.6.2-devel-ubuntu20.04
# FROM kaldiasr/kaldi:latest
# FROM kaldiasr/kaldi:latest

# common environemnt variables
ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_PREFIX /
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash

# args - software versions
ARG KUBECTL_ARCH="amd64"
ARG KUBECTL_VERSION=v1.27.3
ARG S6_ARCH="amd64"
 # renovate: datasource=github-tags depName=just-containers/s6-overlay versioning=loose
ARG S6_VERSION=v2.2.0.3

# set shell to bash
SHELL ["/bin/bash", "-c"]

# install - useful linux packages
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    apt-transport-https \
    bash \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gnupg \
    gnupg2 \
    locales \
    lsb-release \
    nano \
    software-properties-common \
    tzdata \
    unzip \
    vim \
    wget \
    zip \
    tree \
    jq \
    htop \
    texinfo \
    man-db \
    less \
    libgit2-dev \
    libsecret-1-0 \
    libxml2-dev \
    pandoc \
    pandoc-citeproc \
    gdebi-core \
    make \
    bat \
   #  duf \
   #  bpytop \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# RUN curl -fsSL https://azlux.fr/repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/azlux-archive-keyring.gpg
# RUN echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian \
#   $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azlux.list >/dev/null
# RUN apt-get -yq update && apt-get -yq install docker-ctop

# install diff-so-fancy
RUN mkdir -p ~/bin
WORKDIR ~/bin
RUN git clone https://github.com/so-fancy/diff-so-fancy diffsofancy
RUN chmod +x diffsofancy/diff-so-fancy
RUN ln -s ~/bin/diffsofancy/diff-so-fancy ~/bin/diff-so-fancy

# install quarto
RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

# install Fira Code
# WORKDIR /opt

# RUN apt-get update && \
#     apt-get install -y libcairo2 libcairo2-dev
# RUN apt-get update && apt-get -yq install python3-pip
# RUN pip install --upgrade Pillow==10.0.0 idna==3.4 requests==2.31.0 urllib3==2.0.4 pycairo==1.24.0 gftools==0.9.33 fontmake==3.7.1 fontbakery==0.8.13
# RUN apt-get update && \
#     apt-get install -y ttfautohint && \
#     apt-get install -y woff2 && \
#     apt-get install -y sfnt2woff-zopfli

RUN apt-get update && apt install -y fontconfig fonts-firacode

# install - s6 overlay
RUN export GNUPGHOME=/tmp/ \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer" -o /tmp/s6-overlay-${S6_VERSION}-installer \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer.sig" -o /tmp/s6-overlay-${S6_VERSION}-installer.sig \
 && gpg --keyserver keys.gnupg.net --keyserver pgp.surfnet.nl --recv-keys 6101B2783B2FD161 \
 && gpg -q --verify /tmp/s6-overlay-${S6_VERSION}-installer.sig /tmp/s6-overlay-${S6_VERSION}-installer \
 && chmod +x /tmp/s6-overlay-${S6_VERSION}-installer \
 && /tmp/s6-overlay-${S6_VERSION}-installer / \
 && rm /tmp/s6-overlay-${S6_VERSION}-installer.sig /tmp/s6-overlay-${S6_VERSION}-installer

# install - kubectl
RUN curl -sL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" -o /usr/local/bin/kubectl \
 && curl -sL "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl.sha256" -o /tmp/kubectl.sha256 \
 && echo "$(cat /tmp/kubectl.sha256) /usr/local/bin/kubectl" | sha256sum --check \
 && rm /tmp/kubectl.sha256 \
 && chmod +x /usr/local/bin/kubectl

# create user and set required ownership
RUN useradd -M -s /bin/bash -N -u ${NB_UID} ${NB_USER} \
 && mkdir -p ${HOME} \
 && chown -R ${NB_USER}:users ${HOME} \
 && chown -R ${NB_USER}:users /usr/local/bin \
 && chown -R ${NB_USER}:users /etc/s6

# set locale configs
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER $NB_UID
