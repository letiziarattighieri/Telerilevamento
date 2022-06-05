# 1 aprile
# Time series analysis of Greenland LST data

library(raster)
setwd("C:/lab/greenland")

# Importo i file tif uno alla volta con la funzione raster. Questo è il metodo più lungo perché li importo singolarmente
lst2000 <- raster("lst_2000.tif")
plot(lst2000)

# Esercizio: Import all the data
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

# Creo una colorRampPalette per cambiare i colori della legenda.
cl <- colorRampPalette(c("blue", "light blue", "pink", "red")) (100)

# Creo multiframe con 2 righe e 2 colonne
par(mfrow=c(2,2))
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)

# Ora importo tutti i dati insieme applicando la funzione raster alla nostra lista di file. 
# La funzione lapply poi applicherà la funzione raster alla lista.
# Import the whole set altogether
rlist <- list.files(pattern="lst")
rlist
import <- lapply(rlist, raster)
import

# Con la funzione stack creo un blocco comune con tutti i dati che ho importato. 
# Ho preso i singoli layer e li ho messi insieme in un unico blocco.
tgr <- stack(import)
tgr

# Plotto il blocco di dati, in questo modo il risultato è lo stesso che otterrei creando un multiframe  
# ma è molto più rapido perché non devo effettivamente creare il mf
plot(tgr, col=cl)
# Plot di una singola banda, posso o usare $nome o mettere [[n.elemento]]
plot(tgr[[1]], col=cl)

# Provo a plottare i dati con plotRGB, mettendo le bande in ordine cronologico nelle 3 componenti R, G, B. 
# Posso giocare con la sovrapposizione delle bande visto che ne ho 4 ma posso usarne solo 3 alla volta.
plotRGB(tgr, r=1, g=2, b=3, stretch="lin")




# 7 aprile
# Analisi della diminuzione degli ossidi di azoto, NO2, durante il lockdown iniziale 2020
# NO2 decrease during the lockdown period in 2020
# EN means European Nitrogen

library(raster)
setwd("C:/lab/EN")

# Importo il primo dato usando la funzione raster perché ha un solo layer
# Se ne avesse avuti di più come gli RGB allora avrei usato funzione brick
# en01 è gennaio 2020 ed è un dato a 8 bit
en01 <- raster("EN_0001.png")
en01 
cl <- colorRampPalette(c('red','orange','yellow'))(100)
plot(en01, col=cl)

# Importo il dato corrispondente a fine marzo 2020
en13 <- raster("EN_0013.png")
plot(en13, col=cl)


# Let's import the whole set (altogether)
# Excercise: import the whole set as in the Greenland example by the following steps: list.files, lapply, stack

rlist <- list.files(pattern="EN")

rimp <- lapply(rlist, raster)

en <- stack(rimp)

plot(en, col=cl)

# Excercise: plot en01 besides en13
par(mfrow=c(1, 2))
plot(en$en01, col=cl)
plot(en$en13, col=cl)

# Oppure, invece del multiframe, posso fare stack da cui prendo i 2 elementi
en113 <- stack(en[[1]], en[[13]])
plot(en113, col=cl)

# Let's make the difference between en01 and en13. Il rosso indica le zone in cui il calo è stato maggiore
difen <- en[[1]] - en[[13]]
cldif <- colorRampPalette(c("blue", "white", "red"))(100)
plot(difen, col=cldif)



# 8 aprile
# Uso una funzione per usare un codice che deriva da altre fonti
# Riprendo parte del codice e lo salvo su word in .txt

library(raster)
setwd("C:/lab/EN")
en01 <- raster("EN_0001.png")
en01 
cl <- colorRampPalette(c('red','orange','yellow'))(100)
plot(en01, col=cl)


setwd("C:/lab/")
source("R_inputcode.txt")

# Importo tutte le immagini della cartella EN
rlist <- list.files(pattern="EN")
rimp <- lapply(rlist, raster)
en <- stack(rimp)
cl <- colorRampPalette(c('red','orange','yellow'))(100)
plot(en, col=cl)

# Ora faccio il plot RGB, usiamo le immagini 1, 7 e 15 nelle tre componenti R, G, B in cui i valori massimi di NO2 saranno del colore della componente corrispondente
plotRGB(en, r=1, g=7, b=15, stretch="lin")
plotRGB(en, r=1, g=7, b=13, stretch="hist")

# Finita la parte delle time series
