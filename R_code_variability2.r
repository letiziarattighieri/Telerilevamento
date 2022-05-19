# 19 maggio
# R code variability 2 - Using PC components

library(raster)
library(RStoolbox)
library(ggplot2)
library(patchwork)
library(viridis)
setwd("C:/lab/")

sen <- brick("sentinel.png")

# b1 = NIR
# b2 = Red
# b3 = Green

ggRGB(sen, 1, 2, 3)

# Exercise: visualize the image such as vegetation becomes green (fluo)
ggRGB(sen, 2, 1, 3)

# Multivariate analysis
sen_pca <- rasterPCA(sen)
sen_pca

summary(sen_pca$model)

plot(sen_pca$map)

pc1 <- sen_pca$map$PC1
pc2 <- sen_pca$map$PC2
pc3 <- sen_pca$map$PC3

g1 <- ggplot() + 
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

g2 <- ggplot() + 
geom_raster(pc2, mapping=aes(x=x, y=y, fill=PC2))

g3 <- ggplot() + 
geom_raster(pc3, mapping=aes(x=x, y=y, fill=PC3))

g1 + g2 + g3

# Standard deviation of PC1
sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)

# Map by ggplot the standard deviation of the first principal component
ggplot() + 
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer))

# With viridis
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis() +
ggtitle("Standard deviation by viridis package")

# cividis
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis(option = "cividis") +
ggtitle("Standard deviation by viridis package")

# magma
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis(option = "magma") +
ggtitle("Standard deviation by viridis package")

# inferno
ggplot() + 
geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) + 
scale_fill_viridis(option = "inferno") +
ggtitle("Standard deviation by viridis package")


# Images altogether: 
im1 <- ggRGB(sen, 2, 1, 3)

im2 <- ggplot() + 
geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

im3 <- ggplot() +
geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

# Calculate heterogeneity in a 5x5 moving window
sd5 <- focal(pc1, matrix(1/25, 5, 5), fun=sd)
sd5

im4 <- ggplot() +
geom_raster(sd5, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im3 + im4 

# Calculate heterogeneity in a 7x7 moving window
sd7 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)
sd7

im5 <- ggplot() +
geom_raster(sd7, mapping=aes(x=x, y=y, fill=layer)) +
scale_fill_viridis(option="inferno")

im3 + im4 + im5 

