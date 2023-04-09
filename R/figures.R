# author: Chris Cai
# date: March 25, 2023

"
Loads in cleaned data and writes four figures for the report. The figures would 
be named as 'figure_1.png', 'figure_2.png', 'figure_3.png', and 'figure_4.png'.
These figures will be saved under '/home/rstudio/output/'. Code adapted
from https://github.com/UBC-DSCI/dsci-310-individual-assignment-repro-reports

Usage: /home/rstudio/R/figures.R <input_one> <input_two> <output_one>  
" -> doc

library(corrplot)
library(tidymodels)
library(tidyverse)
library(car)
library(leaps)
library(docopt)
opt <- docopt(doc)

#This functions takes absolute pass of the data files 
#for example, "/home/rstudio/data/data2007_cleaned.txt"
main <- function(input1, input2, output1){
  
  #read cleaned file written by clean.R
  data2007 = read.delim(input1, 
                        sep = "\t", dec = ".", header = TRUE)
  data2008 = read.delim(input2, 
                        sep = "\t", dec = ".", header = TRUE)
  #ggsave("horse_pops_plot.png", device = "png", path = out_dir, width = 10, height = 3)
  
  ##save figure 1 
  figure_1 <- pivot_longer(data2007,-c(views,category))|> 
    ggplot(aes(value,views,color=name)) +
    geom_point() +
    facet_wrap(~name, scales ='free',strip.position='bottom') + 
    scale_color_viridis_d() + 
    xlab("") + ylab("views") + theme(axis.text = element_text(size = 8))    
  
  ggsave("figure_1.png", plot = figure_1, device = "png", 
         path = output1, width = 8, height = 5)
  
  ##save figure 2
  figure_2 <- ggplot(data2007, aes(category,views, fill = category))+ geom_bar(stat = 'identity')+coord_flip() +
    labs(x = "Views", y = "Category", fill = "Category Against Number of Views")
  
  ggsave("figure_2.png", plot = figure_2, device = "png", 
         path = output1, width = 8, height = 5)
  
  
  ##save figure 3
  #code adapted from https://stackoverflow.com/questions/50631646/
  #saving-a-correlation-matrix-graphic-as-pdf
  corrvar <- data2007|> select(-c(2))|> cor()
  file_path= paste0(output1,"figure_3.png")
  png(height=500, width=500, file=file_path, type = "cairo", res = 120)
  
  # Your function to plot image goes here
  corrplot(corrvar, method = 'number')
  
  # Then
  dev.off()
  
  
  ##save figure 4
  bestmod <- regsubsets(views~.,data2007,method='exhaustive')
  mydat <- as.data.frame(cbind("BIC" = summary(bestmod)$bic, 'AdjustedR2'= summary(bestmod)$adjr2, 'Size' = 1:8))
  figure_4 <- pivot_longer(mydat,-Size)|> 
    ggplot(aes(value,Size,color=name)) +
    geom_line() +
    coord_flip() +
    facet_wrap(~name, scales ='free',strip.position='bottom')+
    xlab("") + labs(colour='Metrics')+ theme(text = element_text(size = 7))    
  
  ggsave("figure_4.png", plot = figure_4, device = "png", 
         path = output1, width = 12, height = 6.5, units = "cm")
  
  #remove all temporary tables
  rm(list = ls())
  
}

main(opt$input_one, opt$input_two, opt$output_one)
