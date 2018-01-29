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
library(plotly)

# Define any additional custom functions that are needed  
# These code chunks run once when app is first loaded




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
      
      # a heatmap of the raw data
      
      # a heatmap of the processed data
      
      # a heatmap of the threshold data
    
  )
)


# Define server logic required to draw the plots
server <- function(input, output) {
  

}

# Run the application 
shinyApp(ui = ui, server = server)

