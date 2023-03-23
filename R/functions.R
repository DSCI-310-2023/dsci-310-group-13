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

youtube_col_names <- c("Video ID", "uploader", "age", 'category','length',
                       'views','rate','ratings','comments','related IDs')

# Load in May 5th 2007 data
table0007 <- read_raw_data("/home/rstudio/data/0007.txt")
table0107 <- read_raw_data("/home/rstudio/data/0107.txt")
table0207 <- read_raw_data("/home/rstudio/data/0207.txt")
table0307 <- read_raw_data("/home/rstudio/data/0307.txt")

data2007_test <- bind_tables(table0007,table0107,table0207, table0307)
colnames(data2007_test) <- youtube_col_names

# Load in May 4th 2008 data
table0008 <- read_raw_data("/home/rstudio/data/0008.txt")
table0108 <- read_raw_data("/home/rstudio/data/0108.txt")
table0208 <- read_raw_data("/home/rstudio/data/0208.txt")
table0308 <- read_raw_data("/home/rstudio/data/0308.txt")

data2008_test <- bind_tables(table0008,table0108,table0208, table0308)
colnames(data2008_test) <- youtube_col_names

rm("table0007","table0107", "table0207","table0307",
   "table0008","table0108", "table0208","table0308" )
##TODO
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


data2007 = wrangling_data(data2007_test)
data2008 = wrangling_data(data2008_test)
#The first and second test expects that the age in the first and last row 
#of the wrangled data is the same 
testthat::expect_equal(select(data2007, c('age'))[1,], 
                       select(data2007_test, c('age'))[1,])

testthat::expect_equal(select(data2007, c('age'))[62101,], 
                       select(data2007_test, c('age'))[62101,])

#The third and fourth test expects that the comments in the first and last row 
#of the wrangled data is the same 
testthat::expect_equal(select(data2008, c('comments'))[1,], 
                       select(data2008_test, c('comments'))[1,])

testthat::expect_equal(select(data2008, c('comments'))[62101,], 
                       select(data2008_test, c('comments'))[62101,])

#The fifth and sixth test expects errors because the input is not a valid data frame
testthat::expect_error(wrangling_data("sad"),"Please have a valid dataframe as input!")
testthat::expect_error(wrangling_data(3),"Please have a valid dataframe as input!")

#The seventh and eighth test expects the number of columns is 7 which only contains
#the required features
testthat::expect_equal(ncol(data2007), 7)
testthat::expect_equal(ncol(data2008), 7)


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


#Testing

# Selecting variables for reduced model
datareduced <- data2007 |>  select(c(views,age,ratings,comments))

# Split data into training and testing set
split <- initial_split(datareduced, prop = 3/4, strata = views)
train <- training(split)
test <- testing(split)

# Fit the regression model
lm_spec <- linear_reg() |> set_engine('lm') |> set_mode('regression')

lm_recipe <- recipe(views~., data = train)

lm_fit <- workflow() |> add_recipe(lm_recipe) |> add_model(lm_spec) |> fit(data = train)

# The results our model performed
lm_test_results <- lm_fit |> predict(test) |> bind_cols(test) |> metrics(truth = views, estimate = .pred)

#test if parameter is a dataframe
testthat::expect_error(fit_regression(c(1:5)))
testthat::expect_error(fit_regression("hello"))

#test that the model is formed properly:
# coefficients
expect_equal(as.numeric(tidy(lm_fit)$estimate[1]), as.numeric(lm(views~.,train)$coefficients[1]))
# rmse
expect_equal(lm_test_results$.estimate[1],
             sqrt(mean((test$views - predict(lm_fit, test)$.pred)^2)))


#remove all temporary variables 
rm("datareduced", "split", "train", "test", "lm_spec", "lm_recipe", "lm_fit",
   "lm_test_results")
rm("data2007", "data2008","data2007_test","data2008_test", "youtube_col_names")
