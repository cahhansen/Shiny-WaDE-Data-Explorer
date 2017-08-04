# Shiny-WaDE-Data-Explorer
A collection of simple data exploratory tools, built using R and Shiny.

These tools are being developed to help demonstrate the utility of sharing data via WaDE. 
Goals include:
- facilitating data summarization
- enabling quick comparisons of water use or diversions (for instance, by sector (e.g. agricultural or municipal/industrial))

The R Shiny applications consists of two R scripts: ui.R and server.R. The server.R script uses the WaDE web services to query the WaDE database and return water use data for the user-specified reporting units.
