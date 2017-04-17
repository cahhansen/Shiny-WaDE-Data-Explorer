# ui.R
reportingunits=seq(1,7,1) 

shinyUI(fluidPage(theme="bootstrapdarkly.css",
  titlePanel("Wyoming Water Use Data Exploration"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water use by sector."),
      
      selectInput(inputId = "reportingunit",
                  label = "Select a reporting unit (location):",
                  choices = reportingunits,
                  selected = "1")
    ),
    
    mainPanel(
      plotOutput(outputId="CUplot"),height="400px",
      textOutput(outputId="CUmethod")
      ),
    
    fluidRow(
      tableOutput("table")
    )
  )
))

