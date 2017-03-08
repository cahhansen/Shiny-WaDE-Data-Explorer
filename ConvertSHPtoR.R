library(leaflet)
library(rgdal)
library(rgeos)
library(sp)

setwd("C:/Users/carly/Google Drive/University of Utah - Research/Research Assistant/SnowpackDynamics (iUTAH and NASA projects)/Watersheds")
shp="wasatchcatchments.shp"
myshp = readOGR(dsn=shp, layer= basename(strsplit(shp,"\\.")[[1]])[1])
myshp_proj = spTransform(myshp, CRS("+proj=longlat +datum=WGS84"))
reportingunits=fortify(myshp_proj)
save(myshp_proj,file="C:/Users/carly/Documents/Shiny-WaDE-Data-Explorer/Mapapp/data/reportingunitsexample.RData")
load('C:/Users/carly/Documents/Shiny-WaDE-Data-Explorer/Mapapp/data/reportingunitsexample.RData')


m = leaflet(options = leafletOptions(minZoom=3,maxZoom =10))
m = addTiles(m) # Add default OpenStreetMap map tiles
m = addPolygons(m, data=myshp_proj,label=myshp_proj$Name)
m  # Print the map

