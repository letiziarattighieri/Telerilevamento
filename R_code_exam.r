# Analisi e confronto di due immagini landsat della stessa località (p233r089): una acquisita nel 2013 e l'altra nel 2021 
# Le aree interessate comprendono Purto Montt, il Lago Llanquihue e il Parque Nacional Alerce Andino (Cile)

# https://www.usgs.gov/faqs/what-are-best-landsat-spectral-bands-use-my-research 
# Sito da cui ho scaricato le immagini satellitari con spiegazione di ogni banda (Landsat 8/9 Operational Land Image (OLI) and Thermal Infrared Sensor (TIRS)) 
# In questo caso:
  # B2 = blue
  # B3 = green
  # B4 = red
  # B5 = NIR

# Le immagini sono a 16 bit 

library(raster)
library(RStoolbox) # For classification
library(ggplot2)
library(patchwork)
library(viridis)

setwd("C:/lab/chile_exam/")


                                              ###### IMPORTAZIONE DATI ######

                                                          # 2013
# Importo le bande relative dell'immagine del 2013 facendo una lista perché sono 8 bande separate
# Devo importare le prime 7 bande e la banda 10 che però ha un nome diverso: 
# quindi, per evitare di importarle singolarmente creo una lista per importare le prime  7 bande 
list_2013 <- list.files(pattern="2013_SR_B")

# Ora che ho la lista applico, con funzione lapply, la funzione raster per importare tutto
import_2013 <- lapply(list_2013, raster)

# Prima di mettere insieme tutti i layer con la funzione stack devo importare la banda 10:
b10_2013 <- raster("p233r089_2013_ST_B10.tif")

# Ora che ho caricato tutte le 8 bande posso procedere con lo stack: 
chile_2013 <- stack(c(import_2013, b10_2013))
chile_2013
plot(chile_2013)

# Ricampiono l'immagine perché le dimensioni rallentano il sistema (ncell almost 60 million)
c2013_res <- aggregate(chile_2013, fact=10)
c2013_res
plot(c2013_res)
plotRGB(c2013_res, 5, 4, 3, stretch="lin")

# Provo a fare un ggplot: in questo caso ho specificato lo stretch perché altrimenti i plot di ritorno erano troppo scuri
g1_2013 <- ggRGB(c2013_res, 5, 4, 3, stretch="lin") # NIR in R, red in G, green in B
g2_2013 <- ggRGB(c2013_res, 4, 5, 3, stretch="lin") # red in R, NIR in G, green in B
g1_2013 + g2_2013
                                                          # 2021
# Faccio lo stesso procedimento per importare i dati relativi all'immagine del 2021
list_2021 <- list.files(pattern="2021_SR_B")

import_2021 <- lapply(list_2021, raster)

b10_2021 <- raster("p233r089_2021_ST_B10.tif")

chile_2021 <- stack(c(import_2021, b10_2021))
chile_2021
plot(chile_2021)

# Ricampiono l'immagine (ncell exceeding 63 million)
c2021_res <- aggregate(chile_2021, fact=10)
c2021_res
plot(c2021_res)
plotRGB(c2021_res, 5, 4, 3, stretch="lin")

g1_2021 <- ggRGB(c2021_res, 5, 4, 3, stretch="lin") # NIR in R, red in G, green in B
g2_2021 <- ggRGB(c2021_res, 4, 5, 3, stretch="lin") # red in R, NIR in G, green in B

# Metto a confronto il plot del 2013 e quello del 2021
g1_2013 + g1_2021 # Vegetazione è rossa
g2_2013 + g2_2021 # Vegetazione è verde

# Oppure, per avere tutti e 4 i plot insieme:
(g1_2013 + g1_2021) / (g2_2013 + g2_2021)


                                              ###### INDICI SPETTRALI ######

# Calcolo DVI, calcolo prima Difference Vegetation Index perché le due immagini hanno la stessa risoluzione
# Riflettanza NIR - Riflettanza RED

# 2013
dvi_2013 = c2013_res[[5]] - c2013_res[[4]]
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi_2013, col=cl)

# 2021
dvi_2021 = c2021_res[[5]] - c2021_res[[4]]
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi_2021, col=cl)

# Differenza 2013 - 2021
dvi_dif = dvi_2013 - dvi_2021
cld <- colorRampPalette(c("blue", "white", "red")) (100)
plot(dvi_dif, col=cld) 
# Le zone rosse corrispondono alle zone fortemente soggette a deforestazione, alta variazione della salute delle piante.

# Calcolo NDVI: (riflettanza NIR - riflettanza RED) / (riflettanza NIR + riflettanza RED)
# 2013
ndvi_2013 = dvi_2013 / (c2013_res[[5]] + c2013_res[[4]])
plot(ndvi_2013, col=cl)

#2021
ndvi_2021 = dvi_2021 / (c2021_res[[5]] + c2021_res[[4]])
plot(ndvi_2021, col=cl)

# Confronto tra i due NDVI
par(mfrow=c(1, 2))
plot(ndvi_2013, col=cl)
plot(ndvi_2021, col=cl)


                                              ###### CLASSIFICAZIONE ######
# 2013
c2013_class <- unsuperClass(c2013_res, nClasses=3) # Volevo mettere 4 classi (suolo nudo, vegetazione, ghiaccio, aacqua) ma non si vedono bene
cl <- colorRampPalette(c("yellow", "black", "red"))(100)
plot(c2013_class$map, col=cl)

# 2021
c2021_class <- unsuperClass(c2021_res, nClasses=3) # Volevo mettere 4 classi (suolo nudo, vegetazione, ghiaccio, aacqua) ma non si vedono bene
cl <- colorRampPalette(c("yellow", "black", "red"))(100)
plot(c2021_class$map, col=cl)

# Confronto le due immagini
par(mfrow=c(2, 2))
plot(c2013_class$map, col=cl)
plot(c2021_class$map, col=cl)
plotRGB(c2013_res, 5, 4, 3, stretch="lin")
plotRGB(c2021_res, 5, 4, 3, stretch="lin")



                                              ###### VARIABILITA' ######

nir_2013 <- c2013_res[[5]]

sd3_2013 <- focal(nir_2013, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)

plot(sd3_2013, col=clsd)


g1 <- ggplot() +
geom_raster(sd3_2013, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation by viridis")



nir_2021 <- c2021_res[[5]]

sd3_2021 <- focal(nir_2021, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)

plot(sd3_2021, col=clsd)


g2 <- ggplot() +
geom_raster(sd3_2021, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation by viridis")



                                              ###### ANALISI MULTIVARIATA ######

c2013_pca <- rasterPCA(c2013_res)
c2013_pca 
summary(c2013_pca$model)
# La prima componente spiega l'83,8%
pc1 <- c2013_pca$map$PC1
pc2 <- c2013_pca$map$PC2
pc3 <- c2013_pca$map$PC3

g1_pca <- ggplot() + 
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

g2_pca <- ggplot() + 
geom_raster(pc2, mapping=aes(x=x, y=y, fill=PC2))

g3_pca <- ggplot() + 
geom_raster(pc3, mapping=aes(x=x, y=y, fill=PC3))

g1_pca + g2_pca + g3_pca

sd3_pca <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
sd3_pca

ggplot() + 
geom_raster(sd3_pca, mapping=aes(x=x, y=y, fill=layer))


ggplot() + 
geom_raster(sd3_pca, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation by viridis package")
