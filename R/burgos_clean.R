rm(list = ls())

library(sf)

library(dplyr)
library(emojifont)

obj.lines <-
  st_read("data/burgos.lines.geojson", stringsAsFactors = FALSE) %>% st_transform(3857)
obj.lines <-
  obj.lines[st_geometry_type(obj.lines) == "LINESTRING", ]


obj.water <-
  st_read("data/burgos.water.geojson", stringsAsFactors = FALSE) %>% st_transform(3857)
obj.water <-
  obj.water[st_geometry_type(obj.water) == "LINESTRING", ]

obj.templos <-
  st_read("data/burgos.templos.geojson", stringsAsFactors = FALSE)  %>% st_transform(3857)

obj.templos <-
  obj.templos[st_geometry_type(obj.templos) == "MULTIPOLYGON", ]


primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

secondary <-
  obj.lines %>% filter(highway %in%  c("secondary", "tertiary", "secondary_link", "tertiary_link"))

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

# 	footway

watercol <- "grey80"


bbox <- c(-3.732948,42.326443,-3.653469,42.370974)
class(bbox) <- "bbox"
bbox <- bbox %>% st_as_sfc() %>% st_set_crs(4326) %>% st_transform(3857)

st_point(c(-3.7202377334466243,42.33755131603125)) %>% st_sfc(crs=4326) %>% st_transform(3857) %>% st_coordinates()

# SVG -----

pdi = 90
svg(
  paste0("images/burgos_clean.svg"),
  pointsize = pdi,
  width =  4200 / pdi,
  height = 4200 / pdi
)

par(mar=c(0,0,0,0))
plot_sf(bbox)

plot(
  st_geometry(obj.water %>% filter(waterway == "river")),
  add = TRUE,
  col = watercol,
  lwd=12,
  border = watercol
)

plot(
  st_geometry(obj.water %>% filter(waterway != "river")),
  add = TRUE,
  col = watercol,
  lwd=3.5,
  border = watercol
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

plot(st_geometry(obj.templos),
     col="grey50",
     border = "grey50",
     add=TRUE)

text(
  -414135, 5211678,
  
  labels = fontawesome("fa-heart"),
  cex = 0.7,
  col = 'black',
  family = 'fontawesome-webfont'
)


dev.off()
