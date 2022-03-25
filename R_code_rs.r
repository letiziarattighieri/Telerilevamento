# Questo è il primo script che useremo a lezione

#install.packages("raster")
library(raster)

#settaggio cartella di lavoro, "set working directory"
setwd("C:/lab/")

#importiamo dati. P sta per "path", R sta per "row", numeri assegnati in base al percorso del satellite. "Brick" serve per catturare dati e caricarli dentro R: carica tutta l'immagine satellitare, tutte le bande insieme.
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

# Facciamo multiframe con tutte e 4 le bande. Ricordati di plottare prima singolarmente le immagini perchè altrimenti dà errore in R
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


# 24 marzo

# Plot of l2011 in the NIR channel (NIR band) (prima abbiamo ricaricato il pacchetto raster e abbiamo settato la working directoy)
clnir <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col=clnir)
# Or
plot(l2011[[4]])

# Plot RGB layers, il numero corrisponde all'elemento, cioè il numero della banda (stretch: amplia i valori dei colori per renderli più visibili)
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
# Sostituisco la banda NIR al posto della banda del rosso, di conseguenza scalo le altre bande fino ad escludere la banda del blu. Quindi metterò NIR al posto del rosso, il rosso al posto del verde e il verde al posto del blu. Tutto quello che è rosso è vegetazione, questo perchè la pianta riflette l'IR.
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")
# Sostituisco la banda NIR alla componente Green, rimettendo la banda 3 nella componente R. Serve per vedere meglio la vegetazione e la sua struttura, in questo caso la vegetazione è verde fluo.
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")
# Sostituisco la banda NIR alla componente Blu, le bande del rosso e verde sono nelle rispettive componenti. La vegetazione diventa blu e serve per vedere meglio il suolo nudo che nell'immagine diventa giallo.
plotRGB(l2011, r=3, g=2, b=4, stretch="lin")

# Proviamo a cambiare lo stretch nel plot con NIR nella componente Green
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

# Esercizio: costruire multiframe con la visualizzazione a colori naturali RGB (linear stretch) sopra ai false colors (histogram stretch)
par(mfrow=c(2,1))
plotRGB(l2011, r=3, g=2, b=1, stretch="lin")
plotRGB(l2011, r=3, g=4, b=2, stretch="hist")

# Esercizio: carica l'immagine del 1988
l1988 <- brick("p224r63_1988.grd")
l1988
plot(l1988)

# Confrontiamo le due immagini con un multiframe mettendo la banda NIR nella componente R e scalando le altre 2
par(mfrow=c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")





