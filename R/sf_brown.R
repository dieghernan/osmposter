library(sf)
library(dplyr)


sf.lines <-
  st_read("data/sf.lines.geojson", stringsAsFactors = FALSE)
sf.lines <-
  sf.lines[st_geometry_type(sf.lines) == "LINESTRING", ]

aa <-
  sf.lines %>% st_drop_geometry() %>% group_by(highway) %>% 
  summarise(n2 = n()) %>% arrange(n2)


primary <-
  sf.lines %>%
  filter(highway %in%  c("motorway", "primary", 
                         "motorway_link", "primary_link"))

secondary <-
  sf.lines %>% filter(highway %in%  c("secondary", "tertiary", 
                                      "secondary_link", "tertiary_link"))

terciary <-
  sf.lines %>% filter(highway %in%  c("residential",
                                      "footway",
                                      "service"))

col2rgb("#F7F2E8")

pdi = 90
svg(
  paste0("images/sf_brown.svg"),
  pointsize = pdi,
  width =  2100 / pdi,
  height = 2970 / pdi,
  bg = NA
)

par(mar = c(0, 0, 0, 0), bg = "#F7F2E8")
plot(st_geometry(primary), col = "#2a1506", lwd = 3)
plot(st_geometry(secondary),
     col = "#800000",
     add = TRUE,
     lwd = 2)
plot(st_geometry(terciary),
     col = "#8B4513",
     add = TRUE,
     lwd = 1.5)

dev.off()

rsvg::rsvg_png("images/sf_brown.svg", "images/sf_brown.png")

col2rgb("#800000")
