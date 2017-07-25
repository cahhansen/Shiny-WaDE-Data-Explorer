# server.R
library(ggplot2)
library(XML)
library(RColorBrewer)


shinyServer(
  function(input, output,session) {
    #REPORTING UNIT INFO##############################################################################################################################
    outVar = reactive({
      statedata = xmlRoot(xmlParse('http://wade.sdsc.edu/WADE/v0.2/GetCatalog/GetCatalog_GetAll.php'))
      reportlist=xmlToList(statedata)
      n.reports=length(xmlToList(statedata))
      RU_df=data.frame(RowIndex=seq(1,n.reports),row.names=NULL,stringsAsFactors = FALSE)
      for(i in seq(1,n.reports)){
        reporttype=xmlSApply(statedata[[i]][["DataType"]],xmlValue)
        reportingunitname_use=xmlSApply(statedata[[i]][["ReportUnitName"]],xmlValue)
        RU_df[i,"ReportingUnitName"]=as.character(reportingunitname_use[1])
      }
      RU_df=RU_df[!duplicated(RU_df[,c('ReportingUnitName')]),]
      return(RU_df)
    })
    observe({
      RU_df=outVar()
      RUNames=RU_df[!is.na(RU_df$ReportingUnitName),"ReportingUnitName"]
      
      updateSelectInput(session, "reportingunit",
                        choices = RUNames)
    })
    
    
    #WATER SUPPLY###################################################################################################################################    
    #Create reactive function that will fetch water supply data when the user changes the inputs (year or location)
    WS_data <- reactive({
      RU_df=outVar()
      #Fetch and parse data
      xml.urlWS=paste0('http://wade.sdsc.edu/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=CA-DWR&reportid=',input$year,'&datatype=SUPPLY')
        WSroot= xmlRoot(xmlParse(xml.urlWS,useInternalNodes = TRUE))
        #Extract Report Summary
        WSreportsummary=WSroot[["Organization"]][["Report"]][["ReportingUnit"]][["DerivedWaterSupplySummary"]]
        #Water use Categories (e.g. Agricultural, Municipal/Industrial)
        WSsupplytype=xmlSApply(WSreportsummary,function(x) xmlSApply(x[[2]],xmlValue))
        WS_df=data.frame(Type=as.factor(WSsupplytype),row.names=NULL,stringsAsFactors = FALSE)
        n.supplies=length(xmlToList(WSreportsummary))
        #Get values for the use amount
        for (i in seq(1,n.supplies)){
          #WSsummaryinfo=xmlSApply(WSreportsummary[[i]],xmlValue)
          WSamountsummary=xmlSApply(WSreportsummary[[i]][[3]],xmlValue)
          if(is.null(WSreportsummary[[i]][[3]][["AmountNumber"]])){
            WSamount=as.character(rep(NA,4))
          }else{
          WSamount=xmlSApply(WSreportsummary[[i]][[3]][["AmountNumber"]],xmlValue)
          }
        WS_df[i,"Amount"]=as.numeric(WSamount[1])
        }
      return(WS_df)
    })
    
    #Returns information about the method
    xml.urlWSMethod='http://wade.sdsc.edu/WADE/v0.2/GetMethod/GetMethod.php?methodid=CA-DWR&methodname=CA%20DWR%20Hydrologic%20Analysis%20(hellyj@ucsd.edu)'
    WSmethodroot= xmlRoot(xmlParse(xml.urlWSMethod))
    #Extract Report Summary
    WSmethodsummary=WSmethodroot[["Organization"]][["Method"]]
    WSmethodinfo=xmlSApply(WSmethodsummary,function(x) xmlSApply(x,xmlValue))
    WSmethod_df=data.frame(t(WSmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots the results from the GetSummary call
    output$WSplot <- renderPlot({
      #Get data from reactive function (based on inputs of year and reporting unit)
      WS_df=WS_data()
      WS_dfsub=WS_df[(WS_df$Amount!=0),]
      WS_dfsub$Type=factor(WS_dfsub$Type)
      
      if (input$displaytype=="Barplot"){
      title=paste0("Water Supplies in ",input$reportingunit)
      ggplot(data=WS_dfsub,environment = environment())+
        geom_bar(aes(x=Type,y=Amount, fill=Type),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="GnBu")+
        xlab("Supply Type")+ylab("Water Supply (acre-feet/year)")+ggtitle(title)+
        theme(legend.position="none",plot.title = element_text(hjust = 0.5,size=12))+
        theme(axis.text.x = element_text(angle = 0,hjust=0.5))
      }
      else if (input$displaytype=="Pie Chart"){
      title=paste0("Water Supplies in ",input$reportingunit," by Type")
      pie(WS_dfsub$Amount,labels=WS_dfsub$Type,col=rainbow(length(WS_dfsub$Type)),
            main=title)
      }
      else{
      title=paste0("Water Supplies in ",input$reportingunit)
      dotchart(WS_df$Amount,labels=WS_df$Type,cex=.7,
               main=title,ps=6,
               xlab="Water Supply (acre-feet/year)")
      } 
    })
    
    #List amounts in table
    output$WStable <- renderTable({
      WS_df=WS_data()
    },bordered=TRUE, striped=TRUE)
    
    
    #Prints the method information
    output$WSmethod <- renderText(
        paste0("This data is derived from ",WSmethod_df$MethodDescriptionText,". For more information about the methods used, see: ",WSmethod_df$MethodLinkText[[1]])
      )
    
    #WATER USE###################################################################################################################################    
    #Create reactive function that will fetch water supply data when the user changes the inputs (year or location)
    WU_data <- reactive({
      RU_df=outVar()
      #Fetch and parse data
      xml.urlWU=paste0('http://wade.sdsc.edu/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=CA-DWR&reportid=',input$year,'&datatype=USE')
      WUroot= xmlRoot(xmlParse(xml.urlWU,useInternalNodes = TRUE))
      #Extract Report Summary
      WUreportsummary=WUroot[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
      #Water use Categories (e.g. Agricultural, Municipal/Industrial)
      WUtype=xmlSApply(WUreportsummary,function(x) xmlSApply(x[[3]],xmlValue))
      WU_df=data.frame(Sector=as.factor(WUtype),row.names=NULL,stringsAsFactors = FALSE)
      n.uses=length(xmlToList(WUreportsummary))
      #Get values for the use amount
      for (i in seq(1,n.uses)){
        if(is.null(WUreportsummary[[i]][[4]][["WaterUseAmount"]][["AmountNumber"]])){
          WUamount=as.character(rep(NA,4))
        }else{
          WUamount=xmlSApply(WUreportsummary[[i]][[4]][["WaterUseAmount"]][["AmountNumber"]],xmlValue)
        }
        WU_df[i,"Amount"]=as.numeric(WUamount[1])
      }
      return(WU_df)
    })
    
    #Returns information about the method
    xml.urlWUMethod='http://wade.sdsc.edu/WADE/v0.2/GetMethod/GetMethod.php?methodid=CA-DWR&methodname=CA%20DWR%20Hydrologic%20Analysis%20(hellyj@ucsd.edu))'
    WUmethodroot= xmlRoot(xmlParse(xml.urlWUMethod))
    #Extract Report Summary
    WUmethodsummary=WSmethodroot[["Organization"]][["Method"]]
    WUmethodinfo=xmlSApply(WUmethodsummary,function(x) xmlSApply(x,xmlValue))
    WUmethod_df=data.frame(t(WUmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots the results from the GetSummary call
    output$WUplot <- renderPlot({
      #Get data from reactive function (based on inputs of year and reporting unit)
      WU_df=WU_data()
      WU_dfsub=WU_df[(WU_df$Amount!=0),]
      WU_dfsub$Sector=factor(WU_dfsub$Sector)
      if (input$displaytype=="Barplot"){
        title=paste0("Water Use in ",input$reportingunit)
        ggplot(data=WU_dfsub,environment = environment())+
          geom_bar(aes(x=Sector,y=Amount, fill=Sector),stat="identity")+
          theme_bw()+scale_fill_brewer(palette="GnBu")+
          xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
          theme(legend.position="none",plot.title = element_text(hjust = 0.5,size=12))+
          theme(axis.text.x = element_text(angle = 0,hjust=0.5))
      }
      else if (input$displaytype=="Pie Chart"){
        title=paste0("Water Use in ",input$reportingunit," by Sector")
        pie(WU_dfsub$Amount,labels=WU_dfsub$Sector,col=rainbow(length(WU_dfsub$Sector)),
            main=title)
      }
      else{
        title=paste0("Water Use in ",input$reportingunit)
        dotchart(WU_df$Amount,labels=WU_df$Sector,cex=.7,
                 main=title,ps=6,
                 xlab="Water Supply (acre-feet/year)")
      } 
    })
    
    #List amounts in table
    output$WUtable <- renderTable({
      WU_df=WU_data()
    },bordered=TRUE, striped=TRUE)
    
    
    #Prints the method information
    output$WUmethod <- renderText(
      paste0("This data is derived from ",WUmethod_df$MethodDescriptionText,". For more information about the methods used, see: ",WUmethod_df$MethodLinkText[[1]])
    )
  }
)