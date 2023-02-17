
## Table 0
table0 <- read.delim("0007.txt", header = FALSE, sep = "\t", dec = ".")
head(table0)

table0done <- table0[-c(1,2,3,4,10:29)]
head(table0done)
colnames(table0done) <- c("length","views","rate","ratings","comments")
head(table0done)
## Table 1
table1 <- read.delim("0107.txt", header = FALSE, sep = "\t", dec = ".")
head(table1)

table1done <- table1[-c(1,2,3,4,10:29)]
head(table1done)
colnames(table1done) <- c("length","views","rate","ratings","comments")
head(table1done)
## Table 2
table2 <- read.delim("0207.txt", header = FALSE, sep = "\t", dec = ".")
head(table2)

table2done <- table2[-c(1,2,3,4,10:29)]
head(table2done)
colnames(table2done) <- c("length","views","rate","ratings","comments")
head(table2done)
## Table 3
table3 <- read.delim("0307.txt", header = FALSE, sep = "\t", dec = ".")
head(table3)

table3done <- table3[-c(1,2,3,4,10:29)]
head(table3done)
colnames(table3done) <- c("length","views","rate","ratings","comments")
head(table3done)


## Combine Into 1 datatable

datatable2007 <- rbind(table0done,table1done,table2done, table3done)
tail(datatable2007)

data_new_no_negative <- datatable2007                 
data_new_no_negative[data_new_no_negative < 0] <- NA       # Replace negative values by NA
data_new_no_negative  

datatable2007clean <- na.omit(data_new_no_negative)

write.table(datatable2007clean, file = "datatable2007.txt", sep = "\t",
            row.names = FALSE, col.names = TRUE)

