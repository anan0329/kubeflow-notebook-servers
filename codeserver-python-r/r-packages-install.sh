#!/usr/bin/env bash

cat /tmp/r-packages.txt | while read extension || [[ -n $package ]];
do
  RUN R -e "install.packages('$package', dependencies=TRUE, repos='http://cran.rstudio.com/')"
#   code-server --install-extension $extension
done