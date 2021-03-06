#' Render SQL query to extract resource from template
#'
#' @description
#'
#' @details
#'
#' @param
#'
#' @examples
#' \dontrun{
#' parse_sql("datapackage.json", "dm_favorecido")
#' }
#' @export
parse_sql <- function(datapackage_path, resource_name) {

    datapackage_path <- fs::path_expand(datapackage_path)

    datapackage <- frictionless$Package(datapackage_path)
    resource <- datapackage$get_resource(resource_name)


    fields <- paste0(resource$schema$field_names, collapse = ",\n")
    source <- resource$sources[[1]]$table
    has_particao <- (grepl("\\d{4}", resource_name) & !grepl("\\d{4}", resource$sources[[1]]$table))
    field_particao <- ifelse("ano_particao" %in% resource$schema$field_names, "ano_particao", "ano_exercicio")
    value_particao <- stringr::str_extract(resource_name, "\\d{4}$")
    if (has_particao) {
    particao <- list(field = field_particao,
                    value = value_particao)
    } else {
    particao <- has_particao
    }

    filtro <- ifelse(resource_name == "dm_empenho_desp_compras_empenho", "fl_compras_empenho",
                     ifelse(resource_name == "dm_empenho_desp_diarias_scdp_liqpag", "ft_diarias_scdp_liqpag", FALSE))


    resource_params <- list(fields = fields,
                            source = source,
                            particao = particao,
                            filtro = filtro)

    if(grepl("dm_contratado", resource_name)) {
      sql_template_path <- "sql/dm_contratado.sql"
    } else {
      sql_template_path <- "sql/default.sql"
    }

    sql_template <- readLines(system.file(sql_template_path, package = "dtamg"))
    query <- whisker::whisker.render(sql_template, data = resource_params)

    query
}
