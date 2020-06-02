#' @title The lintr check
#'
#' Runs lint from the \code{lintr} package.
#' @param readme Default \code{TRUE}. Should README.Rmd be checked
#' @param vignettes Default \code{TRUE}. Should the vignettes be linted.
#' @importFrom lintr lint_package lint_dir lint
#' @export
check_lintr = function(readme = TRUE, vignettes = TRUE) {
  set_crayon()
  cli::cli_h3("Checking lint...check_lintr()")

  if (!file.exists(".lintr")) {
    cli::cli_alert_info("No .lintr file found")
  }

  lints = lintr::lint_package()
  if (length(lints) > 0) {
    lapply(lints, print)
    msg_error("Please fix lints in R/", stop = TRUE)
  }
  cli::cli_alert_success("R/ scripts OK")

  if (isTRUE(readme) && file.exists("README.Rmd")) {
    cli::cli_h3("Checking README.Rmd")
    re_lints = lintr::lint("README.Rmd")
    if (length(re_lints) > 0) {
      lapply(re_lints, print)
      msg_error("Please fix lints in the README.Rmd", stop = TRUE)
    }
    cli::cli_alert_success("README.Rmd OK")
  }

  if (isTRUE(vignettes) && file.exists("vignettes")) {
    cli::cli_h3("Checking vignettes")
    vig_lints = lintr::lint_dir("vignettes", pattern = "*.Rmd")
    if (length(vig_lints) > 0) {
      lapply(vig_lints, print)
      msg_error("Please fix lints in vignettes/", stop = TRUE)
    }
    cli::cli_alert_success("Vignettes OK")
  }
  cli::cli_alert_success("Lint looks good")
  return(invisible(NULL))
}
