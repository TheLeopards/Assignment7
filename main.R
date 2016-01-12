# Author: TheLeopards (Samantha Krawczyk, Georgios Anastasiou)
# 12th January 2016
# Find the greenest municipality in The Netherlands

library(raster)



download.file("https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip", "data/MODIS.zip", method="wget")
unzip("data/MODIS.zip", exdir="data/")





