#' Sets an Renviron variable
#'
#' Set an variable in the .Renviron file. Calls \code{readEnviron} to enable R
#' to use the variable in future function calls.
#' @param variable The variable name
#' @param value The value
#' @export
set_renviron_var = function(variable, value) {
  if (!is_github() && !is_gitlab()) {
    message("Not on CI, so not setting Renviron variable")
    return(invisible(NULL))
  }
  line = glue::glue("{variable}={value}")
  write(line, file = "~/.Renviron", append = TRUE)
  readRenviron("~/.Renviron")
  return(invisible(NULL))
}
