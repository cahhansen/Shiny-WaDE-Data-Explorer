# ui.R


shinyUI(fluidPage(theme="bootstrapdarkly.css",
  titlePanel("Utah Water Use Data Exploration"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water consumption and diversions by sector, as reported by the 
               Utah Division of Water Resources."),
      
      sliderInput(inputId = "year", 
                  label = "Select a year to display:",
                  min=2005,max=2014,round=TRUE,ticks=FALSE,value=2010,sep=""),
      selectInput(inputId = "reportingunit",
                  label = "Select a reporting unit (location):",
                  choices = c("Fetching Reporting Units"),
                  selected = "Fetching Reporting Units")
    ),
    
    mainPanel(
      plotOutput(outputId="CUplot"),height="400px",
      tableOutput("CUtable"),
      textOutput(outputId="CUmethod"),
      plotOutput(outputId="Divplot"),height="400px",
      tableOutput("Divtable"),
      textOutput(outputId="Divmethod")
      )
  )
))

