#' Check R package
#'
#' Path is the CI project directory or \code{.}.
#' Installs and checks the R package. The number of notes
#' and warnings is specified by enviromental variables.
#' Default number of Notes/Warnings is 0.
#' @param path Location of the package
#' @importFrom glue glue glue_col
#' @importFrom rcmdcheck rcmdcheck check_details
#' @importFrom remotes install_deps
#' @importFrom utils packageVersion
#' @export
check_pkg = function(path = ".") {
  cli::cli_h1(paste("inteRgrate version", packageVersion("inteRgrate")))

  ## Install package dependencies
  cli::cli_h2("Installing package")
  remotes::install_deps(path, dependencies = TRUE, upgrade = "never")
  remotes::install_local(path, upgrade = "never", build_vignettes = TRUE, force = TRUE)

  check_output = rcmdcheck::rcmdcheck(path = ".",
                                      args = c("--timings"), # Add option for as--cran?
                                      error_on = "error")
  check_output = rcmdcheck::check_details(check_output)

  allowed_notes = get_env_variable("ALLOWED_NOTES", 0)
  allowed_warnings = get_env_variable("ALLOWED_WARNINGS", 0)

  no_of_warnings = length(check_output$warnings)
  for (i in seq_len(no_of_warnings)) {
    msg = glue("Warning {i} of {no_of_warnings} ({allowed_warnings} allowed)")
    cli::cli_alert_info(msg)
    cli::cli_alert_info(check_output$warnings[i])
  }

  no_of_notes = length(check_output$notes)
  for (i in seq_len(no_of_notes)) {
    msg = glue("Note {i} of {no_of_notes} ({allowed_notes} allowed)")
    cli::cli_alert_info(msg)
    cli::cli_alert_info(check_output$notes[i])
  }

  if (no_of_warnings > allowed_warnings || no_of_notes > allowed_notes) {
    msg_error("You have too many WARNINGS and/or NOTES")
  }
  return(invisible(NULL))
}
