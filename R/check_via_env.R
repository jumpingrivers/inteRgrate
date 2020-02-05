#' @title Run GITLAB checks via Environment variables
#'
#' Looks for environment variables and runs associated checks.
#' This allows you to set environment variables at a project level, e.g. Gitlab.
#' @export
check_via_env = function() {
  if (Sys.getenv("INTERGRATE_PKG", "false") == "true") check_pkg()
  if (Sys.getenv("INTERGRATE_R_FILENAMES", "false") == "true") check_r_filenames()
  if (Sys.getenv("INTERGRATE_TIDY_DESCRIPTION", "false") == "true") check_tidy_description()
  if (Sys.getenv("INTERGRATE_LINTR", "false") == "true") check_lintr()
  if (Sys.getenv("INTERGRATE_NAMESPACE", "false") == "true") check_namespace()
  if (Sys.getenv("INTERGRATE_VERSION", "false") == "true") check_version()
  if (Sys.getenv("INTERGRATE_TAG", "false") == "true") create_tag()
  return(invisible(NULL))
}
