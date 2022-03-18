# Questo è il primo script che useremo a lezione

#install.packages("raster")
library(raster)

#settaggio cartella di lavoro, "set working directory"
setwd("C:/lab/")

#importiamo dati. P sta per "path", R sta per "row", numeri assegnati in base al percorso del satellite.
l2011 <- brick("p224r63_2011.grd")
l2011

#per vedere l'immagine, la plottiamo con funzione plot
plot(l2011)

#cambiamo il colore della legenda. Il 100 indica il numero di colori intermedi tra i 3 che ho inserito nella nuova legenda
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)

#dopo aver cambiato il colore della legenda proseguo plottando le nuove immagini
plot(l2011, col=cl)

#Landsat ETM+
#B1 = blu
#B2 = verde
#B3 = rosso
#B4 = infrarosso vicino (NIR = Near InfraRed)

#plot delle immagini con i colori che sono in linea con le immagini stesse. Ora plottiamo la banda del blu (B1_sre):
plot(l2011$B1_sre)
#oppure si può plottare il numero corrispondente all'elemento, in questo caso la banda blu corrisponde al primo elemento
plot(l2011[[1]])

#plottiamo la banda del blu cambiando il colore della legenda usando la stessa che avevamo usato prima per tutte le altre
plot(l2011$B1_sre)
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(l2011$B1_sre, col=cl)

#plot b1 che va da dark blue a blue a light blue, ho messo clb altrimenti veniva cambiata l'altra legenda invece di metterne una nuova
clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=clb) 

#esportiamo il plot (non l'immagine) in pdf per farla comparire nella cartella LAB
pdf("banda1.pdf")
plot(l2011$B1_sre, col=clb) 
dev.off()

#esportiamo il plot in png sempre nella stessa cartella
png("banda1.png")
plot(l2011$B1_sre, col=clb) 
dev.off()

#per esportare tutta l'immagine con tutti i dati si usa la funzione writeRaster

#plottare più immagini insieme scegliendo quali usare
#prima plottiamo la banda del verde, B2_sre
plot(l2011$B2_sre)
clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col=clg)

#ora le mettiamo insieme
#multiframe, mfrow è la riga, in questo caso una sola, il 2 è riferito alle colonne
par(mfrow=c(1, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
dev.off()

#esporto il multiframe in pdf
pdf("multiframe.pdf")
par(mfrow=c(1, 2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
dev.off()

#esercizio: revert the multiframe. Voglio il multiframe ma invece di avere B1 a sx e B2 a dx voglio B1 sopra e B2 sotto
par(mfrow=c(2, 1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

#plottiamo la banda del rosso, B3_sre
plot(l2011$B3_sre)
clr <- colorRampPalette(c("dark red", "red", "pink")) (100)
plot(l2011$B3_sre, col=clr)

#plottiamo la banda NIR, B4_sre
plot(l2011$B4_sre)
clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col=clnir)

#facciamo multiframe con tutte e 4 le bande. Ricordati di plottare prima singolarmente le immagini perchè altrimenti dà errore in R
par(mfrow=c(2, 2))
#blue
plot(l2011$B1_sre, col=clb) 
# green
plot(l2011$B2_sre, col=clg) 
# red
clr <- colorRampPalette(c("dark red", "red", "pink")) (100)
plot(l2011$B3_sre, col=clr)
# NIR
clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col=clnir)
