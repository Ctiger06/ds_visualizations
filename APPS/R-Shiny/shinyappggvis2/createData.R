setwd("C:/Users/c.entwistle/Documents/CIS/shinyappggvis2")

testdat<-read.csv("testdata.csv", stringsAsFactors = F)

testdat$UNIQUE_ID <- 1:nrow(testdat)

testdat$GOLDEN<-c(F, F, F, F, T, F, F, F)



library(dplyr)
cartesian<-merge(testdat,testdat,by="BlockingNo")


library(stringdist)


nameEditDistance <- function(x,y){
  return (stringdist(x,y,method = "lv"))
}

nameEditSim<-function(x,y){
  1-nameEditDistance(x,y)/max(nchar(x), nchar(y))
}

dobEditDistance <- function(x,y){
  return(stringdist(x,y,method = "lv"))
}

dobEditSim<-function(x,y){
  1-dobEditDistance(x,y)/max(nchar(x), nchar(y))
}

library(lubridate)
dobTimSim<-function(x,y){
  diff<-abs(as.numeric(as.Date(x, format = "%Y%m%d")-as.Date(y, format = "%Y%m%d")))
  return(1/(diff+1))
}

cobEditDistance <- function(x,y){
  return(stringdist(x,y,method = "lv"))
}


cocEditDistance <- function(x,y){
  return(stringdist(x,y,method = "lv"))
}

cobSim<-function(x,y){
  1-cobEditDistance(x,y)/max(nchar(x), nchar(y))
}

cocSim<-function(x,y){
  1-cocEditDistance(x,y)/max(nchar(x), nchar(y))
}




cartesian$nameES<- with(cartesian, nameEditSim(Name.x, Name.y))


cartesian$dobES<- with(cartesian, dobEditSim(DOB.x, DOB.y))


cartesian$cobES<- with(cartesian, cobSim(COB.x, COB.y))


cartesian$cocES<- with(cartesian, cocSim(COC.x, COC.y))


#View(cartesian)
grset<-filter(cartesian, GOLDEN.x == T)

grset<-grset[,c("BlockingNo", "Name.y", "DOB.y", "COB.y", "COC.y", "UNIQUE_ID.y", "nameES",
                "dobES", "cocES", "cobES", "GOLDEN.y")]
names(grset)<-c("BlockingNo", "Name", "DOB", "COB", "COC", "UNIQUE_ID", "nameES", "dobES", 
                "cocES", "cobES", "GOLDEN")

write.csv(grset, "erset.csv", row.names = F)