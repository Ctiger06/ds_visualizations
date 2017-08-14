

shinyUI(fluidPage(
  sidebarPanel(
    checkboxGroupInput('x', 'X', choices = xoptions, selected =  xoptions[1])
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Plots",
               plotOutput("rocPlot"),
               textOutput("printformula"),
               verbatimTextOutput("printsummary")
      ),
      tabPanel("Training Data",
               dataTableOutput("trainset")
      )
    )
  )
)
)
