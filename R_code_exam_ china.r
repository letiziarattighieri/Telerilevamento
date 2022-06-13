# Analisi e confronto di due immagini landsat della stessa località (p130r038): 
# una acquisita nel 2013 e l'altra nel 2021, entrambe nel mese di dicembre 
# Le aree interessate comprendono la parte più occidentale della città di Chengdu (17 milioni di abitanti) e parte dell'altopiano tibetano

# https://www.usgs.gov/faqs/what-are-best-landsat-spectral-bands-use-my-research 
# Sito da cui ho scaricato le immagini satellitari con spiegazione di ogni banda (Landsat 8/9 Operational Land Image (OLI) and Thermal Infrared Sensor (TIRS)) 
# In questo caso:
  # B2 = blue
  # B3 = green
  # B4 = red
  # B5 = NIR

# Le immagini sono a 16 bit 

library(raster)
library(RStoolbox) # Per visualizzare le immagini e calcoli
library(ggplot2) # Per i plot ggplot
library(patchwork) # Per creare multiframe con ggplot
library(viridis) 

setwd("C:/lab/china_exam/")


                                              ###### IMPORTAZIONE DATI ######

# 2013
# Importo le bande relative dell'immagine del 2013 facendo una lista perché ho scaricato le 7 bande separatamente; 
# quindi, per evitare di importarle singolarmente, creo una lista con funzione list.files
list_2013 <- list.files(pattern="2013_SR_B")

# Ora che ho la lista applico, con funzione lapply, la funzione raster per importare tutto
import_2013 <- lapply(list_2013, raster)

# Ora che ho importato le 7 bande posso procedere con lo stack (creo un blocco comune con tutti i dati che ho importato): 
china_2013 <- stack(import_2013)
china_2013

# Faccio un plot delle bande che ho importato e unito con lo stack
plot(china_2013)

# Per vedere l'immagine con schema RGB creo un plotRGB con:
# banda NIR nella componente R, banda R in componente G, banda G in componente B
plotRGB(china_2013, 5, 4, 3, stretch="lin")

# In questo plot sono evidenti i ghiacciai, la vegetazione che appare rossa e le strade:
# particolarmente evidente la città di Chengdu in basso a destra

# Ricampiono l'immagine perché le dimensioni rallentano il sistema (ncell: more than 61 million)
c2013_res <- aggregate(china_2013, fact=10)
c2013_res

# Rifaccio il plot delle bande e il plotRGB per verificare che il ricampionamento sia andato a buon fine
plot(c2013_res)
plotRGB(c2013_res, 5, 4, 3, stretch="lin")

# Provo a fare un ggplot: in questo caso ho specificato lo stretch perché altrimenti i plot di ritorno sono troppo scuri
g1_2013 <- ggRGB(c2013_res, 5, 4, 3, stretch="lin") # NIR in R, red in G, green in B
g2_2013 <- ggRGB(c2013_res, 4, 5, 3, stretch="lin") # red in R, NIR in G, green in B

g1_2013 + g2_2013
# Userò solo il ggplot con NIR in RED perché quando è in GREEN non si distingue il suolo nudo


# 2021
# Faccio lo stesso procedimento per importare i dati relativi all'immagine del 2021
list_2021 <- list.files(pattern="2021_SR_B")

import_2021 <- lapply(list_2021, raster)

china_2021 <- stack(import_2021)
china_2021

plot(china_2021)

plotRGB(china_2013, 5, 4, 3, stretch="lin")

# Ricampiono l'immagine (ncell: almost 61 million)
c2021_res <- aggregate(china_2021, fact=10)
c2021_res

plot(c2021_res)

plotRGB(c2021_res, 5, 4, 3, stretch="lin")

g1_2021 <- ggRGB(c2021_res, 5, 4, 3, stretch="lin") # NIR in R, red in G, green in B
g2_2021 <- ggRGB(c2021_res, 4, 5, 3, stretch="lin") # red in R, NIR in G, green in B
# Per lo stesso motivo userò solo il ggplot con NIR in RED

# Metto a confronto il plot del 2013 e quello del 2021
g1_2013 + g1_2021 # Vegetazione è rossa



                                              ###### INDICI SPETTRALI ######

# Calcolo DVI, calcolo prima Difference Vegetation Index perché le due immagini hanno la stessa risoluzione
# Riflettanza NIR - Riflettanza RED

# 2013
dvi_2013 = c2013_res[[5]] - c2013_res[[4]]
dvi_2013 # values: -7619.07, 13533.58  (min, max)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi_2013, col=cl)
# Tutto quello che è giallo dovrebbe essere suolo nudo


# 2021
dvi_2021 = c2021_res[[5]] - c2021_res[[4]]
dvi_2021 # values: -9640.029, 13171.99  (min, max)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi_2021, col=cl)
# Tutto quello che è arancio dovrebbe essere suolo nudo

par(mfrow=c(1, 2))
plot(dvi_2013, col=cl)
plot(dvi_2021, col=cl)

# Differenza 2013 - 2021
dvi_dif = dvi_2013 - dvi_2021
cld <- colorRampPalette(c("blue", "white", "red")) (100)
plot(dvi_dif, col=cld) 
# Le zone rosse corrispondono alle zone soggette a deforestazione o alla scomparsa, in generale, di vegetazione


# Calcolo NDVI: (riflettanza NIR - riflettanza RED) / (riflettanza NIR + riflettanza RED)
    # Range DVI (immagine a 16 bit) : -65535 a 65535
    # Range NDVI (immagine a 16 bit) : -1 a 1

# 2013
ndvi_2013 = dvi_2013 / (c2013_res[[5]] + c2013_res[[4]])
plot(ndvi_2013, col=cl)

