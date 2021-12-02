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

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            fileInput("file", label = h3("Input data")),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           dataTableOutput("TableData")
        )
        
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$TableData <- renderDataTable({
      editable = list(target = "column", disable = list(columns = c(1,2)))#all coloumns except 1 and 2 are editable
      file <- input$file
      ext <- tools::file_ext(file$datapath)
      output$value <- renderPrint({ input$text })
      desc <- output$value
      Vars <- colnames(read.csv(file$datapath))
      DF <- data.frame(Variables = Vars, 
                       Description = desc, 
                       Units = NA, 
                       File = file$name,
                       path = file$datapath)
      DF
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
