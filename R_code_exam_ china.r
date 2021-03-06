                                              ###### ESAME 22 GIUGNO 2022 ######
# Analisi e confronto di due immagini landsat della stessa località (p130r038): Provincia di Sichuan, Cina 
# una acquisita nel 2013 e l'altra nel 2021, entrambe nel mese di dicembre 
# Le aree interessate comprendono la parte più occidentale della città di Chengdu (17 milioni di abitanti) parte dell'altopiano tibetano 

# https://www.usgs.gov/faqs/what-are-best-landsat-spectral-bands-use-my-research 
# Sito da cui ho scaricato le immagini satellitari con spiegazione di ogni banda (Landsat 8/9 Operational Land Image (OLI) and Thermal Infrared Sensor (TIRS)) 

  # B2 = blue
  # B3 = green
  # B4 = red
  # B5 = NIR

# Le immagini sono a 16 bit 
# Risoluzione 30 m

library(raster)
library(RStoolbox) # Per visualizzare le immagini e calcoli
library(ggplot2) # Per i plot ggplot
library(patchwork) # Per creare multiframe con ggplot
library(viridis) 

setwd("C:/lab/china_exam/")


                                              ###### IMPORTAZIONE DATI ######

# Importo prima i dati del 2021 perché ho dovuto ricampionare l'immagine del 2013 abbassando la qualità per renderla uguale a 2021
# 2021
# Importo le bande creando prima una lista con la funzione list.files perché ho scaricato le 7 bande separatamente; 
list_2021 <- list.files(pattern="2021_SR_B")

# Ora che ho la lista applico, con funzione lapply, la funzione raster per importare tutto
import_2021 <- lapply(list_2021, raster)

# Ora che ho importato le 7 bande posso procedere con lo stack (creo un blocco comune con tutti i dati che ho importato): 
china_2021 <- stack(import_2021)

# Ricampiono l'immagine con funzione aggregate perché immagine pesa troppo
c2021 <- aggregate(china_2021, fact=10)

# Plot normale per vedere le bande
plot(c2021)

# Faccio un plot con la banda R nella componente R, banda G in G e banda B in B er vedere l'immagine con i colori naturali
# in questo caso ho specificato lo stretch perché altrimenti i plot di ritorno sono troppo scuri
c2021_norm <- ggRGB(c2021, 4, 3, 2, stretch="lin") + 
              ggtitle("Provincia del Sichuan nel 2021")

# Faccio ggplot con immagine ricampionata
# NIR in R, red in G, green in B
g1_2021 <- ggRGB(c2021, 5, 4, 3, stretch="lin") + 
           ggtitle("ggplot 2021") 

# Userò solo il ggplot con NIR in RED perché quando è in GREEN non si distingue il suolo nudo
# In questo plot sono evidenti i ghiacciai, la vegetazione che appare rossa e le strade:
# particolarmente evidente la città di Chengdu in basso a destra


# 2013
# Importo le bande facendo una lista perché ho scaricato le 7 bande separatamente; 
list_2013 <- list.files(pattern="2013_SR_B")

# Ora che ho la lista applico, con funzione lapply, la funzione raster per importare tutto
import_2013 <- lapply(list_2013, raster)

# Ora che ho importato le 7 bande posso procedere con lo stack (creo un blocco comune con tutti i dati che ho importato): 
china_2013 <- stack(import_2013)

# Ricampiono l'immagine perché ha dimensioni diverse da quella del 2021:
china_2013_res <- resample(china_2013, china_2021)

# Con la funzione aggregate ricampiono nuovamente l'immagine perché ha quasi 61 milioni di pixel:
c2013 <- aggregate(china_2013_res, fact=10)

# Faccio un plot normale per vedere le bande che ho importato
plot(c2013)

# Faccio un plot con la banda R nella componente R, banda G in G e banda B in B er vedere l'immagine con i colori reali                                                           
c2013_norm <- ggRGB(c2013, 4, 3, 2, stretch="lin") +            
              ggtitle("Provincia del Sichuan nel 2013")                       

# Provo a fare un ggplot con la banda NIR in R, banda R in G e banda g in B
g1_2013 <- ggRGB(c2013, 5, 4, 3, stretch="lin") + 
           ggtitle("ggplot 2013") 

# Metto a confronto il plot del 2013 e quello del 2021
g1_2013 + g1_2021 # Vegetazione è rossa



                                              ###### INDICI SPETTRALI ######

