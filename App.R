library(shiny)
library(shinybootstrap2)
shinybootstrap2::withBootstrap2({
shinyApp(
  ui = fluidPage(
    headerPanel("WaDE Exploratory Data Analysis"),
    sidebarPanel(selectInput("n", "Data Type", c(1, 5, 10))),
    mainPanel(plotOutput("plot"))
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      plot(head(cars, as.numeric(input$n)))
    })
  }
)
})