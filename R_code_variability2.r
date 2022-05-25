# 19 maggio
# R code variability 2 - Using PC components

library(raster)
library(RStoolbox)
library(ggplot2)
library(patchwork)
library(viridis)
setwd("C:/lab/")

# Importo l'immagine del ghiacciaio del Similaun
# La funzione brick serve per poter importare l'intero pacchetto di dati
sen <- brick("sentinel.png")
sen

# band 1 = NIR
# band 2 = Red
# band 3 = Green

# Facciamo un plot dell'immagine con ggplot
# Lo stretch è già lineare, non è necessario speficarlo con ggplot
ggRGB(sen, 1, 2, 3)

# Exercise: visualize the image such as vegetation becomes green and the soil becomes purple
ggRGB(sen, 2, 1, 3)

# Multivariate analysis: passiamo dai 3 layer a PC1 che compatta tutte le informazioni 
# In questo caso non abbiamo fatto il ricampionamento perché l'imamgine è leggera
sen_pca <- rasterPCA(sen)
sen_pca
# Ci sono tanti gruppi, nella classificazione ad es. avevamo solo la $map
# Per la PCA ci sono diverse componenti: 
# $call è la funzione che abbiamo usato
# $model è il modello che utilizziamo: facciamo la matrice di correlazione tra le bande per vedere dove far passare gli assi della PCA
# $map è la mappa finale
# attr sono gli attributi, quindi la funzione e il pacchetto che abbiamo usato

# Facciamo un summary del modello per sapere quanta variabilità spiega la PCA.
summary(sen_pca$model)
# Proportion of Variance: componente 1 spiega 67%, la 2 il 32% e la 3 il 0.3%.

# Facciamo un plot per vedere le singole bande. 
# PC1 spiega gran parte della variabilità.
plot(sen_pca$map)

# Assegnamo a ogni componente un oggetto 
pc1 <- sen_pca$map$PC1
pc2 <- sen_pca$map$PC2
pc3 <- sen_pca$map$PC3

# Con ggplot facciamo il plot delle singole componenti, associamo al plot un oggetto
g1 <- ggplot() + 
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

g2 <- ggplot() + 
geom_raster(pc2, mapping=aes(x=x, y=y, fill=PC2))

g3 <- ggplot() + 
geom_raster(pc3, mapping=aes(x=x, y=y, fill=PC3))

# Con patchwork sommiamo i plot 
g1 + g2 + g3

# Standard deviation of PC1: applichiamo il calcolo della standard deviation all'immagine della PC1 con la funzione focal
sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
sd3

# Map by ggplot the standard deviation of the first principal component
ggplot() + 
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer))

# With viridis
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation by viridis package")

# cividis
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis(option = "cividis") +
ggtitle("Standard deviation by viridis package")

# magma
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis(option = "magma") +
ggtitle("Standard deviation by viridis package")

# inferno
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis(option = "inferno") +
ggtitle("Standard deviation by viridis package")


# Images altogether: 
im1 <- ggRGB(sen, 2, 1, 3)

im2 <- ggplot() + 
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

im3 <- ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

# im1: immagine originale, l' RGB che abbiamo creato
# im2: è la componente principale su cui abbiamo calcolato la standard deviation
# im3: è la standard deviation basata sulla legenda "inferno" di viridis su una mw di 3x3
# im4: è la standard deviation basata sulla legenda "inferno" di viridis ma su una mw 5x5
# im5: è la standard deviation basata sulla legenda "inferno" di viridis ma su una mw 7x7

# Calculate heterogeneity in a 5x5 moving window
sd5 <- focal(pc1, matrix(1/25, 5, 5), fun=sd)
sd5

im4 <- ggplot() +
geom_raster(sd5, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im3 + im4 

# Calculate heterogeneity in a 7x7 moving window
sd7 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)
sd7

im5 <- ggplot() +
geom_raster(sd7, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im3 + im4 + im5 

