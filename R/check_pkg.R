#' @importFrom stringr str_detect str_trim str_split
get_env_variable = function(env_variable, default = NULL) {
  if (is_gitlab() || is_github()) {
    var = as.numeric(Sys.getenv("env_variable", default))
  } else if (file.exists(".gitlab-ci.yml")) {
    var = get_gitlab_env_var(env_variable, default)
  } else if (file.exists(".travis.yml")) {
    var = get_github_env_var(env_variable, default)
  } else {
    var = 0
  }
  return(var)
}


#' Check R package
#'
#' Path is the CI project directory or \code{.}.
#' @param path Default \code{.} The location of the package
#' @param build Default \code{TRUE}. Call build_pkg() before checking.
#' @param install Default \code{TRUE}. Call install_pkg() after checking
#' @importFrom glue glue
#' @importFrom devtools check_built
#' @export
check_pkg = function(path = NULL,
                     build = TRUE,
                     install = TRUE) {
  set_crayon()
  if (is.null(path)) path = get_build_dir()
  if (isTRUE(build)) {
    pkg_tar_ball = build_pkg(path)
  } else {
    pkg_tar_ball = get_pkg_tar_ball()
  }
  check_output = devtools::check_built(path = pkg_tar_ball, cran = TRUE,
                                       force_suggests = TRUE, run_dont_test = FALSE,
                                       manual = FALSE, args = "--timings", env_vars = NULL,
                                       quiet = FALSE, error_on = "error")

  allowed_notes = get_env_variable("ALLOWED_NOTES", 0)
  allowed_warnings = get_env_variable("ALLOWED_WARNINGS", 0)

  no_of_warnings = length(check_output$warnings)
  for (i in seq_len(no_of_warnings)) {
    msg = glue("{symbol$info} Warning {i} of {no_of_warnings} ({allowed_warnings} allowed)")
    message(blue(msg))
    message(check_output$warnings[i], "\n")
  }

  no_of_notes = length(check_output$notes)
  for (i in seq_len(no_of_notes)) {
    msg = glue("{symbol$info} Note {i} of {no_of_notes} ({allowed_notes} allowed)")
    message(blue(msg))
    message(check_output$notes[i], "\n")
  }

  if (no_of_warnings > allowed_warnings || no_of_notes > allowed_notes) {
    stop("You have too many warnings and/or notes", call. = FALSE)
  }

  if (isTRUE(install)) install_pkg(path)
  return(invisible(NULL))
}
