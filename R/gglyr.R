#' @title Set gglyr library path
#'
#' @description Sets the gglyr library path to a local directory.
#'
#' @rdname gglyr_set_lib
#' @param lib_path Path to gglyr library
#' @return No value
#' @export
gglyr_set_lib <- function(lib_path) {
  # Check that path exists
  if (!(dir.exists(lib_path))) {
    stop('Input lib_path does not exist!')
  }
  # Set environment variable
  Sys.setenv(gglyr_lib_path = lib_path)
}

#' @title Retrieve gglyr library path
#'
#' @description Gets the currently set gglyr library path.
#'
#' @rdname gglyr_get_lib
#' @return Character path to gglyr library
#' @export
gglyr_get_lib <- function() {
  return(Sys.getenv('gglyr_lib_path'))
}

#' @title List layers in gglyr library
#'
#' @rdname gglyr_list_lyrs
#' @return Data.frame of layers
#' @export
gglyr_list_lyrs <- function() {
  lib_path <- gglyr_get_lib()
  lyrs <- gsub('.Rda', '', list.files(lib_path, pattern = '.Rda$'))
  t(t(lyrs))
}

#' @title Save gglyr
#'
#' @description Saves a ggproto object to the currently set gglyr library.
#'
#' @rdname gglyr_save
#' @param lyr ggproto or function object to save
#' @param name A name for the layer - this should be short, ideally snakecase,
#' and will be used in code to retrieve the layer.
#' @param comment A longer comment to be saved with the layer.
#' @param overwrite Overwrite current layer if it exists? Defaults to true.
#' @return No value
#' @export
gglyr_save <- function(lyr, name, comment, overwrite = T) {
  # TODO Check class of lyr
  # File path
  lib_path <- gglyr_get_lib()
  lyr_file <- file.path(lib_path, paste0(name, '.Rda'))
  if (file.exists(lyr_file)) {
    if (overwrite) {
      message('Layer already exists, overwriting...')
    } else {
      stop('Layer already exists and overwrite = FALSE.')
    }
  }
  # Save file
  save(lyr, comment, file = lyr_file)
}

#' @title Load gglyr
#'
#' @description Loads a ggproto object from the current library.
#'
#' @rdname gglyr
#' @param name Name of the layer to load.
#' @param verbose Defaults to false, if true the layer name and comment will be printed upon load.
#' @param ... Additional arguments to be passed if the ggproto is a function
#' @return ggproto object for use in ggplot2
#' @import glue
#' @export
gglyr <- function(name, verbose = F, ...) {
  # File path
  lib_path <- gglyr_get_lib()
  lyr_file <- file.path(lib_path, paste0(name, '.Rda'))
  # Check that it exists
  if (!(file.exists(lyr_file))) {
    stop(glue::glue('Requested layer file {name}.Rda does not exist in library'))
  }
  # Load lyr
  load(lyr_file)
  if (exists('lyr')) {
    if (verbose) {
      message(glue::glue('Loaded layer {name} with comment {comment}.'))
    }
    # If it is a function, execute it
    if (class(lyr) == 'function') {
      lyr <- do.call(lyr, args = list(...))
    }
    return(lyr)
  } else {
    stop(glue::glue('Layer {name} could not be loaded.'))
  }
}

#' @title Set ggplot extent to SF object
#'
#' @description Sets the extent of a ggplot to the extent of a given Simple Features object.
#'
#' @rdname gg_bound_sf
#' @param sf_lyr Simple Features layer to set extent.
#' @return coord_sf ggplot object
#' @importFrom sf st_bbox
#' @importFrom ggplot2 coord_sf
#' @export
gg_bound_sf <- function(sf_lyr) {
  bbox <- st_bbox(sf_lyr)
  p <- coord_sf(xlim = c(bbox['xmin'], bbox['xmax']),
                ylim = c(bbox['ymin'], bbox['ymax']))
  return(p)
}
