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

#set home directory to /home/rstudio
WORKDIR /home/rstudio
#copy the data used by project to the container
COPY --chown=rstudio:rstudio /data/datatable2007.txt . 
COPY --chown=rstudio:rstudio /data/datatable2008.txt . 
#package used 
RUN Rscript -e "remotes::install_version('tidyverse','1.3.2')"
RUN Rscript -e "remotes::install_version('car','3.1-1')"
RUN Rscript -e "remotes::install_version('corrplot','0.92')"


RUN Rscript -e "remotes::install_version('tidymodels','1.0.0')"
RUN Rscript -e "remotes::install_version('leaps','3.1')"