# Analisi e confronto di due immagini landsat della stessa località (p233r089): una acquisita nel 2013 e l'altra nel 2021 
# Le aree interessate comprendono Purto Montt, il Lago Llanquihue e il Parque Nacional Alerce Andino (Cile)

library(raster)
library(ggplot2)

setwd("C:/lab/chile_exam/")

# Importo le bande relative dell'immagine del 2013 facendo una lista perché sono 8 bande separate
rlist <- list.files(pattern="2013_SR_B")

import <- lapply(rlist, raster)

tgr <- stack(import)

plot(tgr)

# https://www.usgs.gov/faqs/what-are-best-landsat-spectral-bands-use-my-research 
# Sito da cui ho scaricato le immagini satellitari con spiegazione di ogni banda. 
# In questo caso:
  # B2 = blue
  # B3 = green
  # B4 = red
  # B5 = NIR
plotRGB(tgr, r=5, g=4, b=3, stretch="lin")
plotRGB(tgr, r=4, g=5, b=3, stretch="lin")

