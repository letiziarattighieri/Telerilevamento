# 3 giugno 
# SDM = Species Distribution Modelling
# R code for species distribution modelling

library(raster) # predictors
library(sdm)
library(rgdal) # species

# Non abbiamo fatto il setwd perchè usiamo un file di sistema che viene dal pacchetto sdm
file <- system.file("external/species.shp", package="sdm")

species <- shapefile(file)

plot(species, pch=19)

occ <- species$Occurrence

plot(species[occ == 1, ], col="blue", pch=19)
points(species[occ == 0, ], col="red", pch=19)
# points per evitare sovrascrizione e per aggiungere le assenze al plot delle presenze

# Predittori
path <- system.file("external", package="sdm")

# Facciamo la lista dei predittori, in questo caso sono 4 (vegetation è NDVI)
lst <- list.files(path=path, pattern='asc', full.names=T)
# full.name is needed in case you want to mantain the 

preds <- stack(lst)
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

# Plottiamo i predittori singolarmente e la presenza
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

plot(elev, col=cl)
points(species[occ == 1, ], pch=19)

plot(prec, col=cl)
points(species[occ == 1, ], pch=19)

plot(temp, col=cl)
points(species[occ == 1, ], pch=19)

plot(vege, col=cl)
points(species[occ == 1, ], pch=19)

# Facciamo il modello usando funzioni presenti nel pacchetto sdm
datasdm <- sdmData(train=species, predictors=preds) # Funzione per richiamare i dati

m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods="glm")

# Facciamo la previsione con la funzione predict
p1 <- predict(m1, newdata=preds)

plot(p1, col=cl)
points(species[occ == 1, ], pch=19) # Inseriamo anche le presenze per verificare

par(mfrow=c(2,3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(prec, col=cl)
plot(temp, col=cl)
plot(vege, col=cl)

# Alternativa per il plot finale per evitare di usare il multiframe
final <- stack(preds, p1)
plot(final, col=cl)

