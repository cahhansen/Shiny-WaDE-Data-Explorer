#Script for updating Reporting Unit Names and ID's
library(RCurl)
library(XML)
library(wadeR)

ru_url <- 'https://water.utah.gov/DWRE/WADE/v0.2/GetCatalog/GetCatalog_GetAll.php?orgid=utwre'
RU_df <- get_reporting_units(ru_url)
RU_df = RU_df[!duplicated(RU_df[,c('ReportingUnit','ReportingUnitName')]),]
RU_df$Name_ID = paste(RU_df$ReportingUnit,RU_df$ReportingUnitName)

save(RU_df,file="~/GitHub/Shiny-WaDE-Data-Explorer/UtahDataApp/data/ReportingUnits.Rdata")
  