lint_files = function() {
  lint_errors = FALSE
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

  return(lint_errors)
}

#' @title The lintr check
#'
#' @description Runs lint from the \code{lintr} package. Also scans for all
#' \code{.Rmd} and \code{.R} files in other directories.
#' @inheritParams check_pkg
#' @importFrom lintr lint_package lint_dir lint
#' @export
check_lintr = function(path = ".") {
  cli::cli_h3("Checking lint...check_lintr()")
  op = setwd(path)
  on.exit(setwd(op))

  if (!file.exists(".lintr")) {
    cli::cli_alert_info("No .lintr file found")
  }

  lint_errors = lint_files()
  # Ensure files end with newlines
  rfiles = list.files("R", full.names = TRUE)
  lapply(rfiles, readLines) #Uses inteRgrate readlines

  if (isTRUE(lint_errors)) {
    msg_error("Please fix linting errors", stop = TRUE)
  }

  cli::cli_alert_success("Lint looks good")
  return(invisible(NULL))
}
