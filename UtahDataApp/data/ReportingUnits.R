#Script for updating Reporting Unit Names and ID's
library(RCurl)
library(XML)

statedata = xmlRoot(xmlParse(getURLContent('https://water.utah.gov/DWRE/WADE/v0.2/GetCatalog/GetCatalog_GetAll.php?orgid=utwre'),useInternalNodes = TRUE))
reportlist = xmlToList(statedata)
n.reports = length(xmlToList(statedata))
RU_df=data.frame(RowIndex=seq(1,n.reports),row.names=NULL,stringsAsFactors = FALSE)
for(i in seq(1,n.reports)){
  reporttype = xmlSApply(statedata[[i]][["DataType"]],xmlValue)
  reportingunit_use = xmlSApply(statedata[[i]][["ReportUnitIdentifier"]],xmlValue)
  reportingunitname_use = xmlSApply(statedata[[i]][["ReportUnitName"]],xmlValue)
  RU_df[i,"ReportingUnit"] = as.character(reportingunit_use[1])
  RU_df[i,"ReportingUnitName"] = as.character(reportingunitname_use[1])
}
RU_df = RU_df[!duplicated(RU_df[,c('ReportingUnit','ReportingUnitName')]),]
RU_df$Name_ID = paste(RU_df$ReportingUnit,RU_df$ReportingUnitName)

save(RU_df,file="~/GitHub/Shiny-WaDE-Data-Explorer/UtahDataApp/data/ReportingUnits.Rdata")
  