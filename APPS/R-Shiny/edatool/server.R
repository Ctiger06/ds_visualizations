
shinyServer(function(input, output, session){
  
  # lgetfactornames<-c()
  # lgetnumericnames<-c()
  # lgetlogicalnames<-c()
  # lgetcharacternames<-c()
  
  observe({
    if(length(input$features) > my_max)
    {
      updateCheckboxGroupInput(session, "features", selected= tail(input$features,my_max))
    }
    if(length(input$features) < my_min)
    {
      updateCheckboxGroupInput(session, "features", selected= names(mydat)[1])
    }
  })
  
 
  
  observe({

      lgetfactornames<-length(getFactorNames())
      lgetnumericnames<-length(getNumericNames())
      lgetlogicalnames<-length(getLogicalNames())
      lgetcharacternames<-length(getCharacterNames())
      totlength<-lgetfactornames+lgetnumericnames+lgetlogicalnames+ lgetcharacternames

      plot_choices <- myplottypes
      
      
      if(totlength>0 & totlength<=3){
        getline<- dplyr::filter(plottypestab, 
                          Factor == lgetfactornames & 
                           Character == lgetcharacternames & 
                           Numeric == lgetnumericnames & 
                           Logical == lgetlogicalnames)
        getline<-getline[,5:9]
        plot_choices<- names(getline[which(getline == TRUE)])
      }
          
     
      updateRadioButtons(session, "plottypes", choices=plot_choices)
      
  })
  
  getInputClass<-reactive({
    features<-input$features
    
    getclass<-function(y){
      class(mydat[,y])
    }
    
    featureclass<-sapply(features, FUN = getclass)
  })
  
  getFactorNames<-reactive({
    names(getInputClass()[getInputClass() %in% c("factor")])
  })
  
  getNumericNames<-reactive({
    names(getInputClass()[getInputClass() %in% c("integer", "numeric")])
  })
  
  getLogicalNames<-reactive({
    names(getInputClass()[getInputClass() %in% c("logical")])
  })
  
  getCharacterNames<-reactive({
    names(getInputClass()[getInputClass() %in% c("character")])
  })
  
  getSummaryOrder<-reactive({
    
  })
  
  
  
  
  output$caption <- renderText({
    
  })
  
  
  output$summary<-renderDataTable({
     sumtab<-head(mydat)

     if(length(getFactorNames()) >0 & length(getNumericNames())>0){
       x<-getFactorNames()
       y<-getNumericNames()
       sumtab<-summaryBy(list(c(y),c(x)), data = mydat, FUN = c(mean, median, max, min, sd), na.rm=TRUE)

     }else {
       if(length(getFactorNames()) ==0 & length(getNumericNames())>1){
          mydatnum<-mydat[,c(getNumericNames())]
          sumtab<- cor(mydatnum)
        }

     }
     return(sumtab)
  })
  
  output$plot <- renderPlot({
    
     lgetfactornames<-length(getFactorNames())
     lgetnumericnames<-length(getNumericNames())
     lgetlogicalnames<-length(getLogicalNames())
     lgetcharacternames<-length(getCharacterNames())
  
    #typesvect<-c(lgetfactornames, lgetnumericnames, lgetlogicalnames, lgetcharacternames)
    gp <- ggplot(mydat)
    
    if(input$plottypes == "Boxplot"){
      if(lgetfactornames<1) {
        if(lgetnumericnames <2){
          gp <- ggplot(mydat, aes_string(x="''", y=getNumericNames())) + geom_boxplot(outlier.shape = 3)  +      
            geom_point(col = "blue") + xlab("All") 
          #gp <- ggplot(mydat, aes_string(x=1, y=getNumericNames())) + geom_boxplot(outlier.shape = 3)  +      
          #  geom_point(col = "blue", position = position_jitter(height = 0.02, width = .2))
          
        } else {
          gp <- ggplot(mydat, aes_string(x="''", y=getNumericNames()[1])) + geom_boxplot(outlier.shape = 3)  +      
            geom_point(aes_string(col = getNumericNames()[2])) + xlab("All") 
        }
      }  
      else {
        if(lgetfactornames < 2){
          gp <- ggplot(mydat, aes_string(x=getFactorNames(), y=getNumericNames())) + geom_boxplot(outlier.shape = 3)  +      
            geom_point(col = "blue")
        }
      }
      
    }
    if(input$plottypes == "Scatterplot"){
      
    }
    if(input$plottypes == "Histogram"){
      
    }
    if(input$plottypes == "QN"){
      
    }
    if(input$plottypes == "Barplot"){
      
    }
    
    
   # return(ggplotly(gp))
    
    # ggp_build <- plotly_build(gp)
    # ggp_build$layout$height = 800
    # ggp_build$layout$width = 1000
    # 
    # return(ggp_build)
    
    return(gp)
  })
  
  
  output$SelectedFactorFeatures <- renderText({
   # paste(input$features,collapse=",")
   # paste(getFactorNames(), collapse = ",")
    length(getFactorNames())
  })
  
  output$SelectedCharacterFeatures <- renderText({
    # paste(input$features,collapse=",")
   # paste(getCharacterNames(), collapse = ",")
    length(getCharacterNames())
  })
  
  output$SelectedNumericalFeatures <- renderText({
    # paste(input$features,collapse=",")
   # paste(getNumericNames(), collapse = ",")
    length(getNumericNames())
  })
  
  output$SelectedLogicalFeatures <- renderText({
    # paste(input$features,collapse=",")
    paste(getLogicalNames(), collapse = ",")
    length(getLogicalNames())
  })
  
  output$contents <- renderDataTable({
   
  })
  
})