# ui.R

shinyUI(fluidPage(theme="bootstrapspacelab.css",
  titlePanel("WaDE Data Exploration"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water consumption by sector, as reported by the 
               Utah Division of Water Resources."),
      
      selectInput(inputId = "year", 
                  label = "Choose a year to display:",
                  choices = as.character(seq(2000,2015,by=1)),
                  selected = "2010"),
      selectInput(inputId = "reportingunit",
                  label = "Choose a reporting unit (location):",
                  choices = c("04-01-10","03-01-01","02-01-09"),
                  selected = "03-01-01"),
      selectInput(inputId = "datatype",
                  label = "Choose a data type: ",
                  choices = c("ConsumptiveUse","Diversion"))
    ),
    
    mainPanel(
      plotOutput(outputId="plot"),height="400px")
  )
))

