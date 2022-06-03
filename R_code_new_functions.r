# 3 giugno pomeriggio: Lezione con Elisa Thouverai sulla creazione di nuove funzioni da zero

cheer_me <- function(your_name) {
  cheer_string <- paste("Hello", your_name, sep = " ")
  print(cheer_string)
}

cheer_me("Letizia")

cheer_me_n_times <- function(your_name, n) {
  cheer_string <- paste("Hello", your_name, sep = " ")
  
  for(i in seq(1, n)) {
  print(cheer_string)
 }
}

# for() è il ciclo for, elemento i si ripete n volte
cheer_me_n_times("Letizia", 3)



library(raster)
setwd("C:/lab/")
dato <- raster("sentinel.png")
plot(dato)

# Funzione plot scegliendo la palette di colori
plot_raster <- function(r, col = NA) {
  if(!is.na(col)) {
  pal <- colorRampPalette(col) (100)
  plot(r, col = pal)
  } else {
  
  plot(r)
  }
}

plot_raster(dato, c("brown", "yellow", "green"))

plot_raster(dato) # Colori di default

