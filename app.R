#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load packages and functions
library(shiny)
library(tidyverse)
library(lattice)
#library(plotly)

# Define any additional custom functions that are needed  
# These code chunks run once when app is first loaded

# A heatmap using lattice::levelplot()
plot_heatmap.lattice <- function(dt, z, title = NULL, 
                                 incl.vals = TRUE, allticks = TRUE, ... ){
  
  # function to add text to heatmap
  myPanel <- function(x, y, z, ...) { 
    panel.levelplot(x, y, z, ...)
    if(incl.vals) panel.text(x, y, round(z, 2), cex = 0.75)
  }    
  
  grid <- as_tibble(list(X = dt[, 1], Y = dt[, 2], Z = dt[, z]))
  
  # default plot title and non-default tick locations
  if(is.null(title)) title <- z
  entity.list <- unique(grid$X)
  l <- if(allticks) list(at = entity.list) else list() 
  ticks <- l
  
  levelplot(Z ~ X*Y, grid, main = title, panel = myPanel, 
            col.regions = colorRampPalette(c("red", "yellow", "green")),
            xlab = "Start", ylab = "End", scales = ticks)
}


# Define UI for application that visualizes adjacency matrices as heatmaps
ui <- fluidPage(
  
  # Application title
  titlePanel("Adjacency"),
  
  # Top row: data file
  fluidRow(
    column(width = 4,
      # file input widget: Select a file ----
      fileInput("file1", "Choose data file",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")
                )
    ),
    column(width = 8,
      # a table of the head of the file contents
      tableOutput("contents")
    )
  ),
  
  # 2nd row: heatmap of user selected data
  fluidRow(
    column(width = 4, wellPanel(
      # heatmap color scheme input (from a list)
      selectInput("select_var", label = h4("Choose variable"), 
                  choices = list("Signal")),
      # heatmap color scheme input (from a list)
      selectInput("select_col1", label = h4("Select heatmap color"), 
                  choices = list("Viridis" = 1, "Red-Green" = 2, "Greys" = 3), 
                  selected = 1)
    )),
    column(width = 8,
      # a heatmap plot
      plotOutput("plot1")
    )
  ),

  # 3rd row: heatmap of adjacency data
  fluidRow(
    column(width = 4, wellPanel(
      # a threshold value input as a slider
      sliderInput("threshold", label = h4("Set threshold for adjacency"), 
                  min = 0, max = 1000, value = 500)
    )),
    column(width = 8,
      # a heatmap of the thresholded data
      plotOutput("plot2")
    )
  )
)


# Define server logic required to draw the plots
server <- function(input, output) {
  
  # get the reactive dataset
  dataset <- reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    select(df, Caster, Receiver, Signal)
  }) 

  # print a table of the raw data
  output$contents <- renderTable({
    df <- dataset()
    return(head(df, 4))
  })

  # draw a heatmap of the raw data
  output$plot1 <- renderPlot({
    plot_heatmap.lattice(dataset(), input$select_var)
  })
  
  # draw a heatmap of the passing data
  output$plot2 <- renderPlot({
    df <- dataset() %>%
      mutate(pass = (dataset()[, input$select_var] > input$threshold))
    plot_heatmap.lattice(df, "pass")
   })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

