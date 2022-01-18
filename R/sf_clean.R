rm(list = ls())

source("R/utils.R")

library(sf)
library(dplyr)
library(emojifont)
library(magick)

# 0. Params----
pdi = 90
outfile <- "sf_brown"


# A. Get shapes----

obj.lines <-
  poster_import("data/sf.lines.geojson") %>% poster_lines()

# B. Classify----

# Lines

primary <-
  obj.lines %>%
  filter(highway %in%  c("motorway", "primary", "motorway_link", "primary_link"))

# Add residential and service in small places
secondary <-
  obj.lines %>% filter(highway %in%  c("secondary",
                                       "tertiary",
                                       "secondary_link",
                                       "tertiary_link"))

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



# C. SVG file ----

svgout <-
  file.path("images", paste0(outfile, ".svg"))

bbox <- obj.lines

library(ggplot2)

p <- ggplot() +
  geom_sf(data = terciary, color = "grey50", size=0.15)+
  geom_sf(data=secondary, color="grey30", size=0.5)+
  geom_sf(data=primary, color="grey20", size=1) +
  
  theme_void()


ggsave("images/sf_clean.svg", p, dpi=300, width = 20, height = 25, units = "cm")
