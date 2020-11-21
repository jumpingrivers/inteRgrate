# Unless the env_var is "false", the check will be called.
call_check = function(var, value, default = NULL) {

  if (is.null(value)) {
    env_var = toupper(paste0("INTERGRATE_", var))
    value = Sys.getenv(env_var, default) == "true"
  }
  if (isTRUE(value)) {
    if (var != "tag") {
      do.call(paste0("check_", var), list())
    } else {
      create_tag()
    }
  }
  return(invisible(NULL))
}

#' @title Run all checks
#' @description This function will run all checks within the package.
#' See the corresponding check functions for details. When \code{default = "true"}, all
#' checks will run unless the associated environment variable is \code{"false"}.
#' @param pkg Build and check package. See details for further information.
#' @param lintr,namespace,r_filenames,version,gitignore,readme,tidy_description
#' Default \code{NULL}.
#' @param file_permissions,line_breaks Windows related checks.
#' @param news Check the top line of NEWS.md
#' @param tag Default \code{NULL}. Create a tagged release.
#' @param default Default \code{FALSE}. The default value the environment variable
#' should take if missing.
#' @details The arguments for the function correspond to a particular check, e.g. check_ARGNAME().
#' By default, all arguments are \code{NULL} and hence run. However, a value of
#' \code{FALSE} or changing the corresponding environment variable
#' \code{INTERGRATE_ARGNAME} can turn off the check, e.g.\code{INTERGRATE_NAMESPACE}.
#'
#' On GitLab you can set environment variables at an organisation level.
#'
#' Note: As this package matures, this function will include the newer checks.
#' @export
check_via_env  = function(pkg = NULL, lintr = NULL,
                          namespace = NULL, r_filenames = NULL,
                          version = NULL, gitignore = NULL,
                          tidy_description = NULL, readme = NULL,
                          file_permissions = NULL, line_breaks = NULL,
                          tag = NULL, news = NULL, default = FALSE) {
  if (isTRUE(default)) default = "true"
  if (isFALSE(default)) default = "false"

  # Extract all arguments and values
  args = as.list(environment())
  arg_names = names(args)
  for (i in seq_along(args)) {
    call_check(arg_names[i], args[[i]], default = default)
  }

  return(invisible(NULL))
}
