# ui.R

shinyUI(fluidPage(
  titlePanel("WaDE Data Exploration"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water consumption by sector."),
      
      selectInput("year", 
                  label = "Choose a year to display",
                  choices = c("2011", "2012",
                              "2013", "2014"),
                  selected = "2011")
    ),
    
    mainPanel(plotOutput("plot"))
  )
))