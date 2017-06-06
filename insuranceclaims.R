setwd("C:/Users/c.entwistle/Documents/BP")
list.files()

#determine what initial data types should be
trainsamp<-read.table("insurance_fraud_data.txt", sep = ",", header = TRUE, nrows = 10, stringsAsFactors = FALSE)

colclasses<-sapply(trainsamp, class)

idstrings<-grep("ID|id$", names(trainsamp))

colclasses[idstrings]<-"character"

train<-read.table("insurance_fraud_data.txt", sep = ",", header = TRUE, 
                      colClasses = colclasses)

#reevaluate whether some data types should be changed


typing<-function(vect){
  numdistinct<-length(unique(vect))
  percdistinct<-numdistinct/nrow(train)
  attributes<-c(class(vect), numdistinct, percdistinct)
  return(attributes)
}

attributematrix<-sapply(train, typing)

#if its a character and distinct percent is below .8, then change to factor variable
#if its a numeric or integer and distinct percent is below .01, create factor variable

for (i in 1:ncol(train)){
  if (attributematrix[1,i] == "character" && attributematrix[3,i] < .8){
    train[,i]<- as.factor(train[,i])
  }
}

for (i in 1:ncol(train)){
  j<-0
  if (attributematrix[1,i] %in% c("numeric", "integer", "complex") && attributematrix[3,i]<.05){
    column<-ncol(train)+1+j
    train[,column]<-as.factor(train[,i])
    names(train)[column] <- paste0(names(train)[i], "_fact")
    j<-j+1
  }
}

#maybe do some manual editing here...

finalcolclasses<-sapply(train, class)

dim(train) #1100 by 13

summary(train)

#UNIVARIATE CATEGORICAL

##NONGRAPHICAL
prop.table(table(train$gender))

##GRAPHICAL




