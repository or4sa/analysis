args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied <input file>.csv", call.=FALSE)
} else if (length(args)==1) {
  filename = args[1]
  #filename <- 'data-samples/2018_household_individual_weights.csv'
}

list.of.packages <- c("dplyr", "zoo")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(dplyr)
library(zoo)

x <- readLines(filename)

filterline <- min(which(grepl(x = x, pattern = "Filters:|Counting:")))
taboutline <- filterline + min(which(x[filterline:(filterline + 100)] == ''))
#x[1:10]
valfields<- x[grepl(pattern = 'Summation', x = x)] %>% strsplit('\",\"') %>% unlist() %>% gsub(pattern = '\"', replacement = '')
valfields<- valfields[2:length(valfields)] %>% gsub(pattern = ',', replacement = '')
valfields<- valfields[!grepl(valfields, pattern = 'Summation Options|Filter Options')]

colnames = (x[taboutline + 1] %>% strsplit("\",\"") %>% unlist %>% gsub(pattern = '\"|\",', replacement = ''))
y<- read.csv(filename, skip = taboutline + 1, header = F)
#y %>% head
y<- y[,-ncol(y)];
names(y) <- c(colnames, valfields) # what is this?
y<- y[-nrow(y), ]

for(i in 1:(ncol(y) - 1)){
  y[,i][y[,i] == ''] <- NA  
  y[,i]<- na.locf(y[,i], fromLast = F)
}
y %>% head
outfn <- paste0( gsub(x = filename, pattern = ".csv", replacement = '_cleaned.csv'))
cat("Writing out to: ", outfn, "\n")
write.csv(row.names = F, x = y, file = outfn)
