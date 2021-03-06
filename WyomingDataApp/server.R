# server.R
library(ggplot2)
library(XML)
library(RColorBrewer)
library(wadeR)
shinyServer(
  function(input, output, session) {
    outVar <- reactive({
      #Fetch reporting units for the state (for selection in dropdown menu)
      ru_url <- 'http://www.westernstateswater.org/Wyoming/WADE/v0.2/GetCatalog/GetCatalog_GetAll.php?orgid=WYWDC'
      RU_df <- get_reporting_units(ru_url)
    })
    
    observe({
      RU_df <- outVar()
      RUNames <- RU_df$ReportingUnitName
      updateSelectInput(session, "reportingunit",
                        choices = RUNames)
    })
    
    #WATER USE###################################################################################################################################    
    #Fetch consumptive use data when the user changes the inputs (location)
    CU_data <- reactive({
      RU_df <- outVar()
      RU_dfSub <- RU_df[!is.na(RU_df$ReportingUnitName),]
      RUNumber <- RU_dfSub[(RU_dfSub$ReportingUnitName==input$reportingunit),"ReportingUnit"]
      
      wade_url <- paste0('http://www.westernstateswater.org/Wyoming/WADE/v0.2/GetSummary/GetSummary.php?',
                         'loctype=REPORTUNIT&loctxt=',
                         RUNumber,
                         '&orgid=WYWDC&reportid=2014&datatype=USE')

      return(get_wade_data(wade_url = wade_url))
      
    })

    
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
        geom_bar(aes(x=Sector,y=Amount, fill=SourceType),stat="identity")+
        theme_bw()+scale_fill_brewer(palette="Paired")+
        xlab("Sector")+ylab("Water Use (acre-feet/year)")+ggtitle(title)+
        theme(legend.position="bottom",plot.title = element_text(hjust = 0.5))
    })
    #Prints the method information
    output$CUmethod <- renderText(
        paste0("For more information about the methods used, see: ",CUmethod_df$MethodLinkText[[1]])
      )

    #List amounts in table
    output$table <- renderTable({
      CU_df=CU_data()
    },bordered=TRUE, striped=TRUE)
  }
)