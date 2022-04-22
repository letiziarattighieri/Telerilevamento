# 22 aprile
# Land cover, variazioni dell'utilizzo del suolo in seguito ad attività antropica
# Code for generating land cover maps from satellite images

library(raster)
library(RStoolbox) # For classification
setwd("C:/lab/")

# Importiamo tutta l'immagine satellitare defor1 con la funzione brick
l92 <- brick("defor1_.jpg")
plotRGB(l92, 1, 2, 3, stretch="lin")
# La banda 1 è il rosso e tutto quello che vediamo rosso è vegetazione, quindi la banda 1 corrisponde al NIR

# Exercise: import defor2 and plot both in a single window 
l06 <- brick("defor2_.jpg")
plotRGB(l06, 1, 2, 3, stretch="lin")

par(mfrow=c(2,1))
plotRGB(l92, 1, 2, 3, stretch="lin")
plotRGB(l06, 1, 2, 3, stretch="lin")

# Making a simple multiframe with ggplot2 package. Pacchetto serve per la visualizzazione dei dati
install.packages("ggplot2")
library(ggplot2)

# ggRGB permette di plottare le immagini RGB sempre usando lo stesso codice
ggRGB(l92, 1, 2, 3, stretch="lin")
ggRGB(l06, 1, 2, 3, stretch="lin")

# Scarichiamo il pacchetto patchwork per poter assegnare ogni plot a un oggetto
install.packages("patchwork")
library(patchwork)

p1 <- ggRGB(l92, 1, 2, 3, stretch="lin")
p2 <- ggRGB(l06, 1, 2, 3, stretch="lin")

# Ora che abbiamo associato i plot agli oggetti possiamo richiamarli e creare un multiframe semplicemente sommandoli o dividendoli (p1/p2) in base alla disposizione che voglio
p1
p2
# In questo modo avrò p1 affianco a p2
p1 + p2 
# Per avere p1 sopra p2
p1/p2 

# Ora classifichiamo le immagini con la funzione unsuperClass e abbiamo bisogno di 2 classi
l92c <- unsuperClass(l92, nClasses=2)
plot(l92c$map)
# Classe 1: agricultural areas + water (bianco, in questo caso, perché i colori sono random ogni volta che vedo la mappa)
# Classe 2: forest (verde)

# Exercise: classify the Landsat image from 2006
l06c <- unsuperClass(l06, nClasses=2)
plot(l06c$map)
# Classe 1: agricultural areas + water
# Classe 2: forest

# Frequencies 
freq(l92c$map)
# classe 1: 35591 pixel di uso agricolo
# classe 2: 305701 pixel di foresta

freq(l06c$map)
# classe 1: 164028 pixel di uso agricolo
# classe 2: 178698 pixel di foresta

