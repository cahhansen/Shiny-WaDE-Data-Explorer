# server.R

library(maps)
library(mapproj)
counties <- readRDS("data/counties.rds")
source("helpers.R")


shinyServer(
  function(input, output) {
    
    
    output$plot <- renderPlot({
      #Read in data
      xml.url=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=03-01-01&orgid=utwre&reportid=',input$year,'_ConsumptiveUse&datatype=USE')
      xmlresult <- xmlParse(xml.url)
      r=xmlRoot(xmlresult)
      #Extract Report Summary
      reportsummary=r[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
      #Water use Categories (e.g. Agricultural, Municipal/Industrial)
      waterusetype=xmlSApply(reportsummary,function(x) xmlSApply(x[[2]],xmlValue))
      #Extract Water Use Summary
      waterusesummaryinfo=xmlSApply(reportsummary,function(x) xmlSApply(x[[3]][[3]],xmlValue))
      #Format into data.frame object
      wateruse_df=data.frame(t(waterusesummaryinfo),row.names=NULL,stringsAsFactors = FALSE)
      wateruse_df$AmountNumber=as.numeric(wateruse_df$AmountNumber)
      wateruse_df$WaterUse=as.factor(waterusetype)
      barplot(height=wateruse_df$AmountNumber)
    })
  }
)