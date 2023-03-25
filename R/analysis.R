# author: Maggie Dong

"
Loads in tidy data and generates the tables for the preliminary analysis and 
analysis section


Usage: /home/R/analysis.R <input_dir1> <input_dir2> <output_dir> 
" -> doc

library(docopt)
library(tidyverse)
library(tidymodels)
library(car)

opt <- docopt(doc)

source("/home/rstudio/R/functions.R")

main <- function(input_dir1, input_dir2, out_dir){
  
  # Load data from clean.R
  data2007 = read.delim(input_dir1, 
                        sep = "\t", dec = ".", header = TRUE)
  data2008 = read.delim(input_dir2, 
                        sep = "\t", dec = ".", header = TRUE)
  
  # Pre-process the data
  
  datareduced <- data2007 |>  select(c(views,age,ratings,comments))
  split <- initial_split(datareduced, prop = 3/4, strata = views)
  train <- training(split)
  test <- testing(split)
  lm_fit <- fit_regression(train)
  
  data2008reduced <- data2008 |> select(c(age,ratings,comments))
  predict2008 <- predict(lm_fit,data2008reduced)
  
  # Table of the fitted model metrics
  
  lm_test_results <- lm_fit |> predict(test) |> bind_cols(test) |> metrics(truth = views, estimate = .pred)
  write_csv(lm_test_results, file.path(out_dir, "lm_test_results.csv"))
  
  # Table comparing predicted and observed values
  
  predict_vs_obs <- head(cbind('Actual' = data2008$views,"Predicted" = predict2008))
  write_csv(predict_vs_obs, file.path(out_dir, "predict_vs_obs.csv"))
}

main(opt$input_dir1,opt$input_dir2, opt$output_dir)
