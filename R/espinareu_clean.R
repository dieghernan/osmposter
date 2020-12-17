rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
pdi = 90
outfile <- "espinareu_clean"
watercol <- "grey90"
bbox <- poster_bbox( c(-5.364573, 43.29762, -5.361857, 43.30207))

# A. Get shapes----
obj.init <-
  poster_import("data/espinareu.lines.geojson") 

obj.lines <- poster_lines(obj.init)
obj.pols <- poster_polys(obj.init)

obj.landuse <-
  poster_import("data/espinareu.landuse.geojson") %>% poster_polys()

obj.water <- poster_import("data/espinareu.water.geojson")

# B. Classify----

# Lines

primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link","tertiary"))

# Add residential and service in small places
secondary <-
  obj.lines %>% filter(
    highway %in%  c(
      "secondary",
      "tertiary",
      "secondary_link",
      "tertiary_link",
      "residential",
      "service"
    )
  )

terciary <-
  obj.lines %>% filter(
    !highway %in%  c(
      "motorway",
      "primary",
      "motorway_link",
      "primary_link",
      "secondary",
      "tertiary",
      "secondary_link",
      "tertiary_link",
      "residential",
      "service"
    )
  )

residential <- obj.landuse %>% filter(landuse != "forest")
forest <- obj.landuse %>% filter(landuse == "forest")


# C. SVG file ----

svgout <- file.path("images", paste0(outfile, ".svg"))



svg(
  svgout,
  pointsize = pdi,
  width =  2970 / pdi,
  height = 4200 / pdi
)
par(mar = c(0, 0, 0, 0))
plot_sf(bbox)


plot(st_geometry(residential),
     col = "grey95",
     border = "grey95",
     add = TRUE)

plot(
  st_geometry(obj.water),
  add = TRUE,
  col = watercol,
  border = watercol,
  lwd = 20
)

plot(st_geometry(terciary),
     col = "grey50",
     add = TRUE,
     lwd = 0.75)
plot(st_geometry(secondary),
     col = "grey30",
     add = TRUE,
     lwd = 2.5)
plot(st_geometry(primary),
     col = "grey20",
     add = TRUE,
     lwd = 3.5)

plot(
  st_geometry(obj.pols),
  add = TRUE,
  border = "grey60",
  col = "grey60",
  lwd = 2
)
dev.off()

# Convert to png

pnggout <- file.path("images", paste0(outfile, ".png"))
my_image <- image_read(svgout)
my_svg <- image_convert(my_image, format = "png")
image_write(my_svg, pnggout)




# D. JPEG file ----


jpegout <- file.path("images", paste0(outfile, ".jpeg"))



jpeg(jpegout,
     res = 300,
     width =  2970 ,
     height = 4200)
par(mar = c(0, 0, 0, 0))
plot_sf(bbox)

plot(st_geometry(residential),
     col = "grey95",
     border = "grey95",
     add = TRUE)

plot(
  st_geometry(obj.water),
  add = TRUE,
  col = watercol,
  border = watercol,
  lwd = 20
)

plot(st_geometry(terciary),
     col = "grey50",
     add = TRUE,
     lwd = 0.75)
plot(st_geometry(secondary),
     col = "grey30",
     add = TRUE,
     lwd = 2.5)
plot(st_geometry(primary),
     col = "grey20",
     add = TRUE,
     lwd = 3.5)

plot(
  st_geometry(obj.pols),
  add = TRUE,
  border = "grey60",
  col = "grey60",
  lwd = 2
)

dev.off()
