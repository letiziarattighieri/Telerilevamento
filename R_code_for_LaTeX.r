library(raster)
library(RStoolbox) # Per visualizzare le immagini e calcoli
library(ggplot2) # Per i plot ggplot
library(patchwork) # Per creare multiframe con ggplot
library(viridis) 

setwd("C:/lab/china_exam/")

list_2013 <- list.files(pattern="2013_SR_B")
import_2013 <- lapply(list_2013, raster)
china_2013 <- stack(import_2013)

c2013 <- aggregate(china_2013, fact=10)

list_2021 <- list.files(pattern="2021_SR_B")
import_2021 <- lapply(list_2021, raster)
china_2021 <- stack(import_2021)

c2021 <- aggregate(china_2021, fact=10)
