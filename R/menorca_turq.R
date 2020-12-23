rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
watercol <- "grey90"
pdi = 90
outfile <- "menorca_turq"
color <- "#60c1ca" # Aquamarine


# A. Get shapes----

obj.lines <-
  poster_import("data/menorca.lines.geojson") %>% poster_lines()

obj.pol <-
  poster_import("data/menorca.pol.geojson") %>% poster_polys()

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
      "tertiary_link"
      # ",residential",
      # "service"
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

bbox <- obj.pol

svg(
  svgout,
  pointsize = pdi,
  width =  4200 / pdi,
  height = 2970 / pdi,
  bg = NA
)



par(mar = c(0, 0, 0, 0))
plot_sf(bbox)
plot(
  st_geometry(obj.pol),
  add = TRUE,
  col = "#60c1ca",
  border = NA
)

plot(st_geometry(terciary),
     col = adjustcolor("white", alpha.f = .5),
     add = TRUE,
     lwd = 0.75)
plot(st_geometry(secondary),
     col = adjustcolor("white", alpha.f = .6),
     add = TRUE,
     lwd = 2.5)
plot(st_geometry(primary),
     col = adjustcolor("white", alpha.f = .8),
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
     bg = tuq[5],
     width =  4200 ,
     height = 2970)

par(mar = c(0, 0, 0, 0))
plot_sf(bbox)
plot(
  st_geometry(obj.pol),
  add = TRUE,
  col = "#60c1ca",
  border = NA
)

plot(st_geometry(terciary),
     col = adjustcolor("white", alpha.f = .5),
     add = TRUE,
     lwd = 0.75)
plot(st_geometry(secondary),
     col = adjustcolor("white", alpha.f = .6),
     add = TRUE,
     lwd = 2.5)
plot(st_geometry(primary),
     col = adjustcolor("white", alpha.f = .8),
     add = TRUE,
     lwd = 3.5)


dev.off()


