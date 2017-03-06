#Read in XML Data and organize into Data Frame for Analysis

library(XML)
#User input of name of xml (as a placeholder of a variable in the GetSummary web service)
datatype="USE"
xml.url=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=03-01-01&orgid=utwre&reportid=2014_ConsumptiveUse&datatype=',datatype)

#Detail Example (allocation)
xml.detail.url=('http://www.water.utah.gov/DWRT/WADE/v0.2/GetDetail/GetDetail.php?reportid=2016&loctype=REPORTUNIT&loctxt=03-01-01&datatype=ALLOCATION')


xmlresult <- xmlParse(xml.url)
r=xmlRoot(xmlresult)
#Extract specific values
reportdata=xmlSApply(r[[1]][[6]][[7]][[5]],function(x) xmlSApply(x, xmlValue))
#Format into data.frame object
report_df=data.frame(t(reportdata),row.names=NULL)

