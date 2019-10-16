#' @importFrom clisymbols symbol
#' @importFrom crayon red yellow blue green
set_crayon = function() {
  if (!is_gitlab() || !is_github()) {
    return(invisible(NULL))
  }
  if (Sys.getenv("CRAYON") == "false") {
    options("crayon.enabled" = FALSE)
  } else {
    options("crayon.enabled" = TRUE)
  }
  return(invisible(NULL))
}
