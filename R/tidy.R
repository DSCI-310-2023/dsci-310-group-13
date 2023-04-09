# author: Billy Jia
# date: March 24, 2023

"
Loads in data from data table and removes unnecessary columns and 
converts category variable as factor class and writes cleaned data into data
foler(the data will be called 'data2007_cleaned.txt' and 
'data2008_cleaned.txt') to be saved under '/home/rstudio/data/'. Code adapted
from https://github.com/UBC-DSCI/dsci-310-individual-assignment-repro-reports

Usage: /home/rstudio/R/tidy.R <input_one> <input_two> <output_one> <output_two>  
" -> doc

library(youtubeFunction)

library(docopt)
opt <- docopt(doc)

#This functions takes absolute pass of the data files 
#for example, "/home/rstudio/data/0007.txt"
main <- function(input1, input2, output1, output2){
  
  #read uncleaned data created by load.R 
  uncleaned_2007 <- read_uncleaned_data(input1)
  uncleaned_2008 <- read_uncleaned_data(input2)
  
  #clean data 
  cleaned_2007 <- wrangling_data(uncleaned_2007)
  cleaned_2008 <- wrangling_data(uncleaned_2008)
  
  #write cleaned data into data/ folder
  write.table(cleaned_2007, file = output1, sep = "\t",
              row.names = FALSE, col.names = TRUE)
  
  write.table(cleaned_2008, file = output2, sep = "\t",
              row.names = FALSE, col.names = TRUE)
  
  #remove all temporary tables
  rm(list = ls())
  
}

main(opt$input_one, opt$input_two, opt$output_one, opt$output_two)