# This data requires the use of internal dataset, mtcars

Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_31') # for 64-bit version
Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre1.8.0_25') # for 32-bit version

## Some of the libraries required - Update if necessary
# Vizualization
install.packages("ggplot2")
install.packages("ggvis")
install.packages("shiny")
install.packages("DescTools")
install_github("trestletech/ShinyDash")
install_github("ramnathv/slidify")
install_github("ramnathv/slidifyLibraries")

install.packages("quantmod")
install.packages("Quandl")
install.packages("forecast")
install.packages("elasticnet")
install.packages("e1071")


# Modelling/ML
install.packages("caret")
install.packages("lm")
install.packages("cluster")
# Modelling - Utility 
install.packages("doSNOW")
install.packages("parallel")

# Data Manipulation
install.packages("dplyr")
install.packages("tidyr")

# Utility
install.packages("foreach")
install.packages("devtools")
install.packages("gtools")
install.packages("lubridate")
install.packages("zoo")

# Connection to host databases
install.packages("RODBC")
install.packages("RMySQL")
install.packages("ROracle")
install.packages("RJDBC")
install.packages("xlsx")
install.packages("XML")

# Install required libraries
# dplyr and tidyr library
if(!require(dplyr)){
  install.packages("dplyr")
  library(plyr)
}

if(!require(tidyr)){
  install.packages("tidyr")
  library(tidyr)
}

# Install xlsx, excel library
if(!require(xlsx)){
  install.packages("xlsx")
  library(xlsx)
}

if(!require(zoo)){
  install.packages("zoo")
  library(zoo)
}

# Go to desktop
setwd("..")
setwd("./Desktop")
options(stringsAsFactors=FALSE)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
options(java.parameters = "-Xmx4000m")

## Extracting from SQL Server
trydb<-odbcDriverConnect('driver={SQL Server};server=10.73.154.40\\PRODDB01-VS2\\DATAMARTPROD01,1436;database=DM_1224_MagnumIceCreamSingapore;uid=HNoorazman;pwd=Mindshare123')
sqlQuery(trydb, "Select * from DFID015333_Search_Transformed")

#####################
### Combine files ###
#####################

# Obtaining the working directory and ignore escape characters
wd<-scan(what='character', allowEscapes=FALSE, sep="!")

# Put in the wd
setwd(wd)

# Read all the files in the folder
files<-list.files()

# Import the foreach package
if(!require(foreach)){
  install.packages("foreach")
  library(foreach)
}

data<-foreach(i=1:length(files), .combine='rbind') %do% {
  temp_data = read.csv(files[i])
}

write.csv(data, "combined_gross_rate.csv", row.names=FALSE, na="")

###################
### String Func ###
###################

if(!require(stringr)){
  install.packages("stringr")
  library(stringr)
}





###################
### Using DPLYR ###
###################

# ?manip - it will contain other example functionality
# Can be used to rearrange the columns
select(mtcars, mpg:drat)
# Normal filter
filter(mtcars, carb==4)
# Adding additional columns
mutate(mtcars, yahoo=carb+1, bob=yahoo/2) 
# Sorting functions
arrange(mtcars, gear) 
arrange(mtcars, desc(gear))
# Group by and summarize
mtcarsTemp<-tbl_df(mtcars) # Better way to view data
mtcarsTemp<-group_by(mtcarsTemp, cyl)
summarize(mtcarsTemp, mean(hp), sum(drat))

###################
### Using TIDYR ###
###################

# Make flat file
# Ensure that the data is already cleaned before
gather(mtcars, Characteristics, Value, vs:carb)

# Make it into analytical file
# Ensure that the data is already cleaned before
spread(mtcars, cyl, hp) # highly probable to create NA


###################
### Using XLSX  ###
###################

wb<-loadWorkbook("sampleExcelCheck.xlsx")
ws<-getSheets(wb)



###################
### Using ZOO   ###
###################

## Just a wrapper - easier to remember that way
fillRight<-function(data, rowNo){
  y<-as.character(data[rowNo,])
  y[y==""]<-NA
  y<-na.locf(y)
  data[rowNo,]<-y
  data
}


###################
### CUSTOM      ###
###################


# Split by upper case characters
# Replace the example text in the third parameter
gsub("([A-Z])", "\\1 ", "abc and ABC")
split.by.upper<-function(text){
  gsub("([A-Z])", "\\1 ", text)
}

## Don't use for duplicate column names
setAsHeader<-function(data, rowNo){
  names(data)<-data[rowNo,]
  data[-rowNo,]
}

# Drop last set of rows
rowDropLast<-function(data, num){
  noOfRows<-dim(data)[1]
  noOfRows<-noOfRows-num
  data<-data[1:noOfRows,]
  data
}

# Drop first set of rows
rowDropFirst<-function(data, num){
  noOfRows<-dim(data)[1]
  num<-num+1
  data<-data[num:noOfRows,]
  data
}

# Drop last set of columns
columnDropLast<-function(data, num){
  noOfColumns<-dim(data)[2]
  noOfColumns<-noOfColumns-num
  data<-data[,1:noOfColumns]
  data
}

# Drop first set of columns
columnDropFirst<-function(data, num){
  noOfColumns<-dim(data)[2]
  num<-num+1
  data<-data[,num:noOfColumns]
  data
}

deleteEmptyColumns<-function(data){
  data<-data[,!apply(data,2,function(x) all(x == ""))]
  data<-as.data.frame(data)
  data
}

deleteEmptyRows<-function(data){
  tempdata<-apply(data, 2, function(x){x==""})
  tempdata<-apply(tempdata, 1, all)
  data<-data[!tempdata,]
  data
}

rowShiftRight<-function(data,rowNo, shifts){
  temp_data<-data[rowNo,]
  temp_data<-columnDropLast(temp_data, shifts)
  
  ## Create temp shift columns
  shift_columns<-rep("", times=shifts)
  shift_columns<-data.frame(matrix(shift_columns, 1, shifts))
  temp_data<-cbind(shift_columns, temp_data)
  
  ## Return shift row to original data
  data[rowNo,]<-temp_data
  data
}



