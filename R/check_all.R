#' @title Run all checks
#' @description This function will run all checks within the package.
#' See the corresponding check functions for details.
#' @param pkg Build and check package. See details for further information.
#' @param lintr,namespace,r_filenames,version,gitignore,readme,tidy_description Checks
#' @param file_permissions,line_breaks Windows related checks.
#' @param news Check the top line of NEWS.md
#' @param rproj Runs check_rproj
#' @param tag Create a tagged release.
#' @details The arguments for the function correspond to a particular check, e.g. check_ARGNAME().
#' Note: As this package matures, this function will include the newer checks.
#' @export
check_all  = function(pkg = TRUE, lintr = TRUE,
                      namespace = TRUE, r_filenames = TRUE,
                      version = TRUE, gitignore = TRUE,
                      tidy_description = TRUE, readme = TRUE,
                      file_permissions = TRUE, line_breaks = TRUE,
                      tag = TRUE, news = TRUE,
                      rproj = TRUE) {
  .check$all = TRUE
  # Extract all arguments and values
  args = as.list(environment())
  arg_names = names(args)
  for (i in seq_along(args)) {
    call_check(arg_names[i], args[[i]])
  }

  if (isTRUE(.check$error)) {
    .check$error = FALSE # Reset for interactive
    msg_error("Issues Detected")
    stop("Please fix")
  }
  return(invisible(NULL))
}
