# DSCI 310 Group 13
# Project Title: Predicting Youtube View Count in 2007/2008

## Contributors: Chris Cai, Maggie Dong, Billy Jia

## Summary:
Youtube is one of the most popular websites in the world. Many people at some point in their lives may have thought whether or not they wanted to become a Youtuber as a future job. Data research and analysis would help any person looking to become a Youtuber to figure out how certain categories of data impact the number of views on a video. This analysis will try to predict the future view counts of Youtube videos based on previous view counts. The dataset used tracks categories like video ID, uploader, **age**, category, **length**, **views**, **rate**, **rating**, **comment count** and related IDs, but only the data in bold will be explored in the analysis as the other features are not important towards the prediction. <br><br>
**Note**: the report will be under `'analysis/'` folder in the container after following the steps in the section below - "Procedure of generating the report". 

## Procedure of generating the report
To **setup**, please follow the steps below: 
1. Install [Docker](https://www.docker.com/get-started)
2. In the terminal, use the following command to download the Docker image:
   ```
   docker pull chrisckh/dsci-310-project-group-13:0.0.0
   ```
3. Use the following command to run the Rstudio container:
   ```
   docker run --rm -p 8787:8787 -e PASSWORD="asdf" chrisckh/dsci-310-project-group-13:0.0.0
   ```
4. Use the following to open the container in a web browser:
   ```
   http://localhost:8787/
   ```
5. Login with with Username: `rstudio` , and Password: `asdf`. 


To **generate the report**, please follow the steps below: 
1. In the terminal of the Rstudio container, use the following command to to generate the report, all the figures, tables and data files:
   ```
   make all
   ```

## Other make commands:
1. The following command can be used to read the raw YouTube data files for 2007 and 2008 and write out as **data2007_not_cleaned.txt** and **data2008_not_cleaned.txt**. These two files will be saved into the folder **'data/'** in the container.
   ```
   make load
   ```
2. The following command can be used to remove unnecessary columns and converts category variable as factor class and save the cleaned data sets, which will be called as **data2007_cleaned.txt** and **data2008_cleaned.txt**, into the folder 'data/' in the container.
   ```
   make tidy
   ```
    **Note**: `make load` should be run before `make tidy`<br><br>
3. The following command can be used to create four figures used in the report, into the folder 'output/' in the container.
   ```
   make figures
   ```
    **Note**: `make load` and `make tidy` should be run before `make figures`<br><br>

4. To Do
   ```
   make models
   ```
    **Note**: `make load` and `make tidy` should be run before `make models`<br><br>

5. The following command can be used to create the report, which will be saved into the folder 'analysis/' in the container.
   ```
   make render
   ```
    **Note**: all the commands listed above should be run before `make render` <br><br>

6. The following command can be used to delete all files and folders generated by `make all`
   ```
   make clean
   ```

## Dependencies:
Docker<br>
R version 4.2.2, R packages, analysis.Rmd, Makefile, and raw data used can be found in the Dockerfile<br>
R packages with version:<br>
- 'remote', latest
- 'base64enc', '0.1-3'
- 'digest', '0.6.31'
- 'evaluate', '0.20'
- 'glue', '1.6.2'
- 'xfun', '0.37'
- 'highr', '0.10'
- 'rlang', '1.0.6'
- 'fastmap', '1.1.0'
- 'ellipsis', '0.3.2'
- 'htmltools', '0.5.4'
- 'jsonlite', '1.8.4'
- 'yaml', '2.3.7'
- 'knitr', '1.42'
- 'magrittr', '2.0.3'
- 'commonmark', '1.8.1'
- 'markdown', '1.5'
- 'mime', '0.12'
- 'bslib', '0.4.2'
- 'jquerylib', '0.1.4'
- 'cli', '3.6.0'
- 'lifecycle', '1.0.3'
- 'stringi', '1.7.12'
- 'vctrs', '0.5.2'
- 'stringr', '1.5.0'
- 'tinytex', '0.44'
- 'rmarkdown', '2.20'
- 'tidyverse', '1.3.2'
- 'car', '3.1-1'
- 'corrplot', '0.92'
- 'tidymodels', '1.0.0'
- 'leaps', '3.1'
- 'testthat', '3.1.6'
- 'here', '1.0.1'
- 'kableExtra', '1.3.4'


## License
The predict-youtube-future-views project is made available under the **Attribution 4.0 International** ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/))
