


poster_import <- function(file) {
  obj <- sf::st_read(file, stringsAsFactors = FALSE)
  obj <- sf::st_transform(obj, 3857)
  return(obj)
}

poster_lines <- function(obj) {
  obj <-
    obj[sf::st_geometry_type(obj) %in% c("LINESTRING", "MULTILINESTRING"), ]
  return(obj)
}

poster_polys <- function(obj) {
  obj <-
    obj[sf::st_geometry_type(obj) %in% c("POLYGON", "MULTIPOLYGON"), ]
  return(obj)
}

poster_bbox <- function(obj) {
  class(obj) <- "bbox"
  obj <- sf::st_as_sfc(obj)
  obj <- sf::st_set_crs(obj, 4326)
  obj <- sf::st_transform(obj, 3857)
  return(obj)
  
}


poster_point <- function(obj) {
  obj <- sf::st_point(obj)
  obj <- sf::st_sfc(obj, crs = 4326)
  obj <- sf::st_transform(obj, 3857)
  return(obj)
}