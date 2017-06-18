library(RCurl)
library(XML)
function(input, output, session) {

  selecteddata = reactive({
    waterusexml=getURL(paste0('https://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=01-01-01&orgid=utwre&reportid=',input$year,'_ConsumptiveUse&datatype=ALL'))
    CUroot= xmlRoot(xmlParse(waterusexml,useInternalNodes = TRUE))
    #Extract Report Summary
    CUreportsummary=CUroot[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
    #Water use Categories (e.g. Agricultural, Municipal/Industrial)
    CUwaterusetype=xmlSApply(CUreportsummary,function(x) xmlSApply(x[[2]],xmlValue))
    CU_df=data.frame(Sector=as.factor(CUwaterusetype),row.names=NULL,stringsAsFactors = FALSE)
    n.uses=length(xmlToList(CUreportsummary))
    #Get values for the use amount
    for (i in seq(1,n.uses)){
      CUsummaryinfo=xmlSApply(CUreportsummary[[i]],xmlValue)
      CUamountsummary=xmlSApply(CUreportsummary[[i]][[3]],xmlValue)
      if(is.null(CUreportsummary[[i]][[3]][["WaterUseAmount"]])){
        CUamount=as.character(rep(NA,4))
      }else{
        CUamount=xmlSApply(CUreportsummary[[i]][[3]][["WaterUseAmount"]],xmlValue)
      }
      CU_df[i,"Amount"]=as.numeric(CUamount[1])
    }
    return(CU_df)
  })

  
  output$WaterUseTable <- renderTable({
    CU_df=selecteddata()
  },bordered=TRUE, striped=TRUE)
  
}
