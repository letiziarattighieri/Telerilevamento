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






