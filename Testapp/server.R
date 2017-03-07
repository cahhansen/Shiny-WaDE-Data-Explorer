# server.R
library(ggplot2)
library(XML)
library(RColorBrewer)
shinyServer(
  function(input, output) {
    
    
    output$plot <- renderPlot({
      #Fetch and parse data
      xml.url=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=utwre&reportid=',input$year,'_',input$datatype,'&datatype=ALL')
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
      wateruse_df$WaterUseTypeName=as.factor(waterusetype)
      if(input$datatype=="ConsumptiveUse"){
        title="Comparison of Water Use by Sector"
        ggplot(data=wateruse_df,environment = environment())+
          geom_bar(aes(x=WaterUseTypeName,y=AmountNumber, fill=WaterUseTypeName),stat="identity")+
          theme_bw()+scale_fill_brewer(palette="Paired")+
          xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
          geom_text(aes(label = AmountNumber, x=WaterUseTypeName, y=AmountNumber),size = 5, position = position_stack(vjust = 0.5))+
          theme(legend.position="none",plot.title = element_text(hjust = 0.5))
      }else if(input$datatype=="Diversion"){
      sourcetype=xmlSApply(reportsummary,function(x) xmlSApply(x[[3]][[2]],xmlValue))
      wateruse_df$SourceTypeName=as.factor(sourcetype)
        title="Comparison of Diversions by Sector"
        ggplot(data=wateruse_df,environment = environment())+
          geom_bar(aes(x=WaterUseTypeName,y=AmountNumber, fill=SourceTypeName),stat="identity")+
          theme_bw()+scale_fill_brewer(palette="Paired", name="Source")+
          xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
          geom_text(aes(label = AmountNumber, x=WaterUseTypeName, y=AmountNumber),size = 3, position = position_stack(vjust = 0.5))+
          theme(legend.position="bottom",plot.title = element_text(hjust = 0.5))
        
      }
      
      })
  }
)