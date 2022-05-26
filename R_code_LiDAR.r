# 26 maggio: recupero della lezione del 20/05 su dati LiDAR con Michele Torresani
# R code for analysing LiDAR data

library(raster)
library(RStoolbox)
library(viridis)
library(ggplot2)

install.packages("lidR")
library(lidR)

setwd("C:/lab/")

dsm_2004 <- raster("2004Elevation_DigitalElevationModel-2.5m.tif")

dtm_2004 <- raster("2004Elevation_DigitalTerrainModel-2.5m.tif")

# Plot per vedere intanto le due immagini
plot(dsm_2004)
plot(dtm_2004)

chm_2004 <- dsm_2004 - dtm_2004

plot(chm_2004)

dsm_2013 <- raster("2013Elevation_DigitalElevationModel-0.5m.tif")

dtm_2013 <- raster("2013Elevation_DigitalTerrainModel-0.5m.tif")

chm_2013 <- dsm_2013 - dtm_2013

# Dà errore perchè hanno due risoluzioni diverse. Bisogna avere la stessa risoluzione:
# Facciamo un ricampionamento per avere la risluzione del chm_2013 uguale a quella del 2004
chm_2013_resampled <- resample(chm_2013, chm_2004)
difference_chm <- chm_2013_resampled - chm_2004

ggplot() + 
  geom_raster(difference_chm, mapping =aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis() +
  ggtitle("CHM difference San Genesio/Jenesien")
  
point_cloud <- readLAS("point_cloud.laz")
plot(point_cloud)

