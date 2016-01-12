# Author: TheLeopards (Samantha Krawczyk, Georgios Anastasiou)
# 12th January 2016
# Find the greenest municipality in The Netherlands

library(raster)
library(rgdal)


download.file("https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip", "data/MODIS.zip", method="wget")
unzip("data/MODIS.zip", exdir="data/")


#nlCountry <- getData('GADM',country='NLD', level=0)
nlMunicipality <- getData('GADM',country='NLD', level=2)

modisPath <- list.files(path="data/", pattern = glob2rx('MO*.grd'), full.names = TRUE)

NLmodis <- brick(modisPath)

#plot(NLmodis, 1)

nlMunicipality_sinu <- spTransform(nlMunicipality, CRS(proj4string(NLmodis)))

#NLmodisSub <- mask(NLmodisUTM, nlCountry)

NDVI_jan <- raster(NLmodis, 1)
NDVI_aug <- raster(NLmodis, 8)

NDVI_jan_Mun <- extract(NDVI_jan, nlMunicipality_sinu, df=TRUE,fun=mean, sp=TRUE, na.rm=TRUE)


# select municipaliy name (NAME_2) out of NDVI_jan_Mun , where January==max
jan_max <- NDVI_jan_Mun$NAME_2[which(NDVI_jan_Mun$January == max(NDVI_jan_Mun$January, na.rm=TRUE))]








