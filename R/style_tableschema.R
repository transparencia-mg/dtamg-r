#' Style a yaml table schema
#'
#' @description
#' Reorder the properties of a [table schema](https://specs.frictionlessdata.io/table-schema/)
#' serialized as [yaml](https://yaml.org/) overwriting the given file.
#'
#' @details
#' The original file is overwritten without user confirmation.
#'
#' @param input yaml file with a table schema.
#' @param output output file to store reordered table schema
#'
#' @examples
#' \dontrun{style_tableschema('schemas/schema.yaml')}
#' @export
style_tableschema <- function(input, output) {
  x <- yaml::yaml.load_file(input, handlers = list(seq = function(x) x))

  tableschema_sort_order <- c("fields",
                              "missingValues",
                              "primaryKey",
                              "foreignKeys")

  result <- list_reorder(x, tableschema_sort_order)

  field_sort_order <- c("name",
                        "title",
                        "description",
                        "notes",
                        "type",
                        "format",
                        "bareNumber",
                        "decimalChar",
                        "groupChar",
                        "trueValues",
                        "falseValues",
                        "missingValues",
                        "constraints")

  result[["fields"]] <- lapply(result[["fields"]], list_reorder, field_sort_order)

  yaml::write_yaml(result,
                   output,
                   indent.mapping.sequence = TRUE,
                   handlers = list(logical = as_bool))

}



as_bool <- function(x) {
  result <- ifelse(x, "true", "false")
  class(result) <- "verbatim"
  return(result)
}
