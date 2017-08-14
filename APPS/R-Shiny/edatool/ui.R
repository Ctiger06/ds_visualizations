
shinyUI(pageWithSidebar(
  headerPanel("EDA Tool"),
  sidebarPanel(
    fluidRow(
      column(6,checkboxGroupInput("features","Features:", choiceNames = names(mydat), choiceValues= names(mydat)))
    ),
    
    fluidRow(
      column(5, radioButtons("plottypes", "Plot Types: ", choiceNames = myplottypes, choiceValues = myplottypes))
    ),
    fluidRow(
        h4("Selected Factor Vars: "),
        textOutput("SelectedFactorFeatures")
    ),
    fluidRow(
      h4("Selected Character Vars: "),
      textOutput("SelectedCharacterFeatures")
    ),
    fluidRow(
      h4("Selected Numerical Vars: "),
      textOutput("SelectedNumericalFeatures")
    ),
    fluidRow(
      h4("Selected Character Vars: "),
      textOutput("SelectedLogicalFeatures")
    )
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Plots", 
            #   h3(textOutput("caption")),
               
               #conditionalPanel("length(input.features) ==2",
                                plotOutput("plot", height = "800px", width = "100%"),
                                dataTableOutput("summary")
              # )
      )       ,
     # tabPanel("Summary Stats", dataTableOutput("summary")),
      tabPanel("Data", dataTableOutput("contents"))
    )
  )
)
  
  
)