# Parto con il calcolo degli indici spettrali per vedere le condizioni della vegetazione.
# Le foglie assorbono il rosso e riflettono NIR, se la pianta va in sofferenza riflette meno NIR e assorbe meno rosso: 
# Calcolo DVI, calcolo Difference Vegetation Index perché le due immagini hanno la stessa risoluzione
# DVI = Riflettanza NIR - Riflettanza RED

# 2013
dvi_2013 = c2013[[5]] - c2013[[4]]
dvi_2013 # values: -7619.07, 13533.58  (min, max)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)

plot(dvi_2013, col=cl) +
title(main = "DVI 2013")
# Tutto quello che è giallo dovrebbe essere suolo nudo, si vedono bene le strade

# 2021
dvi_2021 = c2021[[5]] - c2021[[4]]
dvi_2021 # values: -9640.029, 13171.99  (min, max)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)

plot(dvi_2021, col=cl) +
title(main = "DVI 2021")
# Tutto quello che è arancio dovrebbe essere suolo nudo, anche qua si vedono bene le strade

par(mfrow=c(1, 2))
plot(dvi_2013, col=cl) +
title(main = "DVI 2013")
plot(dvi_2021, col=cl) +
title(main = "DVI 2021")

# Differenza 2013 - 2021
dvi_dif = dvi_2013 - dvi_2021
cld <- colorRampPalette(c("blue", "white", "red")) (100)

plot(dvi_dif, col=cld) +
title(main = "DVI 2013 - DVI 2021")
# Le zone rosse corrispondono alle zone soggette a deforestazione o alla scomparsa, in generale, di vegetazione


# Calcolo NDVI: (riflettanza NIR - riflettanza RED) / (riflettanza NIR + riflettanza RED)
    # Range DVI (immagine a 16 bit) : -65535 a 65535
    # Range NDVI (immagine a 16 bit) : -1 a 1

# 2013                                                               
ndvi_2013 = (c2013[[5]] - c2013[[4]]) / (c2013[[5]] + c2013[[4]])    
plot(ndvi_2013, col=cl) +                                            
title(main = "NDVI 2013")                                            

#2021
ndvi_2021 = (c2021[[5]] - c2021[[4]]) / (c2021[[5]] + c2021[[4]])
plot(ndvi_2021, col=cl) +
title(main = "NDVI 2021")

# Confronto tra i due NDVI creando un multiframe

par(mfrow=c(1, 2))
plot(ndvi_2013, col=cl) +
title(main = "NDVI 2013")
plot(ndvi_2021, col=cl) +
title(main = "NDVI 2021")
# Particolarmente evidenti le strade che vanno da Chengdu verso la montagna, in giallo

# Valori <0.1: suolo nudo
#         0.1 - 0.2: copertura vegetale quasi assente
#         0.2 - 0.3: copertura vegetale molto bassa 
#         0.3 - 0.4: copertura vegetale bassa con vigoria bassa o copertura vegetale molto bassa con vigoria alta


                                              ###### LAND COVER ######

# Voglio vedere com'è cambiato l'utilizzo del suolo in un intervallo di 8 anni
# Faccio la classificazione in base alla disposizione dei pixel nello spazio a 3 bande
# Suddivido i pixel in 4 classi: suolo nudo, vegetazione, neve e transizione tra neve e suolo
# E' stato necessario suddividere in 4 classi perché provando con 3 veniva a mancare una parte consistende del suolo nudo nel plot 2021

# 2013
c2013_class <- unsuperClass(c2013, nClasses=4)
clc <- colorRampPalette(c("yellow", "red", "blue", "black"))(100)
plot(c2013_class$map, col=clc) +
title(main = "2013 classes")

# 2021
c2021_class <- unsuperClass(c2021, nClasses=4)
clc <- colorRampPalette(c("yellow", "red", "blue", "black"))(100)
plot(c2021_class$map, col=clc) +
title(main = "2021 classes")
 
# Confronto le due immagini classificate
par(mfrow=c(1, 2))
plot(c2013_class$map, col=clc)
plot(c2021_class$map, col=clc)

# Frequenze 
freq(c2013_class$map)
# value     count
# classe 1: 11668 (neve)
# classe 2: 25442 (zona transizione suolo-neve)
# classe 3: 188305 (suolo)
# classe 4: 180225 (vegetazione)
#       NA: 205060 (suppongo i pixel bianchi dovuti all'inclinazione dell'immagine satellitare, per questo non li considero nei calcoli)

