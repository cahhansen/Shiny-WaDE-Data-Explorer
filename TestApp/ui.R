pageWithSidebar(
  headerPanel('Test App for Utah'),
  sidebarPanel(
    sliderInput(inputId = "year", 
                label = "Select a year to display:",
                min=2005,max=2010,round=TRUE,ticks=FALSE,value=2010,sep="")
    ),
  mainPanel(
    tableOutput("WaterUseTable")
  )
)