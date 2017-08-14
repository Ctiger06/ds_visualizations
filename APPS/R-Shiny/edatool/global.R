library(shiny)
library(shinydashboard)
library(leaflet)
library(data.table)
library(ggplot2)
library(dplyr)
library(sqldf)
library(doBy)
library(plotly)
library(fBasics)


#read in data

source("datacleaning.R")


plottypestab<-read.csv("plottypes.csv")

options(scipen = 999)

my_min <- 1
my_max <- 3

myplottypes<- c("Scatterplot", "Boxplot", "Histogram", "QN", "Barplot")