#' @import data.table
# global reference to frictionless (will be initialized in .onLoad)
# for details see
# https://rstudio.github.io/reticulate/articles/package.html#delay-loading-python-modules
frictionless <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to frictionless
  frictionless <<- reticulate::import("frictionless", delay_load = TRUE)
}

# convenience install of frictionless package in r-reticulate conda environment
# for details see
# https://rstudio.github.io/reticulate/articles/package.html#installing-python-dependencies
install_frictionless <- function(method = "conda", conda = "auto") {
  reticulate::py_install("frictionless", method = method, conda = conda)
}
