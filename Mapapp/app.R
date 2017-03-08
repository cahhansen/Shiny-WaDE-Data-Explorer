library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput("mymap"),
  helpText("Select Reporting Unit."),
  selectInput(inputId = "reportingunit",
              label = "Select a reporting unit (location):",
              choices = c("Dell Creek","LambsCreek","Upper City Creek"),
              selected = "")
)

server <- function(input, output, session) {
  
  load('data/reportingunitsexample.RData')
  
  
  output$mymap <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom=3,maxZoom =10)) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addPolygons(data = reportingunitsexample,label=reportingunitsexample$Name,layerId=~Name)
  })
}

shinyApp(ui, server)


