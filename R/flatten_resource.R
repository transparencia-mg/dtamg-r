#' Flatten resource
#'
#' @description
#'
#' Performs several left joins following the foreign keys relations
#' specified in the table schema of the flattened resource.
#'
#' @details
#'
#' Starting from the resource `resource_name` several left joins are performed.
#'
#' Duplicate columns names are renamed for disambiguation.
#'
#' @param datapackage path to a datapackage.json file
#' @param resource_name base resource to flatten
#' @param join if NULL all foreign key relations are joined. Otherwise a
#' character vector specifying which resources should be joined.
#'
#' @examples
#' \dontrun{
#' flatten_resource('datapackage.json', resource_name = 'fact-table'))
#'
#' flatten_resource('datapackage.json',
#'                  resource_name = 'fact-table',
#'                  join = c('dim-a', 'dim-a')))
#' }
#' @export
flatten_resource <- function(datapackage, resource_name, join = NULL) {
  dp <- frictionless$Package(fs::path_expand(datapackage))
  resource <- dp$get_resource(resource_name)

  if(is.null(join)) {
    fk_resources <- get_fk_resources(resource)
  } else {
    fk_resources <- join
  }

  pk_names <- purrr::map_chr(resource$schema$foreignKeys, "fields")

  resources_field_names <- c(list(resource$schema$field_names),
                 purrr::map(fk_resources, ~ dp$get_resource(.x)$schema$field_names)) |>
              purrr::set_names(c(resource_name, fk_resources))


  resources_field_names_unique <- purrr::map(names(resources_field_names), ~ rename_dups_field_names(dp$get_resource(.x), resources_field_names, pk_names)) |>
    purrr::set_names(names(resources_field_names))

  resources_path <- purrr::map_chr(names(resources_field_names), ~ fs::path(dp$get_resource(.x)$basepath, dp$get_resource(.x)$path))

  dtl <- purrr::map(resources_path, data.table::fread, sep = ";" , dec = ",", colClasses = "character") |>
    purrr::set_names(names(resources_field_names))

  purrr::map2(dtl, resources_field_names_unique, data.table::setnames)

  result <- dtl[[resource$name]]
  for(x in fk_resources) {
    tmp <- dtl[[x]]

    pkey <- ifelse(is.character(dp$get_resource(x)$schema$primary_key),
                   dp$get_resource(x)$schema$primary_key,
                   dp$get_resource(x)$schema$primary_key$pop())

    result <- tmp[result, on = pkey]
  }

  result
}

rename_dups_field_names <- function(resource, resources_field_names, pk_names) {
  resources_field_names[[resource$name]] <- NULL

  field_names <- resource$schema$field_names
  all_names <- unique(unlist(resources_field_names))


  ifelse(field_names %in% all_names & (! field_names %in% pk_names),
         paste0(resource$name,".", field_names),
         field_names)

}
