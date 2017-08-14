shinyServer(function(input, output, session){
  
  model<-reactive({
    xinputs <- input$x
    yinput<-yvar
    modelfamily<-"binomial"
    textformula<-paste(yinput, "~", paste(xinputs, collapse="+"))
    textformula
    
  })
  
  
  modelfit<-reactive({
    if(length(input$x)>0){
      modelformula<-as.formula(model())
    }
    
    fit<- glm(data = training, formula = modelformula, family  = binomial)
    fit
  })
  
  output$trainset<-renderDataTable({
    training
  })
  
  output$printformula<-renderPrint({
    model()
  })
  
  output$printsummary<-renderPrint({
    summary(modelfit())
  })
  
  output$rocPlot <- renderPlot({
    
    predstrain<-predict(modelfit(), training, type = "response")
    predstest<-predict(modelfit(), test, type = "response")
    
    resultstrain<-data.frame(YVAR=training[,yvar], preds=predstrain)
    resultstest<-data.frame(YVAR=test[,yvar], preds=predstest)
    
    predictionstrain<-prediction(resultstrain$preds,resultstrain$YVAR)
    predictionstest<-prediction(resultstest$preds,resultstest$YVAR)
    
    
    #slotNames(pred)
    
    
    roc.perf.train = performance(predictionstrain, measure = "tpr", x.measure = "fpr")
    roc.perf.test = performance(predictionstest, measure = "tpr", x.measure = "fpr")
    
    plot(roc.perf.train, col = "blue")
    plot(roc.perf.test, add = TRUE, col="red")
    abline(a=0, b= 1)
    legend(0.8,0.2,c('train','test'),col=c('blue','red'),lwd=3)
    
  })
  
  
})