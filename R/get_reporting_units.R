#' get_reporting_units
#'
#' Get list of reporting units from wade service.
#' 
#' @param ru_url character, a url that will return reporting unit data. 
#' Will work with a path to a local file too.
#' 
#' @return \code{data.frame} containing wade data
#' 
#' @export
#' @importFrom XML xmlRoot
#' @importFrom XML xmlParse
#' @importFrom XML xmlSApply
#' @importFrom XML xmlValue
#' @importFrom RCurl getURLContent
#' 
#' @examples 
#' ru_url <- 'http://www.westernstateswater.org/Wyoming/WADE/v0.2/GetCatalog/GetCatalog_GetAll.php?orgid=WYWDC'
#' get_reporting_units(ru_url)
#' 
get_reporting_units <- function(ru_url) {
  
  if(file.exists(ru_url)) {
    content <- ru_url
  } else if(grepl("http", ru_url)) {
    content <- getURLContent(ru_url)
  } else {
    stop("Does not appear to be a URL and matching file not found.")
  }
  
  
  try({
    xml_root <- xmlRoot(xmlParse(content,
                                 useInternalNodes = TRUE))
    n.reports <- length(xmlToList(xml_root))
    
    RU_df <- data.frame(RowIndex = seq(1,n.reports), ReportingUnit = "", ReportingUnitName = "", stringsAsFactors = F)
    
    for(i in seq(1,n.reports)){
      reporttype <- xmlSApply(xml_root[[i]][["DataType"]],xmlValue)
      if(reporttype == "USE"){
        reportingunit_use <- xmlSApply(xml_root[[i]][["ReportUnitIdentifier"]],xmlValue)
        reportingunitname_use <- xmlSApply(xml_root[[i]][["ReportUnitName"]],xmlValue)
      }else{
        reportingunit_use <- NA
        reportingunitname_use <- NA
      }
      RU_df[i,"ReportingUnit"]<-as.character(reportingunit_use[1])
      RU_df[i,"ReportingUnitName"]<-as.character(reportingunitname_use[1])
    }
      RU_df <- RU_df[(!is.na(RU_df$ReportingUnit)),]
    
  return(RU_df)
  })
}
