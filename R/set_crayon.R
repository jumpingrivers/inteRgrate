#' @importFrom clisymbols symbol
#' @importFrom crayon red yellow blue green
set_crayon = function() {
  if (Sys.getenv("CRAYON") == "false") {
    options("crayon.enabled" = FALSE)
  } else {
    options("crayon.enabled" = TRUE)
  }
  return(invisible(NULL))
}
