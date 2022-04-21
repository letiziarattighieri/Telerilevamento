# 8 aprile
# Classificazione dei minerali nelle rocce del grand canyon
# Classificazione degli oggetti

library(raster)
library(RStoolbox)
setwd("C:/lab/")

# Importiamo i dati con la funzione brick perché mi servono tutte e 3 i livelli dell'immagine
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
so
plotRGB(so, r=1, g=2, b=3, stretch="lin")
# Or: L'ordine dei colori delle bande è sempre R, G, B quindi posso scrivere direttamente il numero della banda che voglio assegnare alla componente e lo legge lo stesso
plotRGB(so, 1, 2, 3, stretch="lin") 

# CLassifichiamo i dati: (immagine, n° classi che deve trovare il computer)
soc <- unsuperClass(so, nClasses=3)

cl <- colorRampPalette(c("yellow", "black", "red"))(100)
plot(soc$map, col=cl)

# set.seed can be used for reeating the same experiment every time




# 21 aprile 
# Riprendiamo la classificazione di immagini con il Grand Canyon

library(raster)
library(RStoolbox)

setwd("C:/lab/")

# Importiamo l'immagine satellitare che classificheremo. E' un'immagine a 8 bit, con 3 bande
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
gc

# Plottiamo l'immagine e si vede con i colori che vede l'occhio umano perchè le bande sono in ordine R, G, B
plotRGB(gc, r=1, g=2, b=3, stretch="lin")
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# Classifichiamo l'immagine
gcclass2 <- unsuperClass(gc, nClasses=2)
plot(gcclass2$map) 

# Exercise: classify the map with 4 classes
gcclass4 <- unsuperClass(gc, nClasses=4)
plot(gcclass4$map, col=cl)
cl <- colorRampPalette(c("yellow", "red", "blue", "black"))(100)

# Compare the classified map with the original set
par(mfrow=c(2,1))
plot(gcclass4$map, col=cl)
plotRGB(gc, r=1, g=2, b=3, stretch="hist")
plotRGB(gc, r=1, g=2, b=3, stretch="lin")





