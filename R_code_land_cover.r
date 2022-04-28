# 22 aprile
# Land cover, variazioni dell'utilizzo del suolo in seguito ad attività antropica
# Code for generating land cover maps from satellite images

library(raster)
library(RStoolbox) # For classification
setwd("C:/lab/")

# Importiamo tutta l'immagine satellitare defor1 con la funzione brick
l92 <- brick("defor1_.jpg")
plotRGB(l92, 1, 2, 3, stretch="lin")
# La banda 1 è il rosso e tutto quello che vediamo rosso è vegetazione, 
# quindi la banda 1 corrisponde al NIR

# Exercise: import defor2 and plot both in a single window 
l06 <- brick("defor2_.jpg")
plotRGB(l06, 1, 2, 3, stretch="lin")

par(mfrow=c(2,1))
plotRGB(l92, 1, 2, 3, stretch="lin")
plotRGB(l06, 1, 2, 3, stretch="lin")

# Making a simple multiframe with ggplot2 package. 
# Pacchetto serve per la visualizzazione dei dati
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

# Ora che abbiamo associato i plot agli oggetti possiamo richiamarli e creare 
# un multiframe semplicemente sommandoli o dividendoli (p1/p2) in base alla 
# disposizione che voglio
p1
p2
# In questo modo avrò p1 affianco a p2
p1 + p2 
# Per avere p1 sopra p2
p1/p2 

# Ora classifichiamo le immagini con la funzione unsuperClass e  
# abbiamo bisogno di 2 classi
l92c <- unsuperClass(l92, nClasses=2)
plot(l92c$map)
# Classe 1: agricultural areas + water (bianco, in questo caso,
# perché i colori sono random ogni volta che vedo la mappa)
# Classe 2: forest (verde)

# Exercise: classify the Landsat image from 2006
l06c <- unsuperClass(l06, nClasses=2)
plot(l06c$map)
# Classe 1: agricultural areas + water
# Classe 2: forest

# Frequencies 
freq(l92c$map)
# classe 1: 35591 pixel (agricultural areas)
# classe 2: 305701 pixel (forest)

tot92 <- 341292
prop_forest_92 <- 305701 / tot92
perc_forest_92 <- 305701 * 100 / tot92

# Excercise: calculate the percentage of agricultural areas in 1992
prop_agr_92 <- 35591 / tot92
perc_agr_92 <- 35591 * 100 / tot92
# Oppure
perc_agr_92 <- 100 - perc_forest_92

freq(l06c$map)
# classe 1: 164028 pixel (agricultural areas)
# classe 2: 178698 pixel (forest)



# 28 aprile
# Lavoriamo sulle proporzioni delle frequenze dei pixel

library(raster)
library(ggplot2)
library(patchwork)
library(RStoolbox)
setwd("C:/lab/")

# Importiamo le due immagini di landsat
l92 <- brick("defor1_.jpg")
l06 <- brick("defor2_.jpg")

# Creiamo un plot delle immagini con ggRGB
ggRGB(l92, 1, 2, 3, stretch="lin")
ggRGB(l06, 1, 2, 3, stretch="lin")

# Associamo i plot a un oggetto e poi con patchwork creiamo multiframe
p1 <- ggRGB(l92, 1, 2, 3, stretch="lin")
p2 <- ggRGB(l06, 1, 2, 3, stretch="lin")
p1 + p2

# Stiamo calcolando la proporzione dei pixel di foresta e aree agricole per il 1992 
tot92 <- 341292
prop_forest_92 <- 305701 / tot92
perc_forest_92 <- 305701 * 100 / tot92

# Excercise: calculate the percentage of agricultural areas in 1992
prop_agr_92 <- 35591 / tot92
perc_agr_92 <- 35591 * 100 / tot92
# Oppure
perc_agr_92 <- 100 - perc_forest_92

# percent_forest_92: 89.57169
# percent_agr_92: 10.42831

# Calcoliamo le percentuali di foresta e aree agricole per il 2006 seguendo la stessa procedura
tot_06 <- 342726
perc_forest_06 <- 178698 * 100 / tot_06
perc_agr_06 <- 100 - perc_forest_06

# percent_forest_06: 52.14019
# percent_agr_06: 47.85981

# FINAL DATA
# percent_forest_92: 89.57169
# percent_agr_92: 10.42831
# percent_forest_06: 52.14019
# percent_agr_06: 47.85981

# Ora creiamo un dataframe (tabella) per confrontare i dati
# Let's build a dataframe with our data
# Columns (fields)
class <- c("Forest", "Agriculture")
percent_1992 <- c(89.57169, 10.42831)
percent_2006 <- c(52.14019, 47.85981)

multitemporal <- data.frame(class, percent_1992, percent_2006)
View(multitemporal) # Per vedere i dati in una tabella più ordinata

# Facciamo il grafico per il 1992 con i dati 
ggplot(multitemporal, aes(x=class, y=percent_1992, color=class)) + 
geom_bar(stat="identity", fill="white")

# Excercise: make the same graph for 2006
ggplot(multitemporal, aes(x=class, y=percent_2006, color=class)) + 
geom_bar(stat="identity", fill="white")

# PDF
pdf("percentages_1992.pdf")
ggplot(multitemporal, aes(x=class, y=percent_1992, color=class)) +
geom_bar(stat="identity", fill="white")
dev.off()
 
pdf("percentages_2006.pdf")
ggplot(multitemporal, aes(x=class, y=percent_2006, color=class)) +
geom_bar(stat="identity", fill="white")
dev.off()
