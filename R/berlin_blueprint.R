rm(list = ls())

library(sf)
library(dplyr)

primary <-
  st_read("data/berlin.primary.geojson", stringsAsFactors = FALSE)

primary <-
  primary[st_geometry_type(primary) == "LINESTRING", ]

secondary <-
  st_read("data/berlin.secondary.geojson", stringsAsFactors = FALSE)

secondary <-
  secondary[st_geometry_type(secondary) == "LINESTRING", ]

terciary <-
  st_read("data/berlin.terciary.geojson", stringsAsFactors = FALSE)

terciary <-
  terciary[st_geometry_type(terciary) == "LINESTRING", ] %>% st_geometry() %>% st_combine() %>% st_make_valid()

water <-
  st_read("data/berlin.water.geojson", stringsAsFactors = FALSE)

water <- water %>% filter(water %in% c("river", "lake"))


terciary %>% st_drop_geometry()


r <- st_graticule(primary) %>% st_geometry()
# Plot -----


pdi = 90
svg(
  paste0("images/berlin_blueprint.svg"),
  pointsize = pdi,
  width =  2100 / pdi,
  height = 2970 / pdi,
  bg = "#265486"
)

par(mar = c(0, 0, 0, 0))

plot_sf(terciary)

plot(
  st_geometry(water),
  col = adjustcolor("white", alpha.f = .1),
  border = adjustcolor("white", alpha.f = .1),
  lwd = 1,
  add = TRUE
)


plot(
  st_geometry(primary),
  col = adjustcolor("white", alpha.f = .8),
  border = adjustcolor("white", alpha.f = .8),
  add = TRUE,
  lwd = 4
)
plot(
  st_geometry(secondary),
  col = adjustcolor("white", alpha.f = .6),
  border = adjustcolor("white", alpha.f = .6),
  add = TRUE,
  lwd = 2
)
plot(
  st_geometry(terciary),
  col = adjustcolor("white", alpha.f = .5),
  border = adjustcolor("white", alpha.f = .5),
  add = TRUE,
  lwd = 1.5
)
plot(r, lty = "dashed", col = "#0a1b29", add = TRUE)
dev.off()


rsvg::rsvg_png("images/berlin_blueprint.svg", "images/berlin_blueprint.png")

col2rgb("#265486")

library(magick)
my_image <- image_read("images/berlin_blueprint.svg")
my_svg <- image_convert(my_image, format="png")
image_write(my_svg, "images/berlin_blueprint.png")

#----

plot(st_geometry(secondary))

plot(
  st_geometry(primary),
  col = adjustcolor("white", alpha.f = .2),
  add = TRUE,
  lwd = 2
)
plot(st_geometry(secondary), add = TRUE)
plot(st_geometry(water),
     col = "blue",
     border = "blue",
     add = TRUE)
