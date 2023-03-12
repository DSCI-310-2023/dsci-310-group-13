library(tidyverse)
library(tidymodels)
library(corrplot)
library(car)
library(leaps)
library(here)
library(testthat)
# Get the working directory 
getwd();
# In case this directory is not the location the data files are located in,
# either Use the Tools | Change Working Dir... menu (Session | Set Working Directory on a mac). 
# This will also change directory location of the Files pane.
# or
# directory <- 'path/to/my/working/directory'
#Set base directory
base_dir <- '/home/rstudio/data/';

#instantiate empty list
total_list <- list();

# read all files in the folder
# this assumes that all the data files are in the same folder
all_files <- paste0(base_dir, list.files(base_dir, recursive = TRUE))

# Reads all files with extensions that match the format of the data, while 
# ignoring other files, returns a list of strings with table names, but not
# the actual table data
remove_non_text_files <- function(file_list) {
    i = 0;
    for(file in file_list){
        if(!endsWith(file, '.R') && !endsWith(file, '.zip')){
            if(startsWith(file, 'data/0') || startsWith(file, 'data/1')){
                i = i + 1;
                print(file_list[i])
                total_list <- append(total_list, file_list[i])
            }
            
        }
    }
    return(total_list)
}

total_list <- remove_non_text_files(all_files);
total_list <- unlist(total_list)
#test that the all_files inputs all data from the folder
testthat::expect_identical(total_list[1], 'data/0007.txt')
testthat::expect_identical(total_list[8], 'data/0308.txt')

# takes a list of strings with file names, in order to 
# load in data and combine into 1 dataframe
list_of_data <- function(fileList) {
    j = 0;
    for(file in fileList) {
        j = j + 1;
        temporary_file <- read.delim(fileList[j], header = FALSE, sep = '\t', dec = '.');
        total_list <- rbind(total_list, temporary_file);
    }
    return(total_list);
}

total_list <- list_of_data(total_list);

#removes any NA or negative values, taking a dataframe as a parameter
remove_negatives <- function(dataTable) {
    dataTable <- dataTable[-c(1),];
    temp_table <- dataTable;
    temp_table[temp_table < 0] <- NA
    return(temp_table);
}

negatives_deleted = remove_negatives(total_list)


total_list_clean <- na.omit(negatives_deleted)

#assign column names to the table
colnames(total_list_clean) <- c("Video ID", "uploader", "age", 'category','length','views','rate','ratings','comments','related IDs')

testthat::expect_identical(colnames(total_list_clean)[1], "Video ID")
testthat::expect_identical(colnames(total_list_clean)[10], "related IDs")


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
rm("data2007", "data2008", "data2007_test","data2008_test")
