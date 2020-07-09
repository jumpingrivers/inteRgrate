#' @title Check the README.Rmd
#'
#' @description If README.Rmd exists, the timestamp will be compared to README.md.
#' An error will be raised if README.md is a newer file.
#' @inheritParams check_pkg
#' @export
#' @examples
#' check_readme()
check_readme = function(path = ".") {
  readme_rmd = file.path(path, "README.Rmd")
  readme_md = file.path(path, "README.md")
  if (!file.exists(readme_rmd)) return(invisible(NULL))

  cli::cli_h3("Checking README.Rmd...check_readme()")
  if (file.info(readme_rmd)$ctime > file.info(readme_md)$ctime) {
    msg_error("README.md appears to be out of date", stop = TRUE)
  }
  cli::cli_alert_success("README timestamps OK")
  return(invisible(NULL))
}
