# Unless the env_var is "false", the check will be called.
call_check = function(var, value) {

  if (is.null(value)) {
    env_var = toupper(paste0("INTERGRATE_", var))
    value = Sys.getenv(env_var, "true") == "true"
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
#' See the corresponding check functions for details.
#' @param pkg,lintr,namespace,r_filenames,version,gitignore,windows_issues,readme,tidy_description
#' Default \code{NULL}. See details for further information.
#' @param tag Default \code{NULL}. Create a tagged release.
#' @details The arguments
#' for the function correspond to a particular check, e.g. check_ARGNAME(). By
#' default, all arguments are \code{NULL} and hence run. However, a value of
#' \code{FALSE} or changing the corresponding environment variable
#' \code{INTERGRATE_ARGNAME} can turn off the check.
#'
#' Note: As this package matures, this function will include the newer checks.
#' @export
check_all = function(pkg = NULL, lintr = NULL,
                     namespace = NULL, r_filenames = NULL,
                     version = NULL, gitignore = NULL,
                     windows_issues = NULL, tidy_description = NULL,
                     readme = NULL,
                     tag = NULL) {
  # Extract all arguments and values
  args = as.list(environment())
  arg_names = names(args)
  for (i in seq_along(args)) {
    call_check(arg_names[i], args[[i]])
  }

  return(invisible(NULL))
}
