#Read in XML Data and organize into Data Frame for Analysis

library(XML)
#User input of name of xml (as a placeholder of a variable in the GetSummary web service)
datatype="USE"
#Summary Example
xml.url=paste0('http://water.utah.gov/DWRE/WADE/v0.2/GetSummary/GetSummary.php?loctype=REPORTUNIT&loctxt=03-01-01&orgid=utwre&reportid=2014_ConsumptiveUse&datatype=',datatype)
xmlresult <- xmlParse(xml.url)
doc=xmlTreeParse(xml.url,useInternal=TRUE)
r=xmlRoot(xmlresult)
#Extract Report Summary
reportsummary=r[["Organization"]][["Report"]][["ReportingUnit"]][["WaterUseSummary"]]
#Water use Categories (e.g. Agricultural, Municipal/Industrial)
waterusetype=xmlSApply(reportsummary,function(x) xmlSApply(x[[2]],xmlValue))
#Extract Water Use Summary
waterusesummaryinfo=xmlSApply(reportsummary,function(x) xmlSApply(x[[3]][[3]],xmlValue))
#Format into data.frame object
wateruse_df=data.frame(t(waterusesummaryinfo),row.names=NULL)
wateruse_df$WaterUse=waterusetype

#Detail Example (allocation)
xml.detail.url=('http://www.water.utah.gov/DWRT/WADE/v0.2/GetDetail/GetDetail.php?reportid=2016&loctype=REPORTUNIT&loctxt=03-01-01&datatype=ALLOCATION')
