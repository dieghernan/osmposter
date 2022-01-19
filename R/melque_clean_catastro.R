rm(list = ls())

library(sf)
library(dplyr)
library(ggplot2)

# A. Get shapes----


building <- st_read("data/A.ES.SDGC.BU.40146.building.gml")
parc <- st_read("data/A.ES.SDGC.CP.40146.cadastralparcel.gml")
parc <- parc %>% arrange(areaValue)

bbox_init <- nominatimlite::bbox_to_poly(c(-4.478,41.046,-4.4610,41.057)) %>%
  st_transform(st_crs(parc))

bbox <- st_buffer(bbox_init, 40)
streets_all <- st_read("data/melque_all.geojson")
streets_lines <- streets_all[st_geometry_type(streets_all) %in% c(
  "LINESTRING",
  "MULTILINESTRING"
), ]

streets_lines <- st_transform(streets_lines, st_crs(parc))

unique(streets_lines$highway)

main_st <- streets_lines %>% filter(highway %in% c("primary", "tertiary"))
sec_st <- streets_lines %>% filter(highway %in% c("residential"))
third <- streets_lines %>% filter(!highway %in% c("primary", "tertiary", "residential"))
plot(third$geometry)

arroyo <- nominatimlite::geo_address_lookup_sf(c(260720320,
                                                 387883666,
                                                 387883667), 
                                               type = "W",
                                               points_only = FALSE)
# Une arroyo

coord1 <- st_coordinates(arroyo[1,])[, 1:2]
coord2 <- st_coordinates(arroyo[2,])[,1:2]
coord3 <- st_coordinates(arroyo[3,])[,1:2]
coord1_mod <- rbind(coord2[3,], coord1)
coord3_mod <- rbind(coord3, coord2[1, ])
coordend <- rbind(coord1_mod[rev(seq_len(nrow(coord1_mod))),], 
                  coord2, 
                  coord3_mod[rev(seq_len(nrow(coord3_mod))),]
)



newarroyo <-  st_linestring(coordend) %>% st_sfc(crs=st_crs(arroyo))


# Proyecto al mismo crs
common_crs <- st_crs(parc)
bbox <- st_transform(bbox, common_crs)
parc <- st_transform(parc, common_crs)
building <- st_transform(building, common_crs)
third <- st_transform(third, common_crs)
sec_st <- st_transform(sec_st, common_crs)
main_st <- st_transform(main_st, common_crs)


plot(bbox, col="red")
plot(parc$geometry, add=TRUE)

library(ggplot2)


ggplot() +
  geom_sf(data = parc, fill=NA, color="grey40") +
  # geom_sf(data = third, color = "grey60", size=0.5)+
  # geom_sf(data=sec_st, color="grey60", size=0.5)+
  # geom_sf(data=main_st, color="grey60", size=1.5) +
  geom_sf(data=building, fill="grey30", alpha =0.7, color="grey40")+
  coord_sf(
    xlim = st_bbox(bbox)[c(1, 3)],
    ylim = st_bbox(bbox)[c(2, 4)],
  ) +
  theme_void()



ggsave("images/melque_clean_catastro.svg", dpi = 300, width = 50, height = 40, units = "cm")
