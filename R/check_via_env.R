#' Run GITLAB checks via Environment variables
#'
#' Looks for environment variables and runs associated checks.
#' This allows you to set environment variables at a project level, e.g. Gitlab.
#' The default for all checks is \code{FALSE}.
#'
#' Current list of variables is
#' \describe{
#' \item{INTERGRATE_PKG}{check_pkg()}
#' \item{INTERGRATE_LINTR}{check_lintr()}
#' \item{INTERGRATE_NAMESPACE}{check_namespace()}
#' \item{INTERGRATE_R_FILENAMES}{check_r_filenames()}
#' \item{INTERGRATE_VERSION}{check_version()}
#' \item{INTERGRATE_GITIGNORE}{check_gitignore()}
#' \item{INTERGRATE_WINDOWS_ISSUES}{check_windows_issues()}
#' \item{INTERGRATE_TIDY_DESCRIPTION}{check_tidy_description()}
#' \item{INTERGRATE_README}{check_readme()}
#' }
#' @export
check_via_env = function() {
  if (Sys.getenv("INTERGRATE_PKG", "false") == "true") check_pkg()
  if (Sys.getenv("INTERGRATE_LINTR", "false") == "true") check_lintr()
  if (Sys.getenv("INTERGRATE_NAMESPACE", "false") == "true") check_namespace()
  if (Sys.getenv("INTERGRATE_R_FILENAMES", "false") == "true") check_r_filenames()
  if (Sys.getenv("INTERGRATE_VERSION", "false") == "true") check_version()
  if (Sys.getenv("INTERGRATE_GITIGNORE", "false") == "true") check_gitignore()
  if (Sys.getenv("INTERGRATE_WINDOWS_ISSUES", "false") == "true") check_windows_issues()
  if (Sys.getenv("INTERGRATE_TIDY_DESCRIPTION", "false") == "true") check_tidy_description()
  if (Sys.getenv("INTERGRATE_README", "false") == "true") check_readme()

  if (Sys.getenv("INTERGRATE_TAG", "false") == "true") create_tag()
  return(invisible(NULL))
}

check_all (pkg = F, lintr = F,
           namespace = F, r_filenames = F,
           version = F, gitignore = NULL,
           windows_issues = NULL, tidy_description = NULL,
           readme = NULL)

