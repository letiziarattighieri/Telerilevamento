# Questo è il primo script che useremo a lezione

#install.packages("raster")
library(raster)

#settaggio cartella di lavoro
setwd("C:/lab/")

#importiamo dati
l2011 <- brick("p224r63_2011.grd")
l2011

#per vedere l'immagine, la plottiamo con funzione plot
plot(l2011)

#cambiamo il colore della legenda. Il 100 indica il numero di colori intermedi tra i 3 che ho inserito nella nuova legenda
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)

#dopo aver cambiato il colore della legenda proseguo plottando le nuove immagini
plot(l2011, col=cl)

