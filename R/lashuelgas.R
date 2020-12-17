rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
pdi = 90
outfile <- "lashuelgas_sand"

#bbox <- poster_bbox(c(-4.474440,41.045634,-4.463711,41.055667))

# A. Get shapes----
obj.init <-
  poster_import("data/huelgas.geojson")


# B. Filter -----

# Recinto Huelgas

barrier <-
  obj.init %>% filter(id == "way/105742965") %>% st_cast("LINESTRING")


# Buildings
obj.pol <-
  obj.init %>% poster_polys() %>% filter(building == "yes") %>% st_cast("POLYGON")
pols <- obj.pol[c(1, 3, 4, 5), ]


# Gardens

obj.garden <-
  obj.init %>% filter(!is.na(landuse)) %>% st_cast("POLYGON")
obj.garden2 <-
  obj.init %>% filter(!is.na(leisure)) %>% st_cast("POLYGON")
obj.garden <- obj.garden %>% bind_rows(obj.garden2[c(1, 2, 3, 4), ])
obj.footway <-
  obj.init %>% poster_lines() %>% filter(id == "way/617461776")

plot(st_geometry(obj.footway))
plot(st_geometry(barrier), add = TRUE)

# Footway
obj.footway <-
  st_difference(obj.footway, st_buffer(barrier, 2)) %>% st_cast("LINESTRING")

obj.footway <- obj.footway[2, ]


# Fix barrier

pol2lline <- pols %>% st_union() %>% st_buffer(0)
plot(st_geometry(pol2lline))
barrier2 <-
  st_difference(barrier, pol2lline) %>% st_cast("LINESTRING")
deletebarr <- barrier2[c(1, 7), ] %>% st_union()

barrier_end <- st_difference(barrier, st_buffer(deletebarr, 1))

plot(st_geometry(barrier_end))

# C. SVG file ----

library(colorspace)

svgout <-
  file.path("images", paste0(outfile, ".svg"))


svg(
  svgout,
  pointsize = pdi,
  width =  2970 / pdi,
  height = 4200 / pdi,
  bg = "#F9F5F1"
)

map <-
  tm_shape(obj.garden, bbox = st_buffer(barrier_end, 25)) +
  tm_fill(col = "#E0CAB8") +
  tm_borders(col = "#F9F5F1", lwd = 2.5) + 
  tm_layout(frame = FALSE, bg.color = "#F9F5F1") +
  tm_compass(type = "8star",
             position = c("right", "top"),
             color.dark = "#995518",
             color.light = "#F9F5F1",
             text.color = "#995518",
             size = 3)

                                                                                                 
map + tm_shape(pols) + tm_sf(
  col = adjustcolor("#C29570", alpha.f = 0.7),
  border.col = "#F9F5F1",
  lwd = 3
) + tm_shape(obj.footway) + tm_sf(col = "#AF7445", lwd=1.5) +
  tm_shape(barrier_end) + tm_sf(  col = adjustcolor("#995518", alpha.f = 0.7),
                                  lwd = 15)
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

map <-
  tm_shape(obj.garden, bbox = st_buffer(barrier_end, 25)) +
  tm_fill(col = "#E0CAB8") +
  tm_borders(col = "#F9F5F1", lwd = 2.5) + 
  tm_layout(frame = FALSE, bg.color = "#F9F5F1") +
  tm_compass(type = "8star",
             position = c("right","top"),
             color.dark = "#995518",
             color.light = "#F9F5F1",
             text.color = "#995518",
             show.labels = 0,
             size=9)


map + tm_shape(pols) + tm_sf(
  col = adjustcolor("#C29570", alpha.f = 0.7),
  border.col = "#F9F5F1",
  lwd = 3
) + tm_shape(obj.footway) + tm_sf(col = "#AF7445", lwd=1.5) +
  tm_shape(barrier_end) + tm_sf(  col = adjustcolor("#995518", alpha.f = 0.7),
                                  lwd = 15)

dev.off()

