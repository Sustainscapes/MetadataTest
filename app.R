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



#Code to make drop down menu
callback <- c(
  "var id = $(table.table().node()).closest('.datatables').attr('id');",
  "$.contextMenu({",
  "  selector: '#' + id + ' td.factor input[type=text]',",
  "  trigger: 'hover',",
  "  build: function($trigger, e){",
  "    var levels = $trigger.parent().data('levels');",
  "    if(levels === undefined){",
  "      var colindex = table.cell($trigger.parent()[0]).index().column;",
  "      levels = table.column(colindex).data().unique();",
  "    }",
  "    var options = levels.reduce(function(result, item, index, array){",
  "      result[index] = item;",
  "      return result;",
  "    }, {});",
  "    return {",
  "      autoHide: true,",
  "      items: {",
  "        dropdown: {",
  "          name: 'Edit',",
  "          type: 'select',",
  "          options: options,",
  "          selected: 0",
  "        }",
  "      },",
  "      events: {",
  "        show: function(opts){",
  "          opts.$trigger.off('blur');",
  "        },",
  "        hide: function(opts){",
  "          var $this = this;",
  "          var data = $.contextMenu.getInputValues(opts, $this.data());",
  "          var $input = opts.$trigger;",
  "          $input.val(options[data.dropdown]);",
  "          $input.trigger('change');",
  "        }",
  "      }",
  "    };",
  "  }",
  "});"
)

createdCell <- function(levels){
  if(missing(levels)){
    return("function(td, cellData, rowData, rowIndex, colIndex){}")
  }
  quotedLevels <- toString(sprintf("\"%s\"", levels))
  c(
    "function(td, cellData, rowData, rowIndex, colIndex){",
    sprintf("  $(td).attr('data-levels', '[%s]');", quotedLevels),
    "}"
  )
}


#The units to choose from the drop down menu
unitsTrue <- c("mm.", "cm.", "m.", "km.")

#UI
ui <- fluidPage(
  
  #Makes the DT editable
  tags$head(
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.8.0/jquery.contextMenu.min.css"
    ),
    tags$script(
      src = "https://cdnjs.cloudflare.com/ajax/libs/jquery-contextmenu/2.8.0/jquery.contextMenu.min.js"
    )
  ),
  
  
  # Application title
  titlePanel("SustainScapes data"),
  
  # Sidebar with a slider input for loading a file
  sidebarLayout(
    sidebarPanel(
      fileInput("file", label = h3("Input data"))
    ),
    
    # Show a table and a map of the coordinates
    mainPanel(
      tabsetPanel(
        tabPanel("Table",DT::DTOutput("TableData")),
        tabPanel("Map", 
                 h2("Map over the area"), 
                 h3("Insert the coordinates"),
                 splitLayout(numericInput("cord_long_low", label=h4("Coordinates longtitude low"), value=7),
                             numericInput("cord_lat_low", label=h4("Coordinates latitude low"), value=54)),
                 splitLayout(numericInput("cord_long_high", label=h4("Coordinates longtitude high"), value=12),
                             numericInput("cord_lat_high", label=h4("Coordinates latitude high"), value=58)),
                 plotOutput("plot")))
      
      
    )
  )
)


# Define server logic required to show datatable and plot
server <- function(input, output) {
  
  
  
  
  #making the datatable
  output$TableData <- DT::renderDT({
    
    
    #loads file
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
    
    
    #To make the Description column editable and create download buttons
    DT<-datatable(DF, 
                  editable =  list(target = "cell", 
                                   disable = list(columns = c(1,4,5))),
                  selection=c("none"),
                  extensions='Buttons',
                  callback = JS(callback),
                  options=list(dom='Bfrtip', 
                               buttons=list('copy', 'pdf', 'csv', 'excel'), 
                               columnDefs=list(list(targets=3, 
                                                    className="factor", 
                                                    createdCell = JS(createdCell(c(levels(unitsTrue), 
                                                                                   unitsTrue)))))),
    )
    
    
    
    DT})
  
  # Plotting map
  
  output$plot <- renderPlot({
    map('worldHires', 
        xlim=c(input$cord_long_low, input$cord_long_high), 
        ylim=c(input$cord_lat_low, input$cord_lat_high))
    
    
    
    
  }) 
}

# Run the application 
shinyApp(ui = ui, server = server)
