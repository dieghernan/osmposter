rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
pdi = 90
outfile <- "sf_brown"


# A. Get shapes----

obj.lines <-
  poster_import("data/sf.lines.geojson") %>% poster_lines()

# B. Classify----

# Lines

primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

# Add residential and service in small places
secondary <-
  obj.lines %>% filter(highway %in%  c("secondary",
                                       "tertiary",
                                       "secondary_link",
                                       "tertiary_link"))

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
      "tertiary_link"
    )
  )



# C. SVG file ----

svgout <-
  file.path("images", paste0(outfile, ".svg"))

bbox <- obj.lines

svg(
  svgout,
  pointsize = pdi,
  width =  2970 / pdi,
  height = 4200 / pdi,
  bg = "#f7f2e8"
)
par(mar = c(0, 0, 0, 0))
plot_sf(bbox)

plot(st_geometry(terciary),
     col = "#8B4513",
     add = TRUE,
     lwd = 0.75)
plot(st_geometry(secondary),
     col = "#800000",
     add = TRUE,
     lwd = 2.5)
plot(st_geometry(primary),
     col = "#2a1506",
     add = TRUE,
     lwd = 3.5)

dev.off()

# Convert to png

pnggout <-
  file.path("images", paste0(outfile, ".png"))
my_image <- image_read(svgout)
my_svg <-
  image_convert(my_image, format = "png")
image_write(my_svg, pnggout)

# D. JPEG file ----

jpegout <-
  file.path("images", paste0(outfile, ".jpeg"))



jpeg(jpegout,
     res = 300,
     bg = "#f7f2e8",
     width =  4200 ,
     height = 2970)


par(mar = c(0, 0, 0, 0))
plot_sf(bbox)

plot(st_geometry(terciary),
     col = "#8B4513",
     add = TRUE,
     lwd = 0.75)
plot(st_geometry(secondary),
     col = "#800000",
     add = TRUE,
     lwd = 2.5)
plot(st_geometry(primary),
     col = "#2a1506",
     add = TRUE,
     lwd = 3.5)

dev.off()



