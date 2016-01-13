# Author: TheLeopards (Samantha Krawczyk, Georgios Anastasiou)
# 12th January 2016
# Find the greenest municipality in The Netherlands

library(raster)
library(rgdal)

# downloading and preparing MODIS NDVI data
download.file("https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip", "data/MODIS.zip", method="wget")
unzip("data/MODIS.zip", exdir="data/")
modisPath <- list.files(path="data/", pattern = glob2rx('MO*.grd'), full.names = TRUE)
NLmodis <- brick(modisPath)

#downloading and preparing NL municipality border data
nlMunicipality <- getData('GADM',country='NLD', level=2)
nlMunicipality_sinu <- spTransform(nlMunicipality, CRS(proj4string(NLmodis)))


# extracting January, August and annual layers with municipal data
NDVI_jan <- raster(NLmodis, 1)
NDVI_aug <- raster(NLmodis, 8)

NDVI_jan_Mun <- extract(NDVI_jan, nlMunicipality_sinu, df=TRUE,fun=mean, sp=TRUE, na.rm=TRUE)
NDVI_aug_Mun <- extract(NDVI_aug, nlMunicipality_sinu, df=TRUE,fun=mean, sp=TRUE, na.rm=TRUE)
NDVI_annual <- extract(NLmodis, nlMunicipality_sinu, df=TRUE,fun=mean, sp=TRUE, na.rm=TRUE)


# finding municipality with highest NDVI in January and August
jan_max <- NDVI_jan_Mun$NAME_2[which(NDVI_jan_Mun$January == max(NDVI_jan_Mun$January, na.rm=TRUE))]
aug_max <- NDVI_aug_Mun$NAME_2[which(NDVI_aug_Mun$August == max(NDVI_aug_Mun$August, na.rm=TRUE))]

# calculating annual average NDVI
	# selecting rows with monthly NDVI averages per municipality and  transforming them from a SpatialPolygonsDataframe to a regular Dataframe
month <- as.data.frame(NDVI_annual[,16:27])
	# calculating average per municipality over the year and adding it to the NDVI_annual data
NDVI_annual <- transform(NDVI_annual, Avg_year = rowMeans(month, na.rm = TRUE))
# finding municipality with highest average NDVI over the year
annual_max <- NDVI_annual$NAME_2[which(NDVI_annual$Avg_year == max(NDVI_annual$Avg_year, na.rm=TRUE))]


#plot results
	# Masking MODIS data with NL country borders
nlCountry <- getData('GADM',country='NLD', level=0)
nlCountry_sinu <- spTransform(nlCountry, CRS(proj4string(NLmodis)))
NLmask <- mask(NLmodis[[1]], nlCountry_sinu)

	# creating SpatialPolygonsDataFrame of municipalities with highest NDVI
Jan_city <- nlMunicipality_sinu[nlMunicipality_sinu$NAME_2=="Littenseradiel",]
Aug_city <- nlMunicipality_sinu[nlMunicipality_sinu$NAME_2=="Vorden",]
Year_city <- nlMunicipality_sinu[nlMunicipality_sinu$NAME_2=="Graafstroom",]

	# plotting January 
plot(NLmask,  main = 'Greenest municipality in January')
plot(Jan_city, add=TRUE)
text(Jan_city, jan_max, adj=1.2)

# plotting August 
plot(NLmask,  main = 'Greenest municipality in August')
plot(Aug_city, add=TRUE)
text(Aug_city, aug_max, adj=1.2)

# plotting Annual 
plot(NLmask,  main = 'Greenest municipality during the year')
plot(Year_city, add=TRUE)
text(Year_city, annual_max, adj=1.2)


#nnnnn <- mask(NLmask, city)
#class(jan_max)
#plot(city)


#jan_max <- NDVI_jan_Mun$NAME_2[which(NDVI_jan_Mun$January == max(NDVI_jan_Mun$January, na.rm=TRUE))]


#calculating annual average NDVI



#annual_mean <- mean(NDVI_annual$January : NDVI_annual$December)

#average <- function(x){
#	avgNDVI <- mean(NDVI_annual$January : NDVI_annual$December)
#	return(avgNDVI)
#}
#ajahds <- calc(NDVI_annual, fun=average)

#cellStats(NLmodis, mean)

#NLmodisSub <- mask(NLmodisUTM, nlCountry)
#plot(NLmodis, 1)

