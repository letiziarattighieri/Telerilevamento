# 5 maggio
# R code for multivariate analysis

library(raster)
library(RStoolbox) # Contiene info per fare PCA
library(ggplot2)
library(patchwork)
setwd("C:/lab/")

# Utilizziamo le immagini usate a inizio corso
p224r63_2011 <- brick("p224r63_2011_masked.grd")

# Ogni banda ha più di 4 milioni di pixel, quindi dobbiamo fare il ricampionamento con una moving window 
# che lavora per blocchi di pixel e ne calcola il valore medio in modo da diminuire la risoluzione

p224r63_2011res <- aggregate(p224r63_2011, fact=10)

# Confrontiamo l'immagine originale con quella ricampionata
g1 <- ggRGB(p224r63_2011, 4, 3, 2)
g2 <- ggRGB(p224r63_2011res, 4, 3, 2)
g1 + g2

# Aggressive resampling
p224r63_2011res100 <- aggregate(p224r63_2011, fact=100)
g3 <- ggRGB(p224r63_2011res100, 4, 3, 2)
g1 + g2 + g3
