# server.R
library(ggplot2)
library(XML)
library(RColorBrewer)
shinyServer(
  function(input, output) {
    #CONSUMPTIVE USE###################################################################################################################################    
    #Create reactive function that will fetch consumptive use data when the user changes the inputs (year or location)
    CU_data <- reactive({
      #Fetch and parse data
      xml.urlCU=paste0('http://www.westernstateswater.org/Wyoming/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',input$reportingunit,'&orgid=WYWDC&reportid=2014&datatype=USE')
      CUroot= xmlRoot(xmlParse(xml.urlCU,useInternalNodes = TRUE))
      #Extract Report Summary
      CUreportsummary=CUroot[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
      #Water use Categories (e.g. Agricultural, Municipal/Industrial)
      CUwaterusetype=xmlSApply(CUreportsummary,function(x) xmlSApply(x[[3]],xmlValue))
      CU_df=data.frame(Sector=as.factor(CUwaterusetype),row.names=NULL,stringsAsFactors = FALSE)
      n.uses=length(xmlToList(CUreportsummary))
        #Get values for the use amount
        for (i in seq(1,n.uses)){
          CUamountsummary=xmlSApply(CUreportsummary[[i]][[4]],xmlValue)
          if(is.null(CUreportsummary[[i]][[4]][["WaterUseAmount"]])){
            CUamount=as.character(rep(NA,4))
          }else{
          CUamount=xmlSApply(CUreportsummary[[i]][[4]][["WaterUseAmount"]],xmlValue)
          CUsource=CUamountsummary[2]
          }
        CU_df[i,"Amount"]=as.numeric(CUamount[1])
        CU_df[i,"Source"]=CUsource
        }
      return(CU_df)
    })
    CU_data()
    
    #Returns information about the method
    xml.urlCUMethod=paste0('http://www.westernstateswater.org/Wyoming/WADE/v0.2/GetMethod/GetMethod.php?methodid=WYWDC&methodname=Green%20River%20Basin%20Report%20Consumptive%20Use%20Estimation')
    CUmethodroot= xmlRoot(xmlParse(xml.urlCUMethod))
    #Extract Report Summary
    CUmethodsummary=CUmethodroot[["Organization"]][["Method"]]
    CUmethodinfo=xmlSApply(CUmethodsummary,function(x) xmlSApply(x,xmlValue))
    CUmethod_df=data.frame(t(CUmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots the results from the GetSummary call
    output$CUplot <- renderPlot({
      #Get data from reactive function (based on inputs of year and reporting unit)
      CU_df=CU_data()
      title="Comparison of Water Use by Sector"
      ggplot(data=CU_df,environment = environment())+
        geom_bar(aes(x=Sector,y=Amount, fill=Source),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="Paired")+
        xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
        theme(legend.position="bottom",plot.title = element_text(hjust = 0.5))
    })
    #Prints the method information
    output$CUmethod <- renderText(
        paste0("For more information about the methods used, see: ",CUmethod_df$MethodLinkText[[1]])
      )
    
    #Lists water use information in a table
    CU_df=CU_data()
    output$table <- renderTable(CU_df)
    
  }
)