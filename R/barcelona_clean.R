rm(list = ls())

library(sf)
library(dplyr)
library(emojifont)
library(magick)
library(osmdata)
library(osmextract)


# A. Get shapes----
a <- mapSpain::esp_get_munic(munic = "^Barcelona$", epsg = 4326) %>%
  st_centroid() %>% st_transform(3857) %>% st_buffer(30) %>%
  st_transform(4326)
plot(a$geometry)

primary <- opq(bbox = st_bbox(a))%>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", "motorway_link", "primary_link")) %>%
  osmdata_sf()

nrow(primary)



primary <- primary$osm_lines
primary_end <- primary[st_geometry_type(primary) %in% c("LINESTRING", "MULTILINESTRING"), ]
primary_end <- st_crop(primary_end, st_bbox(a))

plot(primary_end$geometry)


secondary <- opq(bbox = st_bbox(a))%>%
  add_osm_feature(key = "highway", 
                  value = c("secondary", "tertiary", "secondary_link", "tertiary_link")) %>%
  osmdata_sf()

secondary <- secondary$osm_lines
secondary_end <- secondary[st_geometry_type(secondary) %in% c("LINESTRING", "MULTILINESTRING"), ]
secondary_end <- st_crop(secondary_end, st_bbox(a))

plot(secondary_end$geometry, add=TRUE)


tertiary <- opq(bbox = st_bbox(a))%>%
add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                              "unclassified",
                              "service", "footway")) %>%
  osmdata_sf()


tertiary <- tertiary$osm_lines
tertiary_end <- tertiary[st_geometry_type(tertiary) %in% c("LINESTRING", "MULTILINESTRING"), ]
tertiary_end <- st_crop(tertiary_end, st_bbox(a))


library(ggplot2)

p <- ggplot() +
  geom_sf(data = tertiary_end, color = "grey50", size=0.15)+
  geom_sf(data=secondary_end, color="grey30", size=0.5)+
  geom_sf(data=primary_end, color="grey20", size=1) +
  
  theme_void()


ggsave("images/barcelona_clean.svg", p, dpi=300, width = 40, height = 50, units = "cm")
