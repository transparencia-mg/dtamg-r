#' Extract subset of data package resources
#'
#' @description
#' Create a new data package from a subset of the resources of a larger
#' data package.
#'
#' @details
#' The resources included are all the explicit listed in the `resource_names`
#' argument plus the resources referenced in the foreign keys constraints
#' of the explicit listed resources, even if they themselves are not listed.
#'
#' The only copied files aside from `datapackage.json` from the source data package
#' are the ones that appear in the `resource.path` property of each resource.
#'
#' External table schema and dialect are dereferenced before the creation of
#' the target `datapackage.json` but the external files are not copied.
#'
#' `dir` need not to exist beforehand and all existing files will be overwritten.
#'
#' @param path path to source data package datapackage.json file
#' @param resource_names resources to extract
#' @param dir folder to save the new data package
#' @param ... root level data package properties that should be replaced or added
#'
#' @examples
#' \dontrun{
#' extract_datapackage("datapackage.json",
#'                     dir = "~/my-package/",
#'                     resource_names = c("ft_convenio", "dm_tempo_anual"),
#'                     name = "convenio-entrada",
#'                     title = "Convênios de Entrada",
#'                     version = "0.1.0",
#'                     homepage = "https://example.com")
#' }
#' @export
extract_datapackage <- function(path, dir, resource_names, ...) {

  # expanding so that ~/path/to/folder is a valid argument for both path and dir
  path <- fs::path_expand(path)
  dir <- fs::path_expand(dir)

  stopifnot(fs::file_exists(path))

  package <- frictionless$Package(path)

  if(!all(resource_names %in% package$resource_names)) {
    x <- glue::glue_collapse(resource_names[!resource_names %in% package$resource_names],
                             ", ",
                             last = " and ")
    msg <- glue::glue("Resource(s) {x} are not present in {path}")
    stop(msg)
  }

  resource_names_fk <- unlist(purrr::map(resource_names,
                                         ~ get_fk_resources(package$get_resource(.x))))

  resource_names_full <- unique(c(resource_names, resource_names_fk))

  resources_rm <- package$resource_names[!package$resource_names %in% resource_names_full]
  purrr::map(resources_rm, ~ package$remove_resource(.x))

  dots <- list(...)
  if(length(dots) > 0) {
    package$update(dots)
  }

  for(resource_name in package$resource_names) {
    package$get_resource(resource_name)$schema$expand()
    package$get_resource(resource_name)$dialect$expand()
  }

  resources_filepath <- purrr::map_chr(package$resource_names, ~ package$get_resource(.x)$path)

  # ensure that dir exists; if it already exists it will be left unchanged
  purrr::walk(fs::path(dir, resources_filepath),
              fs::dir_create)

  purrr::walk2(fs::path(fs::path_dir(path), resources_filepath),
               fs::path(dir, resources_filepath),
               fs::file_copy,
               overwrite = TRUE)

  datapackage_filepath <- fs::path(dir, 'datapackage.json')

  package$to_json(datapackage_filepath)
}


get_fk_resources <- function(resource) {

  purrr::map_chr(resource$schema$get("foreignKeys"), c("reference", "resource"))

}



