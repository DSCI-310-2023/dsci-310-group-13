FROM rocker/rstudio:4.2.2

#install packages for Knit
RUN Rscript -e "install.packages('remotes', repos='http://cran.us.r-project.org')"
RUN Rscript -e "remotes::install_version('base64enc','0.1-3')"
RUN Rscript -e "remotes::install_version('digest','0.6.31')"
RUN Rscript -e "remotes::install_version('evaluate','0.20')"
RUN Rscript -e "remotes::install_version('glue','1.6.2')"
RUN Rscript -e "remotes::install_version('xfun','0.37')"
RUN Rscript -e "remotes::install_version('highr','0.10')"
RUN Rscript -e "remotes::install_version('rlang','1.0.6')"
RUN Rscript -e "remotes::install_version('fastmap','1.1.0')"
RUN Rscript -e "remotes::install_version('ellipsis','0.3.2')"
RUN Rscript -e "remotes::install_version('htmltools','0.5.4')"
RUN Rscript -e "remotes::install_version('jsonlite','1.8.4')"
RUN Rscript -e "remotes::install_version('yaml','2.3.7')"
RUN Rscript -e "remotes::install_version('knitr','1.42')"
RUN Rscript -e "remotes::install_version('magrittr','2.0.3')"
RUN Rscript -e "remotes::install_version('commonmark','1.8.1')"
RUN Rscript -e "remotes::install_version('markdown','1.5')"
RUN Rscript -e "remotes::install_version('mime','0.12')"
RUN Rscript -e "remotes::install_version('bslib','0.4.2')"
RUN Rscript -e "remotes::install_version('jquerylib','0.1.4')"
RUN Rscript -e "remotes::install_version('cli','3.6.0')"
RUN Rscript -e "remotes::install_version('lifecycle','1.0.3')"
RUN Rscript -e "remotes::install_version('stringi','1.7.12')"
RUN Rscript -e "remotes::install_version('vctrs','0.5.2')"
RUN Rscript -e "remotes::install_version('stringr','1.5.0')"
RUN Rscript -e "remotes::install_version('tinytex','0.44')"
RUN Rscript -e "remotes::install_version('rmarkdown','2.20')"

#package used 
RUN Rscript -e "remotes::install_version('tidyverse','1.3.2')"
RUN Rscript -e "remotes::install_version('car','3.1-1')"
RUN Rscript -e "remotes::install_version('corrplot','0.92')"


RUN Rscript -e "remotes::install_version('tidymodels','1.0.0')"
RUN Rscript -e "remotes::install_version('leaps','3.1')"
RUN Rscript -e "remotes::install_version('testthat','3.1.6')"
RUN Rscript -e "remotes::install_version('here','1.0.1')"

#set home directory to /home/rstudio
WORKDIR /home/rstudio
#copy the data used by project to the container
COPY --chown=rstudio:rstudio ./data/0007.txt ./data/0007.txt
COPY --chown=rstudio:rstudio ./data/0107.txt ./data/0107.txt
COPY --chown=rstudio:rstudio ./data/0207.txt ./data/0207.txt
COPY --chown=rstudio:rstudio ./data/0307.txt ./data/0307.txt

COPY --chown=rstudio:rstudio ./data/0008.txt ./data/0008.txt
COPY --chown=rstudio:rstudio ./data/0108.txt ./data/0108.txt
COPY --chown=rstudio:rstudio ./data/0208.txt ./data/0208.txt
COPY --chown=rstudio:rstudio ./data/0308.txt ./data/0308.txt
#
COPY --chown=rstudio:rstudio ./R/functions.R ./R/functions.R
COPY --chown=rstudio:rstudio ./R/load.R ./R/load.R
COPY --chown=rstudio:rstudio ./Makefile .
COPY --chown=rstudio:rstudio ./tests/tests.R ./tests/tests.R
COPY --chown=rstudio:rstudio ./analysis/analysis.Rmd ./analysis/analysis.Rmd

#fix the error in container:
#Warning message:
#In grDevices::grSoftVersion() :
#  unable to load shared object '/usr/local/lib/R/modules//R_X11.so':
#  libXt.so.6: cannot open shared object file: No such file or directory
#source1: https://github.com/labsyspharm/naivestates/blob/master/Dockerfile
#source2: https://notes.rmhogervorst.nl/post/2020/09/23/solving-libxt-so-6-
#cannot-open-shared-object-in-grdevices-grsoftversion/
RUN apt-get update && apt-get -y --no-install-recommends install libxt6

RUN Rscript -e "remotes::install_version('devtools','2.4.5')"