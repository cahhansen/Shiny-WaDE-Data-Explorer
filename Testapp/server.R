# server.R
library(ggplot2)
library(XML)
library(RColorBrewer)
shinyServer(
  function(input, output) {
#CONSUMPTIVE USE###################################################################################################################################    
    #Create reactive function that will fetch consumptive use data when the user changes the inputs (year or location)
    wateruse_data <- reactive({
      #Create data frame
      wateruse_df=data.frame()
      #Fetch and parse data
      xml.urlCU=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=utwre&reportid=',input$year,'_ConsumptiveUse&datatype=ALL')
      CUroot= xmlRoot(xmlParse(xml.urlCU,useInternalNodes = TRUE))
      #Extract Report Summary
      CUreportsummary=CUroot[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
      #Water use Categories (e.g. Agricultural, Municipal/Industrial)
      CUwaterusetype=xmlSApply(CUreportsummary,function(x) xmlSApply(x[[2]],xmlValue))
      CUwaterusesummaryinfo=xmlSApply(CUreportsummary,function(x) xmlSApply(x[[3]][[3]],xmlValue))
      waterCU_df=data.frame(t(CUwaterusesummaryinfo),row.names=NULL,stringsAsFactors = FALSE)
      #Format data.frame object
      waterCU_df$AmountNumber=as.numeric(waterCU_df$AmountNumber)
      waterCU_df$WaterUseTypeName=as.factor(CUwaterusetype)
      
      return(waterCU_df)
    })
    
    #Returns information about the method
    xml.urlCUMethod=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetMethod/GetMethod.php?methodid=utwre&methodname=CONSUMPTIVE_USE')
    CUmethodroot= xmlRoot(xmlParse(xml.urlCUMethod))
    #Extract Report Summary
    CUmethodsummary=CUmethodroot[["Organization"]][["Method"]]
    CUmethodinfo=xmlSApply(CUmethodsummary,function(x) xmlSApply(x,xmlValue))
    CUmethod_df=data.frame(t(CUmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots the results from the GetSummary call
    output$CUplot <- renderPlot({
      #Get data from reactive function (based on inputs of year and reporting unit)
      wateruse_df=wateruse_data()
      title="Comparison of Water Use by Sector"
      ggplot(data=wateruse_df,environment = environment())+
        geom_bar(aes(x=WaterUseTypeName,y=AmountNumber, fill=WaterUseTypeName),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="Paired")+
        xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
        geom_text(aes(label = AmountNumber, x=WaterUseTypeName, y=AmountNumber),size = 5, position = position_stack(vjust = 0.5))+
        theme(legend.position="none",plot.title = element_text(hjust = 0.5))
    })
    #Prints the method information
    output$CUMethod <- renderText(paste0("For more information about the methods used, see: ",CUmethod_df$MethodLinkText[[1]]))
    
#DIVERSION##########################################################################################################################################    
    #Create reactive function that will fetch diversion data when the user changes the inputs (year or location)
    waterdiv_data <- reactive({
      #Fetch and parse data
      xml.urlDiv=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=utwre&reportid=',input$year,'_Diversion&datatype=ALL')
      root= xmlRoot(xmlParse(xml.urlDiv))
      #Extract Report Summary
      reportsummary=root[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
      #Water use Categories (e.g. Agricultural, Municipal/Industrial)
      waterusetype=xmlSApply(reportsummary,function(x) xmlSApply(x[[2]],xmlValue))
      #Extract Water Use Summary
      waterusesummaryinfo=xmlSApply(reportsummary,function(x) xmlSApply(x[[3]][[3]],xmlValue))
      waterdiv_df=data.frame(t(waterusesummaryinfo),row.names=NULL,stringsAsFactors = FALSE)
      #Format data.frame object
      waterdiv_df$AmountNumber=as.numeric(waterdiv_df$AmountNumber)
      waterdiv_df$WaterUseTypeName=as.factor(waterusetype)
      sourcetype=xmlSApply(reportsummary,function(x) xmlSApply(x[[3]][[2]],xmlValue))
      waterdiv_df$SourceTypeName=as.factor(sourcetype)
      return(waterdiv_df)
    })
    
    #Returns information about the method
    xml.urlDivMethod=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetMethod/GetMethod.php?methodid=utwre&methodname=DIVERSION')
    Divmethodroot= xmlRoot(xmlParse(xml.urlDivMethod))
    #Extract Report Summary
    Divmethodsummary=Divmethodroot[["Organization"]][["Method"]]
    Divmethodinfo=xmlSApply(Divmethodsummary,function(x) xmlSApply(x,xmlValue))
    Divmethod_df=data.frame(t(Divmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots results from the GetSummary call
    output$Divplot <- renderPlot({
      waterdiv_df=waterdiv_data()
      title="Comparison of Diversions by Sector"
      ggplot(data=waterdiv_df,environment = environment())+
        geom_bar(aes(x=WaterUseTypeName,y=AmountNumber, fill=SourceTypeName),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="Paired", name="Source")+
        xlab("Sector")+ylab("Diversions (acre-feet/year)")+ggtitle(title)+
        geom_text(aes(label = AmountNumber, x=WaterUseTypeName, y=AmountNumber),size = 3, position = position_stack(vjust = 0.5))+
        theme(legend.position="bottom",plot.title = element_text(hjust = 0.5))
    })
    
    #Prints the method information
    output$DivMethod <- renderText(paste0("For more information about the methods used, see: ",Divmethod_df$MethodLinkText[[1]]))
  }
)