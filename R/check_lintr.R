get_exclusions = function() {
  if (!file.exists(".lintr")) return(c("^R/|^cache/|^packrat/|^renv/"))

  exclusions = read.dcf(".lintr", all = TRUE)$exclusions

  if (is.null(exclusions)) return(c("^R/|^cache/|^packrat/|^renv/"))
  exclusions = stringr::str_split(exclusions, ",")[[1]]
  exclusions = stringr::str_remove(exclusions, "list\\W?\\(")
  exclusions = stringr::str_remove(exclusions, "\\)$")
  exclusions = stringr::str_squish(exclusions)
  exclusions = stringr::str_remove_all(exclusions, ("^\"|\"$"))

  ## Convert to regular expression
  pattern = paste0(c(exclusions, "^R/", "^cache/", "^packrat/", "^renv/"), collapse = "|")
  return(pattern)
}

lint_files = function() {
  lint_errors = FALSE
  lints = lintr::lint_package(exclusions = list("R/RcppExports.R", "renv", "packrat", "cache"))
  if (length(lints) > 0) {
    lapply(lints, print)
    lint_errors = TRUE
  }

  fnames = list.files(path = ".", pattern = "\\.(Rmd|R|r)$", recursive = TRUE)
  pattern = get_exclusions()
  fnames = fnames[stringr::str_detect(fnames, pattern = pattern, negate = TRUE)]
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
  rfiles = list.files("R", full.names = TRUE, pattern = "\\.(R|r)$")
  lapply(rfiles, readLines) #Uses inteRgrate readlines

  if (isTRUE(lint_errors)) {
    msg_error("Please fix linting errors")
  } else {
    cli::cli_alert_success("Lint looks good")
  }
  return(invisible(NULL))
}
