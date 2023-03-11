library(tidyverse)
library(car)
library(leaps)
library(dplyr)

##TODO 
#write functions to READ DATA
# Load in May 5th 2007 data
table0007 <- read.delim("/home/rstudio/data/0007.txt", header = FALSE, sep = "\t", dec = ".")
table0107 <- read.delim("/home/rstudio/data/0107.txt", header = FALSE, sep = "\t", dec = ".")
table0207 <- read.delim("/home/rstudio/data/0207.txt", header = FALSE, sep = "\t", dec = ".")
table0307 <- read.delim("/home/rstudio/data/0307.txt", header = FALSE, sep = "\t", dec = ".")

data2007_test <- rbind(table0007,table0107,table0207, table0307)|> na.omit()
colnames(data2007_test) <- c("Video ID", "uploader", "age", 'category','length',
                             'views','rate','ratings','comments','related IDs')

# Load in May 4th 2008 data
table0008 <- read.delim("/home/rstudio/data/0008.txt", header = FALSE, sep = "\t", dec = ".")
table0108 <- read.delim("/home/rstudio/data/0108.txt", header = FALSE, sep = "\t", dec = ".")
table0208 <- read.delim("/home/rstudio/data/0208.txt", header = FALSE, sep = "\t", dec = ".")
table0308 <- read.delim("/home/rstudio/data/0308.txt", header = FALSE, sep = "\t", dec = ".")

data2008_test <- rbind(table0008,table0108,table0208, table0308)|> na.omit()
colnames(data2008_test) <- c("Video ID", "uploader", "age", 'category','length',
                             'views','rate','ratings','comments','related IDs')
#remove temporary dataframes from the workspace
rm("table0007", "table0008", "table0107", "table0108", "table0207", "table0208",
   "table0307", "table0308")
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

##TODO
## function for analysis

rm("data2007", "data2008", "data2007_test","data2008_test")

