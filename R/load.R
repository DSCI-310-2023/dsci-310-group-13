# author: Chris Cai
# date: 2023-03-23

"
Loads youtube videos data in 2007 and 2008 (downloaded from
https://netsg.cs.sfu.ca/youtubedata/) and writes the not cleaned data into data
foler(the data will be called 'data2007_not_cleaned.txt' and 
'data2008_not_cleaned.txt') to be saved under '/home/rstudio/data/'. Code adapted
from https://github.com/UBC-DSCI/dsci-310-individual-assignment-repro-reports

Usage: /home/rstudio/R/load.R <input_one> <input_two> <input_three> <input_four> <input_five> <input_six> <input_seven> <input_eight> <output_one> <output_two>  
" -> doc

library(youtubeFunction)

library(docopt)
opt <- docopt(doc)

#This functions takes absolute pass of the data files 
#for example, "/home/rstudio/data/0007.txt"
main <- function(input1, input2, input3, input4, input5, input6,
                 input7, input8, output1, output2) {
  youtube_col_names <- c("Video ID", "uploader", "age", 'category','length',
                         'views','rate','ratings','comments','related IDs')
  
  table0007 <- read_raw_data(input1)
  table0107 <- read_raw_data(input2)
  table0207 <- read_raw_data(input3)
  table0307 <- read_raw_data(input4)
  
  # Load in May 4th 2008 data
  table0008 <- read_raw_data(input5)
  table0108 <- read_raw_data(input6)
  table0208 <- read_raw_data(input7)
  table0308 <- read_raw_data(input8)
  
  data2007 <- bind_tables(table0007,table0107,table0207, table0307)
  colnames(data2007) <- youtube_col_names
  
  data2008 <- bind_tables(table0008,table0108,table0208, table0308)
  colnames(data2008) <- youtube_col_names
  
  #save the uncleaned 2007 data 
  write.table(data2007, file =  output1, sep = "\t",
              row.names = FALSE, col.names = TRUE)
  
  #save the uncleaned 2008 data 
  write.table(data2008, file =  output2, sep = "\t",
              row.names = FALSE, col.names = TRUE)
  
  #remove all temporary tables
  rm(list = ls())
  
}


main(opt$input_one, opt$input_two, opt$input_three, opt$input_four,opt$input_five,
     opt$input_six,opt$input_seven,opt$input_eight, opt$output_one, opt$output_two)

#the output dir should be "/home/rstudio/data/data2007_not_cleaned.txt" and 
# "/home/rstudio/data/data2008_not_cleaned.txt"
