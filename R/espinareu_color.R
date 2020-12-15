rm(list = ls())

library(sf)

library(dplyr)
library(emojifont)


obj.lines <-
  st_read("data/espinareu.lines.geojson", stringsAsFactors = FALSE)
# obj.lines <-
#   st_read("data/espinareu.lines.geojson", stringsAsFactors = FALSE)
# obj.lines <-
#   obj.lines[st_geometry_type(obj.lines) == "LINESTRING", ]


obj.landuse <-
  st_read("data/espinareu.landuse.geojson", stringsAsFactors = FALSE)


residential <- obj.landuse %>% filter(landuse != "forest")
forest <- obj.landuse %>% filter(landuse == "forest")

buildings <-
  obj.lines[st_geometry_type(obj.lines) == "POLYGON",]



plot(buildings)
water <-
  st_read("data/espinareu.water.geojson", stringsAsFactors = FALSE)



bbox <- c(-5.364573, 43.29762, -5.361857, 43.30207)
class(bbox) <- "bbox"


# Highways -----


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


# Color layout ----

pdi = 90
svg(
  paste0("images/espinareu_color.svg"),
  pointsize = pdi,
  width =  2100 / pdi,
  height = 2970 / pdi
)
par(mar = c(0, 0, 0, 0), bg = "#add19e")
plot_sf(st_as_sfc(bbox))

plot(st_geometry(forest),
     col = "#d3e7cb",
     border = "#d3e7cb",
     add = TRUE)

plot(st_geometry(residential),
     col = "#f1ddcb",
     border = "#f1ddcb",
     add = TRUE)

plot(
  st_geometry(water),
  add = TRUE,
  col = "#aad3df",
  border = "#aad3df",
  lwd = 20
)


plot(
  st_geometry(terciary[st_geometry_type(terciary) == "LINESTRING", ]),
  col = "#af893a",
  border = "#af893a",
  add = TRUE,
  lwd = 0.75
)

plot(
  st_geometry(secondary),
  col = "#f7fac4",
  border = "#f7fac4",
  add = TRUE,
  lwd = 2.5
)
plot(
  st_geometry(primary),
  col = "white",
  border = "white",
  add = TRUE,
  lwd = 3.5
)

plot(
  st_geometry(buildings),
  add = TRUE,
  border = "#d08f55",
  col = "#d08f55",
  lwd = 2
)

dev.off()
rsvg::rsvg_png("images/espinareu_color.svg", "images/espinareu_color.png")

col2rgb("#add19e")


