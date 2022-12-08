FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano && \
    apt-get clean

RUN mamba install -y -c conda-forge cmdstan

RUN R -e "install.packages(c('tidyverse','tidybayes', 'rstan', 'shinystan', 'loo', 'coda', 'HDInterval', 'testthat', 'MASS', 'palmerpenguins', 'packrat', 'rsconnect'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e "install.packages(c('cmdstanr', 'StanHeaders'), repos = 'https://mc-stan.org/r-packages/', Ncpus = parallel::detectCores())"

ENV TZ PST

USER $NB_USER

CMD echo "CMDSTAN=/opt/conda/bin/cmdstan\nCMDSTANR_NO_VER_CHECK=TRUE" > ~/.Renviron && "start-notebook.sh"
