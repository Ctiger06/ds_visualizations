


#can supply colClasses argument if you know what types are

mydat<-read.csv("1987_sample.csv",  stringsAsFactors = FALSE)


colclasses<-sapply(mydat, class)

idstrings<-grep("ID|id$", names(mydat))

colclasses[idstrings]<-"character"

#reevaluate whether some data types should be changed


typing<-function(vect){
  numdistinct<-length(unique(vect))
  percdistinct<-numdistinct/nrow(mydat)
  attributes<-c(class(vect), numdistinct, percdistinct)
  return(attributes)
}

attributematrix<-sapply(mydat, typing)

#if its a character and distinct percent is below .8, then change to factor variable
#if its a numeric or integer and distinct percent is below .01, create factor variable

for (i in 1:ncol(mydat)){
  if (attributematrix[1,i] == "character" & attributematrix[3,i] < .8){
    mydat[,i]<- as.factor(mydat[,i])
  }
}

for (i in 1:ncol(mydat)){
  j<-0
  if (attributematrix[1,i] %in% c("numeric", "integer", "complex") & attributematrix[3,i]<.1){
    column<-ncol(mydat)+1+j
    mydat[,column]<-as.factor(mydat[,i])
    names(mydat)[column] <- paste0(names(mydat)[i], "_fact")
    j<-j+1
  }
}



#mydat<-mydat[,which(finalcolclasses != "character")]





