#' Reorder list elements
#'
#' @description
#' Reorder the elements of a named list by the given names
#'
#' @details
#' This function reorder the given named list by the given character vector
#' passed in `sort_order`.
#'
#' The elements that are present in the original list and not present in
#' `sort_order` are moved to the end of the list.
#'
#' @param x a named list.
#' @param sort_order a character vector with the elements new order.
#'
#' @return a list with the same elements but in a rearranged order.
#'
#' @examples
#' x <- list(a = 1, b = 2)
#' list_reorder(x, c("b", "a"))
#' list_reorder(x, c("b"))
#' list_reorder(x, c("c"))
#' @export
list_reorder <- function(x, sort_order) {
  result <- x[c(sort_order[which(sort_order %in% names(x))], names(x)[!names(x) %in% sort_order])]
  result
}
