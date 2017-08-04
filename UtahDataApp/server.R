# server.R

shinyServer(
  function(input, output,session) {
    #REPORTING UNIT INFO##############################################################################################################################
    load("data/ReportingUnits.Rdata")
    
    #CONSUMPTIVE USE###################################################################################################################################    
    #Fetch consumptive use data when the user changes the inputs (year or location)
    CU_data <- reactive({
      RUNumber <- RU_df[(RU_df$Name_ID==input$reportingunit),"ReportingUnit"]
      #Fetch and parse data
      CU_url <- paste0('https://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',
                       RUNumber,
                       '&orgid=utwre&reportid=',
                       input$year,
                       '_ConsumptiveUse&datatype=ALL')
      
      return(get_wade_data(wade_url = CU_url))
    })
    
    #Returns information about the method
    xml.urlCUMethod <- getURLContent('https://water.utah.gov/DWRE/WADE/v0.2/GetMethod/GetMethod.php?methodid=utwre&methodname=CONSUMPTIVE_USE')
    CUmethodroot <- xmlRoot(xmlParse(xml.urlCUMethod))
    #Extract Report Summary
    CUmethodsummary <- CUmethodroot[["Organization"]][["Method"]]
    CUmethodinfo <- xmlSApply(CUmethodsummary,function(x) xmlSApply(x,xmlValue))
    CUmethod_df <- data.frame(t(CUmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots the results from the GetSummary call
    output$CUplot <- renderPlotly({
      #Get data from reactive function (based on inputs of year and reporting unit)
      CU_df <- CU_data()
      title <- "Comparison of Water Use by Sector"
      CU_plot <-  ggplot(data=CU_df,environment = environment())+
        geom_bar(aes(x=Sector,y=Amount, fill=Sector),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="Paired")+
        xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
        theme(legend.position="none",plot.title = element_text(hjust = 0.5))
      ggplotly(CU_plot)
    })
    
    #List amounts in table
    output$CUtable <- renderTable({
      CU_df <- CU_data()
    },bordered=TRUE, striped=TRUE)
    
    
    #Prints the method information
    output$CUmethod <- renderText(
        paste0("For more information about the methods used, see: ",
               CUmethod_df$MethodLinkText[[1]])
      )
    
    #DIVERSION##########################################################################################################################################    
    #Create reactive function that will fetch diversion data when the user changes the inputs (year or location)
    Div_data <- reactive({
      RUNumber <- RU_df[(RU_df$Name_ID==input$reportingunit),"ReportingUnit"]
      #Fetch and parse data
      Div_url <- paste0('https://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=',
                       RUNumber,
                       '&orgid=utwre&reportid=',
                       input$year,
                       '_Diversion&datatype=ALL')
      
      return(get_wade_data(wade_url = Div_url))  
    })  
      
    
    #Returns information about the method
    xml.urlDivMethod <- getURLContent('https://water.utah.gov/DWRE/WADE/v0.2/GetMethod/GetMethod.php?methodid=utwre&methodname=DIVERSION')
    Divmethodroot <- xmlRoot(xmlParse(xml.urlDivMethod))
    #Extract Report Summary
    Divmethodsummary <- Divmethodroot[["Organization"]][["Method"]]
    Divmethodinfo <- xmlSApply(Divmethodsummary,function(x) xmlSApply(x,xmlValue))
    Divmethod_df <- data.frame(t(Divmethodinfo),row.names=NULL,stringsAsFactors = FALSE)
    
    #Plots results from the GetSummary call
    output$Divplot <- renderPlotly({
      Div_df <- Div_data()
      title <- "Comparison of Diversions by Sector"
      Div_plot <-  ggplot(data=Div_df,environment = environment())+
        geom_bar(aes(x=Sector,y=Amount, fill=SourceType),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="Paired", name="Source")+
        xlab("Sector")+ylab("Diversions (acre-feet/year)")+ggtitle(title)+
        theme(legend.position="bottom",plot.title = element_text(hjust = 0.5))
      ggplotly(Div_plot)
    })
    
    #List amounts in table
    output$Divtable <-renderTable({
      Div_df <- Div_data()
    },bordered=TRUE,striped=TRUE)
    
    
    #Prints the method information
    output$Divmethod <- renderText(
      paste0("For more information about the methods used, see: ",Divmethod_df$MethodLinkText[[1]])
      )
  }
)