#2021
ndvi_2021 = dvi_2021 / (c2021_res[[5]] + c2021_res[[4]])
plot(ndvi_2021, col=cl)

# Confronto tra i due NDVI creando un multiframe
par(mfrow=c(1, 2))
plot(ndvi_2013, col=cl)
plot(ndvi_2021, col=cl)
# Particolarmente evidenti le strade che vanno da Chengdu verso la montagna, in giallo


                                              ###### CLASSIFICAZIONE ######

# Faccio la classificazione in base alla disposizione dei pixel nello spazio a 3 bande
# Ho deciso di suddividere i pixel in 4 classi: suolo nudo, vegetazione, ghiaccio

# 2013
c2013_class <- unsuperClass(c2013_res, nClasses=3)
clc <- colorRampPalette(c("yellow2", "red1", "navyblue"))(100)
plot(c2013_class$map, col=clc)
# class 1: vegetazione
# class 2: suolo nudo 
# class 3: ghiaccio

# 2021
c2021_class <- unsuperClass(c2021_res, nClasses=3) 
clc <- colorRampPalette(c("yellow2", "red1", "navyblue"))(100)
plot(c2021_class$map, col=clc)
# class 1: suolo nudo
# class 2: ghiaccio
# class 3: vegetazione

# Confronto le due immagini classificate
par(mfrow=c(1, 2))
plot(c2013_class$map, col=clc)
plot(c2021_class$map, col=clc)

# Provo a fare un confronto con le immagini classificate e il plotRGB iniziale (NIR in componente R)
par(mfrow=c(2, 2))
plot(c2013_class$map, col=clc)
plot(c2021_class$map, col=clc)
plotRGB(c2013_res, 5, 4, 3, stretch="lin")
plotRGB(c2021_res, 5, 4, 3, stretch="lin")


                                              ###### LAND COVER ######

# Voglio vedere com'è cambiato il suolo in un intervallo di 8 anni
c2013_class <- unsuperClass(c2013_res, nClasses=3)
plot(c2013_class$map, col=clc)

c2021_class <- unsuperClass(c2021_res, nClasses=3)
plot(c2021_class$map, col=clc)
 

# Frequenze 
freq(c2013_class$map)
# value  count
# classe 1: 212623
# classe 2: 169255
# classe 3:  23779
#       NA: 205818

freq(c2021_class$map)
#value  count
# classe 1:  41861
# classe 2:  18286
# classe 3: 345431
#       NA: 205122

#TIME SERIES 
#Faccio la differenza tra la banda NIR del 2021 e quella del 2013
dif <- c2021_res[[5]] - c2013_res[[5]]
dif
cldif <- colorRampPalette(c("blue", "white", "red"))(100)
plot(dif, col=cldif)

# In blu scuro si vede il ghiaccio presente nel 2013 ma mancante nel 2021, al contrario, in rosso, si vede il ghiaccio presente nel 2021 e che mancava nel 2013





                                              ###### VARIABILITA' ######

# Calcolo la variabilità su NIR (banda 5)
# 2013 
nir_2013 <- c2013_res[[5]]

sd3_2013 <- focal(nir_2013, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)

plot(sd3_2013, col=clsd)


g1 <- ggplot() +
geom_raster(sd3_2013, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation by viridis")
# Massima variabilità al limite tra ghiaccio e suolo (in giallo)

#2021
nir_2021 <- c2021_res[[5]]

sd3_2021 <- focal(nir_2021, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)

plot(sd3_2021, col=clsd)


g2 <- ggplot() +
geom_raster(sd3_2021, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation by viridis")
# Massima variabilità al limite tra ghiaccio e suolo (giallo)

g1 + g2 
# Si riesce ad apprezzare abbastanza bene la differenza tra le due immagini sebbene abbia usato le immagini ricampionate,
# specialmente nelle zone in cui la variabilità è maggiore, quindi in corrispondenza del ghiaccio e dei crepacci
# Se si presta abbastanza attenzione si riescono a intravedere anche le strade che portano da Chengdu alle montagne



                                              ###### ANALISI MULTIVARIATA ######

c2013_pca <- rasterPCA(c2013_res)
c2013_pca 
summary(c2013_pca$model)
# La prima componente spiega l'85.3%
plot(c2013_pca$map)

pc1_2013 <- c2013_pca$map$PC1
pc2_2013 <- c2013_pca$map$PC2
pc3_2013 <- c2013_pca$map$PC3

pc1 <- c2013_pca$map$PC1
pc5_2013 <- c2013_pca$map$PC5
pc7_2013 <- c2013_pca$map$PC7

g1_pca_2013 <- ggplot() + 
geom_raster(pc1_2013, mapping=aes(x=x, y=y, fill=PC1))

g2_pca_2013 <- ggplot() + 
geom_raster(pc2_2013, mapping=aes(x=x, y=y, fill=PC2))

g3_pca_2013 <- ggplot() + 
geom_raster(pc3_2013, mapping=aes(x=x, y=y, fill=PC3))

g1_pca_2013 + g2_pca_2013 + g3_pca_2013


sd_2013 <- focal(pc1_2013, matrix(1/9, 3, 3), fun=sd)

ggplot() + 
geom_raster(sd_2013, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation by viridis package")

g1_2013 <- ggRGB(c2013_res, 5, 4, 3, stretch="lin")

im2 <- ggplot() + 
geom_raster(pc1_2013, mapping=aes(x=x, y=y, fill=PC1))

im3 <- ggplot() +
geom_raster(sd_2013, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

g1_2013 + im2 + im3










sd3_pca <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
sd3_pca

ggplot() + 
geom_raster(sd3_pca, mapping=aes(x=x, y=y, fill=layer))


ggplot() + 
geom_raster(sd3_pca, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation by viridis package")
