# 29 aprile
# Misurare la variabilità nello spazio

library(raster)
library(RStoolbox) # for image viewing and variability calculation
library(ggplot2) # for ggplot plotting
library(patchwork)
library(viridis)
setwd("C:/lab/")

# Excercise: import the Similaun Glacier image
sent <- brick("sentinel.png")

# Exercise: plot the image by the ggRGB function
ggRGB(sent, 1, 2, 3, stretch="lin")
# Con ggRGB lo stretch non è obbligatorio, invece va messo per forza con plotRGB

# Mettiamo l'infrarosso nella componente G
ggRGB(sent, 2, 1, 3)

# Exercise: plot the two graphs one beside the other. Possibile grazie a patchwork
g1 <- ggRGB(sent, 1, 2, 3, stretch="lin")
g2 <- ggRGB(sent, 2, 1, 3, stretch="lin")
g1+g2

# Calculation of variability over NIR
nir <- sent[[1]]

sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)

plot(sd3, col=clsd)

# Ora plottiamo la stessa immagine con ggplot
ggplot() +
geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) 

# With viridis
ggplot() +
geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation by viridis")

# Per cambiare la legenda inserisco l'argomento nella funzione di viridis
ggplot() +
geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option = "cividis") + 
ggtitle("Standard deviation by viridis")

ggplot() +
geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option = "magma") + 
ggtitle("Standard deviation by viridis")

# Exercise: make the same calculation with a 7x7 window
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)



