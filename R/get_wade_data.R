#' get_wade_data
#'
#' Get data from a wade service.
#' 
#' @param wade_url character, a url that will return wade data. 
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
#' wade_url <- paste0("https://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?",
#'                    "loctype=REPORTUNIT&loctxt=00-02-02&orgid=utwre",
#'                    "&reportid=2005_ConsumptiveUse&datatype=ALL")
#' get_wade_data(wade_url)
#' 
get_wade_data <- function(wade_url) {
  
  if(file.exists(wade_url)) {
    content <- wade_url
  } else if(grepl("http", wade_url)) {
    content <- getURLContent(wade_url)
  } else {
    stop("Does not appear to be a URL and matching file not found.")
  }
  
  out_df <- data.frame(Sector = "", SourceType = "", Amount = "", stringsAsFactors = F)
  
  try({
    xml_root <- xmlRoot(xmlParse(content,
                                 useInternalNodes = TRUE))
    
    xml_reportsummary <- xml_root[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
    
    xml_reportsupply <- xml_root[["Organization"]][["Report"]][["ReportingUnit"]][["DerivedWaterSupplySummary"]]
    
    if(!is.null(xml_reportsummary)) {
      waterusetype <- xmlSApply(xml_reportsummary,
                                function(x) xmlSApply(x[["WaterUseTypeName"]], xmlValue))
      
      out_df <- data.frame(Sector = waterusetype,
                           row.names = NULL,
                           stringsAsFactors = FALSE)
      
      for (i in 1:nrow(out_df)) { # probably a better way to do this?
        xml_use_summary <- xmlSApply(xml_reportsummary[[i]], xmlValue)
        
        amountsummary <- xmlSApply(xml_reportsummary[[i]][["WaterUseAmountSummary"]], xmlValue)
        
        out_df[i,"SourceType"] <- amountsummary[["SourceTypeName"]]
        
        if(is.null(xml_reportsummary[[i]][["WaterUseAmountSummary"]][["WaterUseAmount"]][["AmountNumber"]])) {
          out_df[i,"Amount"] <- as.numeric(NA)
        } else {
          out_df[i,"Amount"] <- as.numeric(xmlSApply(xml_reportsummary[[i]][["WaterUseAmountSummary"]]
                                                     [["WaterUseAmount"]][["AmountNumber"]], 
                                                     xmlValue))
        }
      }
    } else if(!is.null(xml_reportsupply)) {
      wateruse_supply_type <- xmlSApply(xml_reportsupply,
                                        function(x) xmlSApply(x[["WaterSupplyTypeName"]], 
                                                              xmlValue))
      
      out_df <- data.frame(Type = wateruse_supply_type, 
                           row.names = NULL, stringsAsFactors = FALSE)
      
      #Get values for the use amount
      for (i in 1:nrow(out_df)) {
        if(is.null(xml_reportsupply[[i]][[3]][["AmountNumber"]])){
          amount <- as.character(rep(NA, 4))
        } else {
          amount <- xmlSApply(xml_reportsupply[[i]][["SupplyAmountSummary"]][["AmountNumber"]],
                              xmlValue)
        }
        out_df[i,"Amount"] <- as.numeric(amount[1])
      }
    }
  })
  return(out_df)
}
