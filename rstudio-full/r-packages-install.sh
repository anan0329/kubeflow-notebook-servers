#!/usr/bin/env bash

cat /tmp/r-packages.txt | while read package || [[ -n $package ]];
do
  R -e "install.packages('$package', dependencies=TRUE, repos='http://cran.rstudio.com/')"
done