# server.R
library(ggplot2)
shinyServer(
  function(input, output) {
    
    
    output$plot <- renderPlot({
      #Fetch and parse data
      xml.url=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=utwre&reportid=',input$year,'_ConsumptiveUse&datatype=USE')
      root= xmlRoot(xmlParse(xml.url))
      #Extract Report Summary
      reportsummary=root[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
      #Water use Categories (e.g. Agricultural, Municipal/Industrial)
      waterusetype=xmlSApply(reportsummary,function(x) xmlSApply(x[[2]],xmlValue))
      #Extract Water Use Summary
      waterusesummaryinfo=xmlSApply(reportsummary,function(x) xmlSApply(x[[3]][[3]],xmlValue))
      #Format into data.frame object
      wateruse_df=data.frame(t(waterusesummaryinfo),row.names=NULL,stringsAsFactors = FALSE)
      wateruse_df$AmountNumber=as.numeric(wateruse_df$AmountNumber)
      wateruse_df$WaterUse=as.factor(waterusetype)
      #barplot(height=wateruse_df$AmountNumber,names.arg=wateruse_df$WaterUse,main=paste0("Water Use by Sector in ",input$year))
      ggplot(data=wateruse_df,environment = environment())+
        geom_bar(aes(x=WaterUse,y=AmountNumber),stat="identity")+
        theme_bw()+xlab("Sector")+ylab("Water Use in Gallons")
      })
  }
)