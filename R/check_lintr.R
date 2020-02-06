#' @title The lintr check
#'
#' Runs lint from the \code{lintr} package.
#' @param readme Default \code{TRUE}. Should README.Rmd be checked
#' @param vignettes Default \code{TRUE}. Should the vignettes be linted.
#' @importFrom lintr lint_package lint_dir lint
#' @export
check_lintr = function(readme = TRUE, vignettes = TRUE) {
  set_crayon()
  msg_start("Checking lint...check_lintr()")

  if (!file.exists(".lintr")) {
    msg_info("No .lintr file found")
  }

  lints = lintr::lint_package()
  if (length(lints) > 0) {
    lapply(lints, print)
    msg_error("Please fix lints in R/", stop = TRUE)
  }
  msg_ok("R/ scripts OK")

  if (isTRUE(readme) && file.exists("README.Rmd")) {
    msg_start("Checking README.Rmd")
    re_lints = lintr::lint("README.Rmd")
    if (length(re_lints) > 0) {
      lapply(re_lints, print)
      msg_error("Please fix lints in the README.Rmd", stop = TRUE)
    }
    msg_ok("README.Rmd OK")
  }

  if (isTRUE(vignettes) && file.exists("vignettes")) {
    msg_start("Checking vignettes")
    vig_lints = lintr::lint_dir("vignettes", pattern = "*.Rmd")
    if (length(vig_lints) > 0) {
      lapply(vig_lints, print)
      msg_error("Please fix lints in vignettes/", stop = TRUE)
    }
    msg_ok("Vignettes OK")
  }
  msg_ok("Lint looks good")
  return(invisible(NULL))
}
