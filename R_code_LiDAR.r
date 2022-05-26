# 26 maggio: recupero della lezione del 20/05 su dati LiDAR con Michele Torresani
# R code for analysing LiDAR data

library(raster)
library(RStoolbox) # Per poter usare la funzione resample, in alternativa si può usare il pacchetto rgdal
library(viridis)
library(ggplot2)

install.packages("lidR")
library(lidR)

setwd("C:/lab/dati/")

# Importo i dati relativi al 2004, zona di San Genesio (vicino Bolzano). La risoluzione è di 2.5m
# Importo il DSM del 2004, è la parte più alta degli alberi che viene colpita dal raggio. Digital Surface Model
dsm_2004 <- raster("2004Elevation_DigitalElevationModel-2.5m.tif")

# Importo il DTM del 2004, corrisponde al suolo colpito dal raggio. Digital Terrain Model
dtm_2004 <- raster("2004Elevation_DigitalTerrainModel-2.5m.tif")

# Plot per vedere intanto le due immagini
plot(dsm_2004)
plot(dtm_2004)

# Posso calcolare CHM relativo al 2004, Canopy Height Model, facendo la differenza tra DSM e DTM
chm_2004 <- dsm_2004 - dtm_2004

# Faccio il plot di CHM. Ogni colore della legenda corrisponde ad un'altezza: dal bianco de suolo fino al verde del bosco.
plot(chm_2004)

# Importo i dati relativi al 201, la zona è sempre quella di San Genesio. La risoluzione è di 0.5m
# Importo il DSM del 2013
dsm_2013 <- raster("2013Elevation_DigitalElevationModel-0.5m.tif")

# Importo il DTM del 2013
dtm_2013 <- raster("2013Elevation_DigitalTerrainModel-0.5m.tif")

# Calcolo CHM. 
chm_2013 <- dsm_2013 - dtm_2013

# Voglio fare un confronto tra CHM del 2004 e CHM del 2013.
# Facendo una semplice differenza tra 2013 e 2004 viene segnalato errore perchè hanno due risoluzioni diverse. 
# Bisogna avere la stessa risoluzione: facciamo un ricampionamento per avere la risluzione del chm_2013 uguale a quella del 2004
# In questi casi è meglio passare da una risoluzione migliore a quella peggiore tra le due. 

chm_2013_resampled <- resample(chm_2013, chm_2004)
# Dopo aver ricampionato posso calcolare la differenza tra i due CHM
difference_chm <- chm_2013_resampled - chm_2004

# Faccio un plot con ggplot della differenza tra i CHM e uso viridis
ggplot() + 
  geom_raster(difference_chm, mapping =aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis() +
  ggtitle("CHM difference San Genesio/Jenesien")
  

# Con la funzione readLAS, che legge il formato .laz, posso vedere la nube di punti da cui sono stati presi DSM e DTM.
point_cloud <- readLAS("point_cloud.laz")
plot(point_cloud)

