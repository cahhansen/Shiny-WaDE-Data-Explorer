# ui.R

load("data/ReportingUnits.Rdata")

shinyUI(fluidPage(theme="bootstrapdarkly.css",
  #img(src='UtahDivofWaterResources.jpg', align = "left",height=50,width=50),
  titlePanel("USGS Water Use Data Exploration"),
  
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore water withdrawals and consumptive use, as reported by the 
               USGS National Water Use Science Program."),
      
      selectInput(inputId = "year", 
                  label = "Select a year to display:",
                  choices = c("1990", "1995"),
                  selected = "1990"),
      selectInput(inputId = "reportingunit",
                  label = "Select a reporting unit (location):",
                  choices = RU_df$Name_ID,
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

