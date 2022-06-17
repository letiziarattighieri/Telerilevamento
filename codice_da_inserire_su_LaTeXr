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


g1_2013 <- ggRGB(c2013, 5, 4, 3, stretch="lin") +        g1_2021 <- ggRGB(c2021, 5, 4, 3, stretch="lin") +      
           ggtitle("ggplot 2013")                                   ggtitle("ggplot 2021")

# INDICI SPETTRALI

dvi_2013 = c2013[[5]] - c2013[[4]]        dvi_2021 = c2021[[5]] - c2021[[4]]

dvi_dif = dvi_2013 - dvi_2021


# TIME SERIES

dif <- c2021[[5]] - c2013[[5]]

# LAND COVER

# 2013                                                                  # 2021
c2013_class <- unsuperClass(c2013, nClasses=4)                          c2021_class <- unsuperClass(c2021, nClasses=4)
clc <- colorRampPalette(c("yellow", "red", "blue", "black"))(100)       clc <- colorRampPalette(c("yellow", "red", "blue", "black"))(100)
plot(c2013_class$map, col=clc) +                                        plot(c2021_class$map, col=clc) +
title(main = "2013 classes")                                            title(main = "2021 classes")


# Frequenze 
freq(c2013_class$map)
freq(c2021_class$map)

tot2013 <- 405657
perc_tran_2013 <- 25566 * 100 / tot2013   # 6.302396 %
perc_snow_2013 <- 10651 * 100 / tot2013   # 2.625617 %
perc_soil_2013 <- 191607 * 100 / tot2013  # 47.23375 %
perc_vege_2013 <- 177833 * 100 / tot2013  # 43.83827 %

tot2021 <- 405578
perc_snow_2021 <- 14513 * 100 / tot2021   # 3.57835 %
perc_tran_2021 <- 31836 * 100 / tot2021   # 7.849538 %
perc_soil_2021 <- 194896 * 100 / tot2021  # 48.05389 %
perc_vege_2021 <- 164333 * 100 / tot2021  # 40.51822 %

class <- c("Vegetazione", "Suolo", "Transizione", "Neve")
percent_2013 <- c(43.83827, 47.23375, 6.302396, 2.625617)
percent_2021 <- c(40.51822, 48.05389, 7.849538, 3.57835)

multitemporal <- data.frame(class, percent_2013, percent_2021)

# 2013
perc_2013 <- ggplot(multitemporal, aes(x=class, y=percent_2013, color=class)) + 
geom_bar(stat="identity", fill="white") +
ggtitle("2013 percentages")

# 2021
perc_2021 <- ggplot(multitemporal, aes(x=class, y=percent_2021, color=class)) + 
geom_bar(stat="identity", fill="white") +
ggtitle("2021 percentages")

# ANALISI MULTIVARIATA

# 2013
c2013_pca <- rasterPCA(c2013)
summary(c2013_pca$model)
# Proportion of Variance: PC1 spiega 85.3%, PC2 spiega 13.2%, PC3 spiega 1.3%

# PC1
gpc1_2013 <- ggplot() + 
geom_raster(pc1_2013, mapping=aes(x=x, y=y, fill=PC1)) +
ggtitle("PC1 2013")

# 2013
# Calcolo la deviazione standard della PC1 sempre con una moving window 3 x 3
sd_pc1_2013 <- focal(pc1_2013, matrix(1/9, 3, 3), fun=sd)

# Faccio ggplot della deviazione standard della PC1 usando viridis 
im2_2013 <- ggplot() + 
geom_raster(sd_pc1_2013, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation over PC1 by viridis package - 2013")


# 2021
c2021_pca <- rasterPCA(c2021)
summary(c2021_pca$model)
# Proportion of Variance: PC1 spiega 89.5%, PC2 spiega 9.1%, PC3 spiega 1.2%

# PC1
gpc1_2021 <- ggplot() + 
geom_raster(pc1_2021, mapping=aes(x=x, y=y, fill=PC1)) +
ggtitle("PC1 2021")

# 2021
# Calcolo la deviazione standard della PC1 sempre con una moving window 3 x 3
sd_pc1_2021 <- focal(pc1_2021, matrix(1/9, 3, 3), fun=sd)

# Faccio ggplot della deviazione standard della PC1 usando viridis 
im2_2021 <- ggplot() + 
geom_raster(sd_pc1_2021, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation over PC1 by viridis package - 2021")

