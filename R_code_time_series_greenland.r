# 1 aprile
# Time series analysis of Greenland LST data

library(raster)
setwd("C:/lab/greenland")

# Importiamo i file tif uno alla volta con la funzione raster. Questo è il metodo più lungo perché li importiamo singolarmente, poi vedremo metodo più rapido.
lst2000 <- raster("lst_2000.tif")
plot(lst2000)

# Esercizio: Import all the data
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

# Creiamo una colorRampPalette per cambiare i colori della legenda.
cl <- colorRampPalette(c("blue", "light blue", "pink", "red")) (100)

# Creaimo multiframe con 2 righe e 2 colonne
par(mfrow=c(2,2))
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)

# Ora importiamo tutti i dati insieme applicando la funzione raster alla nostra lista di file. La funzione lapply poi applicherà la funzione raster alla lista.
# Import the whole set altogether
rlist <- list.files(pattern="lst")
rlist
import <- lapply(rlist, raster)
import

# Con la funzione stack creiamo un blocco comune con tutti i dati che ho importato. Ho preso i singoli layer e li ho messi insieme in un unico blocco.
tgr <- stack(import)
tgr

# Plottiamo il blocco di dati, in questo modo il risultato è lo stesso che otterrei creando un multiframe ma è molto più rapido perché non devo effettivamente creare il mf
plot(tgr, col=cl)
# Plot di una singola banda, posso o usare $nome o mettere [[n.elemento]]
plot(tgr[[1]], col=cl)

# Proviamo a plottare i dati con plotRGB, mettendo le bande in ordine cronologico nelle 3 componenti R, G, B. Posso giocare con la sovrapposizione delle bande visto che ne ho 4 ma posso usarne solo 3 alla volta.
plotRGB(tgr, r=1, g=2, b=3, stretch="lin")
