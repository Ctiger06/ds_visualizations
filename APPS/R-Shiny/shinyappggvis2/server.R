library(ggvis)
library(dplyr)
library(sqldf)
if (FALSE) library(RSQLite)



colclasses<-c("integer", "character", "character", "character", "character", "character", 
              "numeric", "numeric", "numeric", "numeric","character", "character")
blockdat <- read.csv.sql("clusterdat.csv", colClasses = colclasses)

#colclasses<-c("character", "character", "character", "character", "character", "integer", 
#              "numeric", "numeric", "numeric", "numeric","logical")
#blockdat <- read.csv.sql("erset.csv", colClasses = colclasses)



function(input, output, session) {
  
  # Filter the block, returning a data frame
  block <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    minblockingno <- input$blockingno[1]
    maxblockingno <- input$blockingno[2]

    # Apply filters
    m <- blockdat  %>% 
     
  #  %>%
  #    filter(
  #      BlockingNo >= minblockingno,
  #      BlockingNo <= maxblockingno#,
 
   #   ) 
  arrange(Golden)
    
    # Optional: filter by Name
    if (input$name != "All") 
      {
      name <- paste0("%", input$name, "%")
      #m <- m %>% filter(Name %like% name)
      m <- sqldf(paste0("select * from m where Name like '" , name, "'"))
    }
    # Optional: filter by blocking number
   # if (input$blockingno != "All") 
  #  {
  #    blockingno <- paste0("%", input$blockingno, "%")
      #m <- m %>% filter(Name %like% name)
  #    m <- sqldf(paste0("select * from m where BlockingNo like '" , blockingno, "'"))
  #  }
    
    # Optional: filter by director
    #if (!is.null(input$director) && input$director != "") {
    #  director <- paste0("%", input$director, "%")
    #  m <- m %>% filter(Director %like% director)
    #}
    # Optional: filter by cast member
  #  if (!is.null(input$cast) && input$cast != "") {
  #    cast <- paste0("%", input$cast, "%")
  #    m <- m %>% filter(Cast %like% cast)
  #  }
    
    
    m <- as.data.frame(m)
    
    # Add column which says whether the bloc won any Oscars
    # Be a little careful in case we have a zero-row data frame
   # m$golden <- character(nrow(m))
   # m$golden[m$Golden == 'N'] <- "No"
   # m$golden[m$Golden  == 'Y'] <- "Yes"
    m
  })
  
  # Function for generating tooltip text
  blocking_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$UNIQUE_ID.x)) return(NULL)
    
    # Pick out the bloc with this ID
    blockdat <- isolate(block())
    bloc <- blockdat[blockdat$UNIQUE_ID.x == x$UNIQUE_ID.x, ]
    
    paste0("<b>", bloc$Name, "</b><br>",
           bloc$DOB, "<br>",
           "COC: ", format(bloc$COC, big.mark = ",", scientific = FALSE),  "<br>",
           "COB: ", format(bloc$COB, big.mark = ",", scientific = FALSE)
    )
  }
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    block %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~Golden, key := ~UNIQUE_ID.x) %>%
      add_tooltip(blocking_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name) %>%
      add_legend("stroke", title = "Golden", values = c("Y", "N")) %>%
      scale_nominal("stroke", domain = c("Y", "N"),
                    range = c("orange", "#aaa")) %>%
      set_options(width = 500, height = 500)
  })
  
  vis %>% bind_shiny("plot1")
  
  #output$n_records <- renderText({ nrow(block()) })
  output$n_records <- renderDataTable({ block() })
}