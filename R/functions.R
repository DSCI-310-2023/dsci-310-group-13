library(tidyverse)
library(tidymodels)
library(corrplot)
library(car)
library(leaps)
library(here)
library(testthat)


#' This function takes in a path to where the file located and read the data
#'
#' @param path_to_file The path to where the file is located 
#'
#' @returns a data frame that contains raw data in the file 
#'
#' @examples
#' # read_raw_data("/home/rstudio/data/0007.txt")
#' # read_raw_data("/home/rstudio/data/0107.txt")
#'

read_raw_data <- function(path_to_file){
  file_paths <- list("/home/rstudio/data/0007.txt", "/home/rstudio/data/0107.txt",
                     "/home/rstudio/data/0207.txt", "/home/rstudio/data/0307.txt",
                     "/home/rstudio/data/0008.txt", "/home/rstudio/data/0108.txt",
                     "/home/rstudio/data/0208.txt", "/home/rstudio/data/0308.txt")
  if (!({{path_to_file}} %in% file_paths)) {
    stop("Please look at the data folder and provide a valid input!")
    
    
  }
  read.delim({{path_to_file}}, header = FALSE, sep = "\t", dec = ".")
}


#' This function combines all the raw data tables that contains raw data in one
#' year and remove all rows with NA in the table
#'
#' @param t1 The first raw data table to be combined 
#' @param t2 The second raw data table to be combined 
#' @param t3 The third raw data table to be combined
#' @param t4 The fourth raw data table to be combined
#' 
#' @returns a data frame that contains all raw data in one year 
#'
#' @examples
#' # bind_tables(table0007,table0107,table0207, table0307)
#' # bind_tables(table0008,table0108,table0208, table0308)
#'
bind_tables <- function(t1, t2, t3, t4){
  rbind(t1, t2, t3, t4)|> na.omit()
}


#' This function takes in a YouTube Data that read from raw data and
#' Remove unnecessary data and convert category variable as factor class
#'
#' @param data The YouTube data frame that reads from raw file and requires 
#' removing it's unnecessary data and converting it's category variable 
#'
#' @returns a YouTube data frame that only contains "age", 'category',
#' 'length','views','rate','ratings','comments' as columns; If it is 
#' not a data frame, an error message would be "Please input a valid 
#' dataframe!"; 
#'
#' @examples
#' # wrangling_data(data2007_test)
#' # wrangling_data(data2008_test)
#'
wrangling_data <- function(data) {
  if (!(is.list(data))){
    stop("Please have a valid dataframe as input!")
  }
  data|> select(-c(1,2,10:29)) |> mutate(category = as.factor(category))
}


## Regression function:
#' The function accepts the wrangled Youtube dataset of type dataframe and fits a linear regression
#' model to the data.
#'
#' @param traindata: Typically a portion of the dataset that is used for training a regression model 
#'
#' @returns a linear regression model with 'views' as the response variable and the chosen variables
#' as the explanatory variables
#'
#' @examples
#' # fit_regression(training)

fit_regression <- function(traindata){
  stopifnot(is.data.frame(traindata))
  lm_spec <- linear_reg() |> set_engine('lm') |> set_mode('regression')
  
  lm_recipe <- recipe(views~., data = traindata)
  
  lm_fit <- workflow() |> add_recipe(lm_recipe) |> add_model(lm_spec) |> fit(data = traindata)
  
  lm_fit
}


#' This function takes in a path to where the uncleaned data file saved by load.R
#' located and read the data
#'
#' @param path_to_file The path to where the file is located 
#'
#' @returns a data frame that contains uncleaned data saved by R/load.R 
#'
#' @examples
#' # read_raw_data("/home/rstudio/data/data2007_not_cleaned.txt")
#' # read_raw_data("/home/rstudio/data/data2008_not_cleaned.txt")
#'

read_uncleaned_data <- function(path_to_file){
  file_paths <- list("/home/rstudio/data/data2008_not_cleaned.txt", 
                     "/home/rstudio/data/data2007_not_cleaned.txt")
  if (!({{path_to_file}} %in% file_paths)) {
    stop("Please look at the data folder and provide a valid input!")
  }
  
  youtube_col_names <- c("Video ID", "uploader", "age", 'category','length',
                         'views','rate','ratings','comments','related IDs')
  
  result = read.delim({{path_to_file}}, sep = "\t", dec = ".", header = TRUE)
  colnames(result) <- youtube_col_names
  return(result)
  
}