rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
watercol <- "grey90"
pdi = 90
outfile <- "edinburgh_clean"
bbox <- poster_bbox(c(-3.233100, 55.926318, -3.143836, 55.987229))
icon <- poster_point(c( -3.1857049,55.9633722)) %>% st_coordinates()

# A. Get shapes----

obj.lines <-
  poster_import("data/ed.lines.geojson") %>% poster_lines() 
obj.water <-
  poster_import("data/ed.wet.geojson")

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



p <- ggplot() +
  geom_sf(data = terciary, color = "grey50", size=0.15)+
  geom_sf(data=secondary, color="grey30", size=0.5)+
  geom_sf(data=primary, color="grey20", size=1) +
  
  theme_void()


ggsave("images/edimburgo_clean.svg", p, dpi=300, width = 40, height = 50, units = "cm")



# 
# # Others - Specific
# 
# waterlines <- obj.water %>% poster_lines()
# waterbody <- obj.water %>% poster_polys()
# 
# 
# 
# 
# # C. SVG file ----
# 
# svgout <- file.path("images", paste0(outfile, ".svg"))
# 
# 
# 
# svg(
#   svgout,
#   pointsize = pdi,
#   width =  2970 / pdi,
#   height = 4200 / pdi
# )
# par(mar = c(0, 0, 0, 0))
# plot_sf(bbox)
# plot(
#   st_geometry(waterlines),
#   add = TRUE,
#   col = watercol,
#   border = watercol,
#   lwd = 12
# )
# 
# plot(
#   st_geometry(waterbody),
#   add = TRUE,
#   col = watercol,
#   border = NA
# )
# 
# plot(st_geometry(terciary),
#      col = "grey50",
#      add = TRUE,
#      lwd = 0.75)
# plot(st_geometry(secondary),
#      col = "grey30",
#      add = TRUE,
#      lwd = 2.5)
# plot(st_geometry(primary),
#      col = "grey20",
#      add = TRUE,
#      lwd = 3.5)
# 
# text(
#   x = icon[1],
#   y = icon[2],
#   labels = fontawesome("fa-home"),
#   cex = 0.7,
#   col = 'black',
#   family = 'fontawesome-webfont'
#   )
# 
# dev.off()
# 
# # Convert to png
# 
# pnggout <- file.path("images", paste0(outfile, ".png"))
# my_image <- image_read(svgout)
# my_svg <- image_convert(my_image, format = "png")
# image_write(my_svg, pnggout)
# 
# 
# # D. JPEG file ----
# 
# jpegout <- file.path("images", paste0(outfile, ".jpeg"))
# 
# 
# 
# jpeg(jpegout,
#      res = 300,
#      width =  2970 ,
#      height = 4200)
# par(mar = c(0, 0, 0, 0))
# plot_sf(bbox)
# plot(
#   st_geometry(waterlines),
#   add = TRUE,
#   col = watercol,
#   border = watercol,
#   lwd = 12
# )
# 
# plot(
#   st_geometry(waterbody),
#   add = TRUE,
#   col = watercol,
#   border = NA
# )
# 
# plot(st_geometry(terciary),
#      col = "grey50",
#      add = TRUE,
#      lwd = 0.75)
# plot(st_geometry(secondary),
#      col = "grey30",
#      add = TRUE,
#      lwd = 2.5)
# plot(st_geometry(primary),
#      col = "grey20",
#      add = TRUE,
#      lwd = 3.5)
# 
# text(
#   x = icon[1],
#   y = icon[2],
#   labels = fontawesome("fa-home"),
#   cex = 7,
#   col = 'black',
#   family = 'fontawesome-webfont'
# )
# 
# dev.off()
