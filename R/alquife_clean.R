rm(list = ls())

library(sf)

library(dplyr)
library(emojifont)


obj.lines <-
  st_read("data/alquife.lines.geojson", stringsAsFactors = FALSE)
obj.lines <-
  obj.lines[st_geometry_type(obj.lines) == "LINESTRING", ]

obj.misc <-
  st_read("data/alquife.misc.geojson", stringsAsFactors = FALSE)

quarry <- obj.misc %>% filter(landuse %in% c("quarry"))
forest <- obj.misc %>% filter(landuse %in% c("forest"))
water <- obj.misc %>% filter(!is.na(water))

bbox <- c(-3.125610,37.173859,-3.098574,37.197655) 
class(bbox) <- "bbox"


# Highways -----


primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

# Add residential and service in small places
secondary <-
  obj.lines %>% filter(highway %in%  c("secondary", "tertiary", "secondary_link", "tertiary_link",
                                       "residential","service"))

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


# Clean layout ----

pdi = 90
svg(
  paste0("images/alquife_clean.svg"),
  pointsize = pdi,
  width =  2100 / pdi,
  height = 2970 / pdi
)
par(mar=c(0,0,0,0))
plot_sf(st_as_sfc(bbox))

plot(
  st_geometry(water),
  add = TRUE,
  col = "grey90",
  border = "grey90"
)
plot(
  st_geometry(quarry),
  add = TRUE,
  col = "grey85",
  border = "grey85"
)
plot(
  st_geometry(forest),
  add = TRUE,
  col = "grey80",
  border = "grey95"
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

dev.off()

rsvg::rsvg_png("images/alquife_clean.svg","images/alquife_clean.png")


