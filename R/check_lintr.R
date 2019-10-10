#' @rdname check_pkg
#' @importFrom lintr lint_package
#' @export
check_lintr = function() {
  set_crayon()
  if (!file.exists(".lintr")) {
    stop("Please create a .lintr file", call. = FALSE)
  }
  msg = glue("{symbol$circle_filled} Checking lint...check_lintr()")
  message(blue(msg))

  lints = lintr::lint_package()
  if (length(lints) > 0) {
    lapply(lints, print)
    msg = glue("{symbol$cross} Lintr failed")
    message(red(msg))
    stop(red("Please fix lints"), call. = FALSE)
  }
  msg = glue("{symbol$tick} Lint looks good")
  message(green(msg))
  return(invisible(NULL))
}
