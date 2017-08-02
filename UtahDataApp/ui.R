# ui.R

load("data/ReportingUnits.Rdata")

shinyUI(fluidPage(theme="bootstrapdarkly.css",
  #img(src='UtahDivofWaterResources.jpg', align = "left",height=50,width=50),
  titlePanel("Utah Water Data Exploration"),
  
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water consumption and diversions by sector, as reported by the 
               Utah Division of Water Resources."),
      
      sliderInput(inputId = "year", 
                  label = "Select a year to display:",
                  min=2005,max=2014,round=TRUE,ticks=FALSE,value=2010,sep=""),
      selectInput(inputId = "reportingunit",
                  label = "Select a reporting unit:",
                  choices = RU_df$Name_ID,
                  selected = "Fetching Reporting Units")
    ),
    
    mainPanel(
      plotlyOutput(outputId="CUplot"),height="400px",
      tableOutput("CUtable"),
      textOutput(outputId="CUmethod"),
      plotlyOutput(outputId="Divplot"),height="400px",
      tableOutput("Divtable"),
      textOutput(outputId="Divmethod")
      )
  )
))

