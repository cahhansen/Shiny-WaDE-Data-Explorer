# ui.R

shinyUI(fluidPage(theme="bootstrapdarkly.css",
  titlePanel("Wyoming Water Use Data Exploration"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water use by sector."),
      selectInput(inputId = "reportingunit",
                  label = "Select a reporting unit (location):",
                  choices = c("Fetching Reporting Units"),
                  selected = "Fetching Reporting Units")
    ),
    
    mainPanel(
      plotOutput(outputId="CUplot"),height="400px",
      tableOutput("table"),
      textOutput(outputId="CUmethod")
    )
  )
))

