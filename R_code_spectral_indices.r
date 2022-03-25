# 25 marzo

# Calcolo degli indici di vegetazione
library(raster) # Se ho problemi con le immagini .jpg scarica il pacchetto "rgdal"
setwd("C:/lab/")

# Import the first file -> defor1_.jpg -> give it the name l1992
l1992 <- brick("defor1_.jpg")
l1992

# Plottiamo l'immagine per vedere a quali colori corrispondono le bande, il numero della banda lo metto a caso perché non so a quali componenti corrispondono.
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
# Banda 1 è NIR perché nel plot la vegetazione è rossa. Di solito le bande vengono montate in sequenza, quindi la banda 2 corrisponde a R, e la banda 3 al G. 

# Banda 1 = NIR
# Banda 2 = red
# Banda 3 = green

# Esercizio: import the second file -> defor2_.jpg -> give it the name l2006
l2006 <- brick("defor2_.jpg")

# Plottiamo l'immagine
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# Esercizio: plot in multiframe the two images with one on top of the other
par(mfrow=c(2, 1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# Calcoliamo indice spettrale: DVI, Difference Vegetation Index. 
dvi1992 = l1992[[1]] - l1992[[2]]
#or
dvi1992 = l1992$defor1_.1 - l1992$defor1_.2

# Facciamo il plot di questo dato
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col=cl)

# Calcoliamo DVI per il 2006
dvi2006 = l2006[[1]] - l2006[[2]]
#or
dvi2006 = l2006$defor1_.1 - l2006$defor1_.2

# Plottiamo il dvi2006
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi2006, col=cl)

# Facciamo la differenza tra i due indici. Le zone rosse corrispondono alle zone fortemente soggette a deforestazione, alta variazione della salute delle piante.
dvi_dif = dvi1992 - dvi2006
cld <- colorRampPalette(c("blue", "white", "red")) (100)
plot(dvi_dif, col=cld)












