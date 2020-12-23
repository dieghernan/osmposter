rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
watercol <- "grey90"
pdi = 90
outfile <- "alquife_clean"
bbox <- poster_bbox(c(-3.125610, 37.173859, -3.098574, 37.197655))


# A. Get shapes----

obj.lines <-
  poster_import("data/alquife.lines.geojson") %>% poster_lines()
obj.misc <-
  poster_import("data/alquife.misc.geojson") %>% poster_polys()


# B. Classify----

# Lines

primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

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
      "tertiary_link"
    )
  )


# Others - Specific

quarry <- obj.misc %>% filter(landuse %in% c("quarry"))
forest <- obj.misc %>% filter(landuse %in% c("forest"))
water <- obj.misc %>% filter(!is.na(water))

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

plot(st_geometry(water),
     add = TRUE,
     col = watercol,
     border = watercol)

plot(st_geometry(forest),
     add = TRUE,
     col = "grey80",
     border = "grey80")

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

plot(st_geometry(water),
     add = TRUE,
     col = watercol,
     border = watercol)

plot(st_geometry(forest),
     add = TRUE,
     col = "grey80",
     border = "grey80")

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

dev.off()
