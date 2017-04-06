# ui.R
reportingunits=c("00-01-03",  "000-01-03", "00-07-02",  "000-01-02", "000-02-00", "000-01-01", "00-07-01",  "00-01-02",  "00-01-01",  "02-01-08",  
                 "04-01-04",  "00-05-01",  "09-01-01",  "05-02-04", "08-05-02",  "05-03-00",  "09-02-01",  "08-03-03",  "08-02-05",  "08-03-04",
                 "05-05-01",  "09-01-06",  "05-06-02",  "06-02-01",  "09-03-04",  "09-03-03", "02-01-05",  "02-01-07", "02-01-04",  "07-01-02",
                 "07-01-06",  "00-02-01",  "07-01-03",  "07-01-05", "00-06-02",  "02-01-03",  "07-01-04",  "02-01-06",  "07-01-01",  "02-01-02",
                 "00-04-00",  "03-01-04", "03-01-02",  "02-01-01",  "03-01-03",  "07-03-11",  "07-02-02",  "07-03-12",  "07-01-07",  "07-03-10",
                 "07-02-01",  "00-02-03",  "07-03-09",  "07-03-08",  "07-03-05",  "03-01-05", "04-01-06",  "04-01-07",  "07-03-13",  "03-01-06",
                 "07-02-03",  "03-01-07",  "00-05-02",  "04-01-10",  "07-03-07",  "07-04-01",  "07-03-06",  "03-01-01",  "04-01-08",  "07-03-03", 
                 "07-03-01",  "04-01-09",  "07-03-04",  "07-03-14",  "04-01-05",  "07-03-02",  "07-04-05",  "04-01-03",  "08-01-02",  "05-02-01",
                 "04-01-02",  "07-04-02",  "08-01-01",  "07-05-01", "00-02-02",  "04-01-01",  "00-03-02",  "08-02-01",  "07-04-04",  "05-02-03",
                 "08-02-02",  "08-02-04",  "07-04-03",  "08-01-03",  "05-08-00",  "05-01-00",  "05-02-02",  "05-07-00", "08-02-03",  "08-05-01",
                 "08-03-01",  "09-01-02",  "05-04-02",  "09-01-03",  "06-01-03",  "08-03-02",  "08-03-05",  "05-05-02",  "05-04-01",  "09-01-04",
                 "08-03-08",  "09-01-05", "08-03-06",  "08-03-07",  "09-02-02",  "06-01-02",  "05-06-03",  "00-03-01",  "08-04-01",  "08-04-02",
                 "06-03-01",  "05-06-01",  "09-03-02",  "09-05-00",  "10-02-02",  "10-01-01", "09-03-05",  "10-02-01",  "06-01-01",  "06-02-02",
                 "06-01-04",  "00-06-01",  "02-01-09",  "10-01-02",  "10-01-03",  "10-01-06",  "10-01-04",  "10-01-05",  "09-04-00",  "09-03-01",
                 "01-01-01",  "01-02-01",  "01-01-05",  "01-01-06",  "01-01-07",  "01-01-04",  "01-03-02",  "01-03-01",  "04-01-11") 

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
                  choices = reportingunits,
                  selected = "03-01-01")
    ),
    
    mainPanel(
      plotOutput(outputId="CUplot"),height="400px",
      textOutput(outputId="CUMethod"),
      plotOutput(outputId="Divplot"),height="400px",
      textOutput(outputId="DivMethod")
      )
  )
))
