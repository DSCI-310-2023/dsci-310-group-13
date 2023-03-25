# author: Billy Jia
# date: March 24, 2023

"Loads in data from data table and removes unnecessary columns and 
converts category variable as factor class

Usage: /home/rstudio/R/tidy.R <input_one> <input_two> <output_one> <output_two>  
" -> doc

source("/home/rstudio/R/functions.R")

library(docopt)
opt <- docopt(doc)

main <- function(input1, input2) {
  table1 <- read_uncleaned_data(input1);
  table2 <- read_uncleaned_data(input2);
  table1|> select(-c(1,2,10:29)) |> mutate(category = as.factor(category));
  table2|> select(-c(1,2,10:29)) |> mutate(category = as.factor(category));
}

main(opt$input_one, opt$input_two)