tot2013 <- 405640
perc_snow_2013 <- 11668 * 100 / tot2013   # 2.876442 %
perc_tran_2013 <- 25442 * 100 / tot2013   # 6.272064 %
perc_soil_2013 <- 188305 * 100 / tot2013  # 46.4217 %
perc_vege_2013 <- 180225 * 100 / tot2013  # 44.42979 %

freq(c2021_class$map)
#value      count
# classe 1: 14513 (neve)
# classe 2: 31836 (zona transizione suolo-neve)
# classe 3: 194896 (suolo)
# classe 4: 164333 (vegetazione) 
#       NA: 205122 (suppongo i pixel bianchi dovuti all'inclinazione dell'immagine satellitare, per questo non li considero nei calcoli)

tot2021 <- 405578
perc_snow_2021 <- 14513 * 100 / tot2021   # 3.57835 %
perc_tran_2021 <- 31836 * 100 / tot2021   # 7.849538 %
perc_soil_2021 <- 194896 * 100 / tot2021  # 48.05389 %
perc_vege_2021 <- 164333 * 100 / tot2021  # 40.51822 %


# Creo un dataframe per confrontare i dati 
# Parto creando le colonne
class <- c("Neve", "Transizione", "Suolo", "Vegetazione")
percent_2013 <- c(2.876442, 6.272064, 46.4217, 44.42979)
percent_2021 <- c(3.57835, 7.849538, 48.05389, 40.51822)

# Per visualizzare il dataframe uso la funzione data.frame e poi con la funzione View visualizzo la tabella in modo più ordinato
multitemporal <- data.frame(class, percent_2013, percent_2021)
View(multitemporal)

# Salvo il dataframe come file csv con funzione write.csv, lo apro da excel e poi lo salvo come immagine da inserire nella presentazione
# write.csv(multitemporal, file = "multitemporal.csv")

# Creo l'istogramma prima con i dati del 2013 e poi con quelli del 2021 
perc_2013 <- ggplot(multitemporal, aes(x=class, y=percent_2013, color=class)) + 
geom_bar(stat="identity", fill="white") +
ggtitle("2013 percentages")

perc_2021 <- ggplot(multitemporal, aes(x=class, y=percent_2021, color=class)) + 
geom_bar(stat="identity", fill="white") +
ggtitle("2021 percentages")



                                              ###### VARIABILITA' ######
# Non ho inserito questa parte nella presentazione su LaTeX perché lì ho calcolato la variabilità dopo aver fatto l'analisi multivariata,
# qui ho fatto un tentativo facendo i calcoli sulla banda NIR

# Voglio calcolare la variabilità nello spazio
# Scelgo come variabile la banda NIR (band_5), in questo caso calcolo la deviazione standard

# 2013 
nir_2013 <- c2013[[5]]

# Con la funzione focal faccio passare una moving window di 3 x 3 che calcola la deviazione standard di ogni pixel
sd3_2013 <- focal(nir_2013, matrix(1/9, 3, 3), fun=sd)

# Per una visualizzazione immediata della variabilità uso viridis

