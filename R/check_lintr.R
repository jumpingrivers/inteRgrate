#' @rdname check_pkg
#' @param readme Default \code{TRUE}. Should README.Rmd be checked
#' @param vignettes Default \code{TRUE}. Should the vignettes be linted.
#' @importFrom lintr lint_package lint_dir lint
#' @export
check_lintr = function(readme = TRUE, vignettes = TRUE) {
  set_crayon()
  msg = glue("{symbol$circle_filled} Checking lint...check_lintr()")
  message(blue(msg))

  if (!file.exists(".lintr")) {
    msg = glue::glue_col("{blue}{symbol$info} No .lintr file found")
    message(msg)
  }

  lints = lintr::lint_package()
  if (length(lints) > 0) {
    lapply(lints, print)
    msg = glue("{symbol$cross} Lintr failed")
    message(red(msg))
    stop(red("Please fix lints in R/"), call. = FALSE)
  }

  if (isTRUE(readme) && file.exists("README.Rmd")) {
    msg = glue("{symbol$circle_filled} Checking README.Rmd")
    message(blue(msg))
    re_lints = lintr::lint("README.Rmd")
    if (length(re_lints) > 0) {
      lapply(re_lints, print)
      msg = glue("{symbol$cross} Lintr failed")
      message(red(msg))
      stop(red("Please fix lints in the README.Rmd"), call. = FALSE)
    }
  }

  if (isTRUE(vignettes) && file.exists("vignettes")) {
    msg = glue("{symbol$circle_filled} Checking vignettes")
    message(blue(msg))
    vig_lints = lintr::lint_dir("vignettes", pattern = "*.Rmd")
    if (length(vig_lints) > 0) {
      lapply(vig_lints, print)
      msg = glue("{symbol$cross} Lintr failed")
      message(red(msg))
      stop(red("Please fix lints in vignettes/"), call. = FALSE)
    }
  }

  msg = glue("{symbol$tick} Lint looks good")
  message(green(msg))
  return(invisible(NULL))
}
