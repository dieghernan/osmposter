library(sf)

library(dplyr)
library(emojifont)


load.fontawesome(font = "fontawesome-webfont.ttf")


ed.lines <-
  st_read("data/ed.lines.geojson", stringsAsFactors = FALSE)
ed.lines <-
  ed.lines[st_geometry_type(ed.lines) == "LINESTRING", ]




Home <-
  st_sfc(st_point(c(-3.1857049, 55.9633722)), crs = st_crs(ed.lines))
sample_fontawesome(10, replace = FALSE)



ed.wet <-
  st_read("data/ed.wet.geojson", stringsAsFactors = FALSE)

ed.river <- ed.wet %>% filter(name == "Water of Leith") %>% st_make_valid()
ed.noriver <- ed.wet %>% filter(water != "river" | is.na(water))
ed.noriver <-
  ed.noriver[st_geometry_type(ed.noriver) == "POLYGON",]

primary <-
  ed.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

secondary <-
  ed.lines %>% filter(highway %in%  c("secondary", "tertiary", "secondary_link", "tertiary_link"))

terciary <-
  ed.lines %>% filter(
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

# Format----

watercol <- "grey90"


pdi = 90
svg(
  paste0("images/edinburgh_clean.svg"),
  pointsize = pdi,
  width =  2100 / pdi,
  height = 2970 / pdi
)

par(mar = c(0, 0, 0, 0))
plot_sf(primary, xlim = c(-3.233100,-3.143836),
        ylim = c(55.935318,55.996229))
plot(
  st_geometry(ed.noriver),
  add = TRUE,
  col = watercol,
  border = watercol
)
plot(
  st_geometry(ed.river),
  add = TRUE,
  col = watercol,
  lwd=3,
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



text(
  -3.1857049,
  55.9633722,
  labels = fontawesome("fa-home"),
  cex = 0.4,
  col = 'black',
  family = 'fontawesome-webfont'
)


dev.off()

library(magick)
my_image <- image_read("images/edinburgh_clean.svg")
my_svg <- image_convert(my_image, format="png")
image_write(my_svg, "images/edinburgh_clean.png")
#-----


plot(st_geometry(ed.lines))
