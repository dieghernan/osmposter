rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
watercol <- "grey90"
pdi = 90
outfile <- "berlin_blueprint"
bbox <- poster_bbox(c(13.24, 52.399067, 13.53, 52.61))



# A. Get shapes----

primary <-
  poster_import("data/berlin.primary.geojson") %>% poster_lines()

secondary <-
  poster_import("data/berlin.secondary.geojson") %>% poster_lines()

terciary <-
  poster_import("data/berlin.terciary.geojson") %>% poster_lines()

water <-
  poster_import("data/berlin.water.geojson") 

waterlines <- water %>% poster_lines()
waterbody <- water %>% poster_polys()

# C. SVG file ----

svgout <- file.path("images", paste0(outfile, ".svg"))



svg(
  svgout,
  pointsize = pdi,
  width =  2970 / pdi,
  height = 4200 / pdi,
  bg = "#265486"
)
par(mar = c(0, 0, 0, 0))
plot_sf(bbox)

plot(
  st_geometry(waterlines),
  add = TRUE,
  col = adjustcolor("white", alpha.f = .2),
  border = adjustcolor("white", alpha.f = .2),
  lwd = 12
)

plot(
  st_geometry(waterbody),
  add = TRUE,
  col = adjustcolor("white", alpha.f = .2),
  border = NA
)


plot(
  st_geometry(terciary),
  col = adjustcolor("white", alpha.f = .5),
  border = adjustcolor("white", alpha.f = .5),
  add = TRUE,
  lwd = 0.75
)

plot(
  st_geometry(secondary),
  col = adjustcolor("white", alpha.f = .6),
  border = adjustcolor("white", alpha.f = .6),
  add = TRUE,
  lwd = 2.5
)
plot(
  st_geometry(primary),
  col = adjustcolor("white", alpha.f = .8),
  border = adjustcolor("white", alpha.f = .8),
  add = TRUE,
  lwd = 3.5
)


dev.off()

# Convert to png

pnggout <- file.path("images", paste0(outfile, ".png"))
my_image <- image_read(svgout)
my_svg <- image_convert(my_image, format = "png")
image_write(my_svg, pnggout)




# D. JPEG file ----

# TOO BIG, USE GIMP

# jpegout <- file.path("images", paste0(outfile, ".jpeg"))
# 
# 
# 
# jpeg(jpegout,
#      res = 300,
#      width =  2970 ,
#      height = 4200)
# par(mar = c(0, 0, 0, 0))
# plot_sf(bbox)
# 
# plot(
#   st_geometry(water),
#   add = TRUE,
#   col = adjustcolor("white", alpha.f = .2),
#   border = adjustcolor("white", alpha.f = .2),
#   lwd = 12
# )
# 
# plot(
#   st_geometry(terciary),
#   col = adjustcolor("white", alpha.f = .5),
#   border = adjustcolor("white", alpha.f = .5),
#   add = TRUE,
#   lwd = 0.75
# )
# 
# plot(
#   st_geometry(secondary),
#   col = adjustcolor("white", alpha.f = .6),
#   border = adjustcolor("white", alpha.f = .6),
#   add = TRUE,
#   lwd = 2.5
# )
# plot(
#   st_geometry(primary),
#   col = adjustcolor("white", alpha.f = .8),
#   border = adjustcolor("white", alpha.f = .8),
#   add = TRUE,
#   lwd = 3.5
# )
# 
# dev.off()