g1 <- ggplot() +
geom_raster(sd3_2013, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation over NIR by viridis - 2013")

# Bassa variabilità dove c'è roccia compatta e vegetazione 
# Massima variabilità al limite tra ghiaccio e suolo e tra crepacci

# 2021 : seguo lo stesso procedimento
nir_2021 <- c2021[[5]]

sd3_2021 <- focal(nir_2021, matrix(1/9, 3, 3), fun=sd)

g2 <- ggplot() +
geom_raster(sd3_2021, mapping = aes(x=x, y=y, fill=layer)) +
scale_fill_viridis() + 
ggtitle("Standard deviation over NIR by viridis - 2021")

# Bassa variabilità dove c'è roccia compatta e vegetazione 
# Massima variabilità al limite tra ghiaccio e suolo e tra crepacci

g1 + g2 
# Si riesce ad apprezzare abbastanza bene la differenza tra le due immagini sebbene abbia usato le immagini ricampionate,
# specialmente nelle zone in cui la variabilità è maggiore, quindi in corrispondenza del ghiaccio e dei crepacci
# Se si presta abbastanza attenzione si riescono a intravedere anche le strade che portano da Chengdu alle montagne



                                              ###### ANALISI MULTIVARIATA ######

# Invece di scegliere una sola variabile posso compattare tutti i dati in un sistema più semplice 
# Inizio con l'analisi multivariata

# 2013
c2013_pca <- rasterPCA(c2013)

# Faccio il summary del modello per vedere quanta variabilità spiega ogni componente
summary(c2013_pca$model)
# Proportion of Variance: PC1 spiega 85.3%, PC2 spiega 13.2%, PC3 spiega 1.3%
# Faccio un plot con tutte le componenti
plot(c2013_pca$map)

# Assegno oggetto alle prime 3 componenti
pc1_2013 <- c2013_pca$map$PC1
pc2_2013 <- c2013_pca$map$PC2
pc3_2013 <- c2013_pca$map$PC3

# Con ggplot faccio il plot delle singole componenti, associo al plot un oggetto
# PC1
gpc1_2013 <- ggplot() + 
geom_raster(pc1_2013, mapping=aes(x=x, y=y, fill=PC1)) +
ggtitle("PC1 2013")
# PC2
gpc2_2013 <- ggplot() + 
geom_raster(pc2_2013, mapping=aes(x=x, y=y, fill=PC2)) +
ggtitle("PC2 2013")
# PC3
gpc3_2013 <- ggplot() + 
geom_raster(pc3_2013, mapping=aes(x=x, y=y, fill=PC3)) + 
ggtitle("PC3 2013")

gpc1_2013 + gpc2_2013 + gpc3_2013

# Per vedere la variabilità calcolo la deviazione standard sulla PC1 di entrambe le immagini
# Calcolo la deviazione standard della PC1 sempre con una moving window 3 x 3
sd_pc1_2013 <- focal(pc1_2013, matrix(1/9, 3, 3), fun=sd)

# Faccio ggplot della deviazione standard della PC1 usando viridis. Con opzione "inferno" non si vedeva bene la differenza.
im2_2013 <- ggplot() + 
geom_raster(sd_pc1_2013, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation over PC1 by viridis package - 2013")

# Bassa variabilità dove c'è roccia compatta e vegetazione 
# Massima variabilità al limite tra ghiaccio e suolo e tra crepacci

# Visualizzo insieme i plot: ggplot dell'immagine del 2013 e la sd di PC1 basata su una mw 3 x 3
g1_2013 + im2_2013


# 2021: stesso procedimento: prima analisi multivariata
c2021_pca <- rasterPCA(c2021)


# Faccio il summary del modello per vedere quanta variabilità spiega ogni componente
summary(c2021_pca$model)
# Proportion of Variance: PC1 spiega 89.5%, PC2 spiega 9.1%, PC3 spiega 1.2%

# Faccio un plot con tutte le componenti
plot(c2021_pca$map)

# Assegno oggetto alle prime 3 componenti
pc1_2021 <- c2021_pca$map$PC1
pc2_2021 <- c2021_pca$map$PC2
pc3_2021 <- c2021_pca$map$PC3

# Con ggplot faccio il plot delle singole componenti, associo al plot un oggetto
# PC1
gpc1_2021 <- ggplot() + 
geom_raster(pc1_2021, mapping=aes(x=x, y=y, fill=PC1)) +
ggtitle("PC1 2021")
# PC2
gpc2_2021 <- ggplot() + 
geom_raster(pc2_2021, mapping=aes(x=x, y=y, fill=PC2)) +
ggtitle("PC2 2021")
# PC3
gpc3_2021 <- ggplot() + 
geom_raster(pc3_2021, mapping=aes(x=x, y=y, fill=PC3)) +
ggtitle("PC3 2021")

gpc1_2021 + gpc2_2021 + gpc3_2021

# Calcolo della variabilità 
# Calcolo la deviazione standard della PC1 sempre con una moving window 3 x 3
sd_pc1_2021 <- focal(pc1_2021, matrix(1/9, 3, 3), fun=sd)

# Faccio ggplot della deviazione standard della PC1 usando viridis 
im2_2021 <- ggplot() + 
geom_raster(sd_pc1_2021, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation over PC1 by viridis package - 2021")

# Bassa variabilità dove c'è roccia compatta e vegetazione 
# Massima variabilità al limite tra ghiaccio e suolo e tra crepacci

# Visualizzo insieme i plot: ggplot dell'immagine del 2021 e la sd di PC1 basata su una mw 3 x 3
g1_2021 + im2_2021

# Visualizzo insieme i plot della variabilità calcolata sulla PC1 per entrambi gli anni
im2_2013 + im2_2021

# I plot sono stati salvati in pdf seguendo la struttura generale:
     # pdf("nome_plot.pdf)
     # plot() +
     # title(main="")
     # dev.off()
