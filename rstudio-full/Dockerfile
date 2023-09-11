# Use the respective Makefile to pass the appropriate BASE_IMG and build the image correctly
ARG BASE_IMG=<rstudio>
FROM $BASE_IMG

# args - software versions
ARG R_TIDYVERSE_VERSION="2.0.0"
ARG R_TIDYMODELS_VERSION="1.1.1"
ARG R_MLR3VERSE_VERSION="0.2.8"

# switch to root user for conda installation
# (only necessary when installing r-tidyverse with Kaniko)
USER root

# install - r-tidyverse
RUN conda install -y -q \
    r-tidyverse=${R_TIDYVERSE_VERSION} \
    r-tidymodels=${R_TIDYMODELS_VERSION} \
    r-mlr3verse=${R_MLR3VERSE_VERSION} \
 && conda update -y -q --all \
 && conda clean -a -f -y \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# install r packages
ADD r-packages-install.sh /tmp/r-packages-install.sh
ADD r-packages.txt /tmp/r-packages.txt
RUN chmod 777 /tmp/r-packages-install.sh
# RUN R -e "install.packages('testthat', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN bash /tmp/r-packages-install.sh
# RUN chown -R jovyan:root /home/jovyan/.local/share/code-server

RUN R -e "torch::install_torch()"
# RUN R -e "reticulate::install_python(version = '3.11')"
# RUN R -e "keras::install_keras()"
RUN R -e "install.packages('mlr3proba', repos = 'https://mlr-org.r-universe.dev')"

USER ${NB_USER}
