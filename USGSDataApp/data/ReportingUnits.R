#Script for updating Reporting Unit Names and ID's
library(dplyr)

tgz_file <- "./awuds-staging.tar.gz"

if(!file.exists(tgz_file)) download.file(url = "https://cida.usgs.gov/artifactory/WUDS_db/awuds-staging-0.0.1.tar.gz",
                                         destfile = "./awuds-staging.tar.gz")

system(paste("tar -xzvf", tgz_file, "--include REPORTING_UNIT.csv"))

unit_data <- readr::read_csv("REPORTING_UNIT.csv")

report_units <- unit_data %>% distinct(REPORT_UNIT_ID, .keep_all = T)

RU_df <- data.frame(list(
  RowIndex = c(1:nrow(report_units)),
  ReportingUnit = report_units$REPORT_UNIT_ID,
  ReportingUnitName = report_units$REPORTING_UNIT_NAME,
  Name_ID = paste(report_units$REPORT_UNIT_ID, report_units$REPORTING_UNIT_NAME)
), stringsAsFactors = F)

save(RU_df,file="./data/ReportingUnits.Rdata")
  