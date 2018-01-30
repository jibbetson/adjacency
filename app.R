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
  
  # Sidebar with several user input options
  sidebarLayout(
    sidebarPanel(
      # help box
      # file input widget
      # Input: Select a file ----
      fileInput("file1", "Choose data file",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # heatmap color scheme input (from a list)
      selectInput("select", label = h3("Select heatmap color"), 
                  choices = list("Viridis" = 1, "Red-Green" = 2, "Greys" = 3), 
                  selected = 1),
      
      # Horizontal line ----
      tags$hr(),

      # A set of processing steps as a CheckboxGroup
      checkboxGroupInput("checkGroup", label = h3("Data processing steps"), 
                         choices = list("Step 1" = 1, "Step 2" = 2, "Step 3" = 3),
                         selected = 1),

      # Horizontal line ----
      tags$hr(),
      
      # a threshold value input as a slider
      sliderInput("threshold", label = h3("Threshold"), 
                  min = 0, max = 1, value = 0.5)
      ),
    
      # Horizontal line ----
      tags$hr()
    ),
    
    # Main results panel with a table and three heatmaps
    mainPanel(
      
      # a table of the head of the file contents
      tableOutput("contents"),
      
      # a heatmap of the raw data
      plotOutput("plot1"),
      
      # a heatmap of the processed data
      
      # a heatmap of the threshold data
      plotOutput("plot2")
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
    plot_heatmap.lattice(dataset(), "Signal")
  })
  
  # draw a heatmap of the passing data
  output$plot2 <- renderPlot({
    newdataset <- dataset() %>%
                  mutate(pass = (dataset()$Signal > input$threshold))
    plot_heatmap.lattice(newdataset, "pass")
   })
  

}

# Run the application 
shinyApp(ui = ui, server = server)

