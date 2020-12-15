library(sf)

library(dplyr)

color <- "#60c1ca" # Aquamarine

menorca.pol <- st_read("data/menorca.pol.geojson")
menorca.pol <-
  menorca.pol[st_geometry_type(menorca.pol) == "MULTIPOLYGON",]

menorca.lines <-
  st_read("data/menorca.lines.geojson", stringsAsFactors = FALSE)
menorca.lines <-
  menorca.lines[st_geometry_type(menorca.lines) == "LINESTRING",]


tuq <- colorRampPalette(c("white", "#60c1ca"))(10)


scales::show_col(tuq)

base <- menorca.pol

aa <-
  menorca.lines %>% st_drop_geometry()%>% group_by(highway) %>% summarise(n2 = n()) %>% arrange(n2)

primary <-
  menorca.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

secondary <-
  menorca.lines %>% filter(highway %in%  c("secondary", "tertiary", "secondary_link", "tertiary_link"))

terciary <-
  menorca.lines %>% filter(highway %in%  c(
    "path",
    "track"
  ))


st_centroid(menorca.pol)

pdi <- 90

svg(
  paste0("images/menorca_turq.svg"),
  pointsize = pdi,
  width =  2970 / pdi,
  height = 2100 / pdi,
  bg = NA
)

par(mar=c(0,0,0,0))
plot(st_geometry(base), border = NA, col = tuq[9])
plot(st_geometry(primary), col = tuq[1], add = TRUE, lwd=3)
plot(st_geometry(secondary), col = tuq[2], add = TRUE, lwd=2)
plot(st_geometry(terciary), col = tuq[3], add = TRUE, lwd=1.5)

dev.off()

col2rgb(tuq[5])
col2rgb("#43878D")
  

rsvg::rsvg_png("images/menorca_turq.svg","images/menorca_turq.png")
