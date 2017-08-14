library(caret)
library(ROCR)
library(shiny)
library(shinydashboard)
library(ggplot2)
dataF<-read.csv("insurance_fraud_data.txt")
nms <- names(dataF)

yvar<-"fraudulent"

xoptions<-nms[which(!(nms %in% yvar))]

a <- createDataPartition(dataF[,yvar], p=.8, list = FALSE)
training <- dataF[a,]
test <- dataF[-a,]