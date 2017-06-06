
oneWayFrequencyTable<- function(vector){
  counts<-table(vector)
  props<-round(prop.table(counts), digits =2)
  rbind(counts, props)
}


