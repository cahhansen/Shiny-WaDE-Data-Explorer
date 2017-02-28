#Read in XML Data and organize into Data Frame for Analysis
library(XML)
#User input of name of xml (as a placeholder of a variable in the GetSummary web service)
datatype="ALL"
xml.url=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=01-01-01&orgid=utwre&reportid=2014_ConsumptiveUse&datatype=',datatype)
xmlresult <- xmlParse(xml.url)
r=xmlRoot(xmlresult)

reportdata=xmlSApply(r[[1]][[6]][[7]][[5]],function(x) xmlSApply(x, xmlValue))
report_df=data.frame(t(reportdata),row.names=NULL)

