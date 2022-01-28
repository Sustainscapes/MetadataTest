#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyselect)
library(DT)




# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("SustainScapes data"),

    # Sidebar with a slider input for loading a file
    sidebarLayout(
      sidebarPanel(
        fileInput("file", label = h3("Input data")),
        ),

        # Show a table and a plot of the data
    mainPanel(
      tabsetPanel(
        tabPanel("Table",DT::DTOutput("TableData")),
        tabPanel("Plot",plotOutput("plot"))
          )
        )
    )
)

# Define server logic required to show datatable and plot
server <- function(input, output) {
  
  #making the datatable
  output$TableData <- DT::renderDT({
    file <- input$file
    
    #when no file is selected there will be no error
    validate(
      need(input$file != "", " ") 
      )
    
    #creating Variable column
    Vars <- colnames(read.csv(file$datapath))
      
    DF <- data.frame(Variables = Vars, 
                     Description = NA, 
                     Units = NA,
                     File = file$name,
                     path = file$datapath)
      
    #To make the Description column editable
    DF1<-datatable(DF, 
                   editable =  list(target = "cell", disable = list(columns = c(1,3,4,5))),
                   selection=c("none"))
      
    
    DF1})
  
  #making the plot
  output$plot <- renderPlot({
    plot(rnorm(100),main="rnorm(100)")
      
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
