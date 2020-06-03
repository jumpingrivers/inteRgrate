#' @title The lintr check
#'
#' Runs lint from the \code{lintr} package. Also scans for all
#' \code{.Rmd} and \code{.R} files in other directories.
#' @importFrom lintr lint_package lint_dir lint
#' @export
check_lintr = function() {
  cli::cli_h3("Checking lint...check_lintr()")
  lint_errors = FALSE

  if (!file.exists(".lintr")) {
    cli::cli_alert_info("No .lintr file found")
  }

  lints = lintr::lint_package()
  if (length(lints) > 0) {
    lapply(lints, print)
    lint_errors = TRUE
  }

  fnames = list.files(path = ".", pattern = "\\.(Rmd|R|r)$", recursive = TRUE)
  fnames = fnames[stringr::str_detect(fnames, pattern = "^R/", negate = TRUE)]
  for (fname in fnames) {
    r_lint = lintr::lint(fname)
    if (length(r_lint) > 0) {
      lapply(r_lint, print)
      lint_errors = TRUE
    }
  }

  if (isTRUE(lint_errors)) {
    msg_error("Please fix linting errors", stop = TRUE)
  }

  cli::cli_alert_success("Lint looks good")
  return(invisible(NULL))
}
