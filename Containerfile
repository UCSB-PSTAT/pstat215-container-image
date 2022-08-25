FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update ; \
    apt-get install -y texlive-full ; \ 
    apt-get clean

RUN R -e "install.packages(c('tidyverse', 'tidybayes', 'rstan', 'shinystan', 'loo', 'coda', 'HDInterval', 'testthat', 'MASS', 'plot-penguins', 'packrat', 'rsconnect'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

USER $NB_USER

