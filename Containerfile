FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y texlive-full lmodern python3-dev libbz2-dev libxt-dev nano libgdal-dev locate && \
    apt-get clean

RUN conda install -y -c conda-forge cmdstan udunits2 gdal r-sf r-terra r-inlabru && \
    chown -Rf jovyan /opt/conda/bin/cmdstan

RUN R -e "install.packages(c('tidyverse','tidybayes', 'rstan', 'shinystan', 'loo', 'coda', 'fmesher', 'HDInterval', 'testthat', 'MASS', 'palmerpenguins', 'packrat', 'rsconnect'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e "install.packages(c('cmdstanr', 'rstan', 'StanHeaders'), repos = 'https://mc-stan.org/r-packages/', Ncpus = parallel::detectCores())"

RUN R -e "install.packages('INLA',repos = 'https://inla.r-inla-download.org/R/stable', Ncpus = parallel::detectCores())"

ENV TZ PST

ENV CMDSTAN /opt/conda/bin/cmdstan

RUN /usr/bin/echo -e 'CMDSTAN=/opt/conda/bin/cmdstan\nCMDSTANR_NO_VER_CHECK=TRUE' > /etc/skel/.Renviron

USER $NB_USER

CMD cp /etc/skel/.Renviron ~/ && "start-notebook.sh"
