# ui.R

shinyUI(fluidPage(
  titlePanel("WaDE Data Exploration"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water consumption by sector."),
      
      selectInput("year", 
                  label = "Choose a year to display:",
                  choices = as.character(seq(2000,2015,by=1)),
                  selected = "2010"),
      selectInput("reportingunit",
                  label = "Choose a reporting unit:",
                  choices = c("04-01-10","03-01-01","02-01-09"),
                  selected = "03-01-01")
     # submitButton("Submit")
    ),
    
    mainPanel(plotOutput("plot"))
  )
))