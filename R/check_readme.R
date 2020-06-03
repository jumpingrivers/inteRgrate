#' @title Check the README.Rmd
#'
#' @description If README.Rmd exists, the timestamp will be compared to README.md.
#' An error will be raised if README.md is a newer file.
#' @export
#' @examples
#' check_readme()
check_readme = function() {
  if (!file.exists("README.Rmd")) return(invisible(NULL))

  cli::cli_h3("Checking README.Rmd...check_readme()")
  if (file.info("README.Rmd")$ctime > file.info("README.md")$ctime) {
    msg_error("README.md appears to be out of date", stop = TRUE)
  }
  cli::cli_alert_success("README timestamps OK")
  return(invisible(NULL))
}
