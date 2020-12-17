rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
pdi = 90
outfile <- "melque_clean"
watercol <- "grey90"
bbox <- poster_bbox(c(-4.474440,41.045634,-4.463711,41.055667))

# A. Get shapes----
obj.init <-
  poster_import("data/melque.geojson")


obj.lines <- poster_lines(obj.init) %>% filter(is.na(waterway))
obj.water <- poster_lines(obj.init) %>% filter(!is.na(waterway))
obj.pol <- poster_polys(obj.init)
obj.selpol <-
  poster_polys(obj.init) %>% filter(is.na(highway)) %>% filter(!landuse %in% c("residential"))

obj.place <-
  obj.init %>% filter(name == "Fuente Pelencha") %>%
  st_cast("POINT") %>% 
  st_buffer(3, endCapStyle = "SQUARE") %>% 
  bind_rows(obj.selpol)


# B. Classify----

# Lines

primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link",
                         "tertiary",      "tertiary_link"))

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

plot(st_geometry(obj.water),
     add = TRUE,
     col = watercol,
     border = watercol,
     lwd = 8)

plot(st_geometry(obj.place),
     col="grey60",
     border = "grey60",
     add =TRUE)

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
     lwd = 5)



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

plot(st_geometry(obj.water),
     add = TRUE,
     col = watercol,
     border = watercol,
     lwd = 8)

plot(st_geometry(obj.place),
     col="grey60",
     border = "grey60",
     add =TRUE)

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
     lwd = 5)


dev.off()


