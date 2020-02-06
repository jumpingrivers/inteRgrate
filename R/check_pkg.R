#' Check R package
#'
#' Path is the CI project directory or \code{.}.
#' @param path Default \code{.} The location of the package
#' @param build Default TRUE. Should the .tar.gz file be built and kept
#' @param install Default \code{TRUE}. Call install_pkg() after checking
#' @importFrom glue glue glue_col
#' @importFrom devtools check_built
#' @export
check_pkg = function(path = NULL,
                     build = TRUE,
                     install = TRUE) {
  set_crayon()
  if (is.null(path)) path = get_build_dir()

  ## Install package dependencies
  install_deps(path)
  check_output = devtools::check(pkg = path, cran = TRUE,
                                       force_suggests = TRUE, run_dont_test = FALSE,
                                       manual = FALSE, args = "--timings", env_vars = NULL,
                                       quiet = FALSE, error_on = "error")

  allowed_notes = get_env_variable("ALLOWED_NOTES", 0)
  allowed_warnings = get_env_variable("ALLOWED_WARNINGS", 0)

  no_of_warnings = length(check_output$warnings)
  for (i in seq_len(no_of_warnings)) {
    msg = glue("Warning {i} of {no_of_warnings} ({allowed_warnings} allowed)")
    msg_info(msg)
    msg_info(check_output$warnings[i])
  }

  no_of_notes = length(check_output$notes)
  for (i in seq_len(no_of_notes)) {
    msg = glue("Note {i} of {no_of_notes} ({allowed_notes} allowed)")
    msg_info(msg)
    msg_info(check_output$notes[i])
  }

  if (no_of_warnings > allowed_warnings || no_of_notes > allowed_notes) {
    msg_error("You have too many warnings and/or notes", stop = TRUE)
  }

  if (isTRUE(build)) build_pkg(path)
  if (isTRUE(install)) install_pkg(path)
  return(invisible(NULL))
}