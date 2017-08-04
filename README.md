# Shiny-WaDE-Data-Explorer
A collection of simple data exploratory tools, built using R and Shiny.

These tools are being developed to help demonstrate the utility of sharing data via WaDE. 
Goals include:
- facilitating data summarization
- demonstrating convenient visualization techniques
- enabling quick comparisons of water use or diversions (for instance, by sector (e.g. agricultural or municipal/industrial))

The R Shiny applications consists of two primary R scripts: ui.R and server.R. The server.R script uses the WaDE web services to query the WaDE database and return water use data for the user-specified reporting units. Additional scripts may be included in the application folders to augment functionality or provide datasets to the application.


This repository also contains an R package (under development), called **wadeR**.
Functions in wadeR include:

| Function | Description |
|----------|-------------|
| get_wade_data | Retrieves data (e.g. consumptive use, diversions, etc.) from a given url which utilizes the WaDE GetSummary web service (or file) and parses through the XML. |
| get_reporting_units | Retrieves content from a url using the WaDE GetCatalog_GetAll web service and parses through the XML to return a dataframe of reporting units for a specific state. |
