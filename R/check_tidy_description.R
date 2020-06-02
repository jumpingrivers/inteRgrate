check_version_format = function(description_path) {
  des = read.dcf(description_path)[1, ]
  version = des[names(des) == "Version"]
  check = stringr::str_detect(version, "^[0-9]*\\.[0-9]*\\.[0-9]*$") ||
    stringr::str_detect(version, "^[0-9]*\\.[0-9]*\\.[0-9]*\\.9[0-9]{3}$")
  if (isFALSE(check)) {
    msg_error("Version format is incorrect. Should be X.Y.Z or X.Y.Z.9ABC", stop = TRUE)
  }
  return(invisible(NULL))
}

#' Tidy description
#'
#' Checks for a tidy description file (via the \code{usethis} function
#' \code{use_tidy_description}). It also checks that the version numbers conform
#' to the tidy format - X.Y.Z or X.Y.Z.9ABC.
#' @inheritParams check_pkg
#' @export
check_tidy_description = function(path = NULL) {
  set_crayon()
  cli::cli_h3("Checking tidy descriptions...check_tidy_descriptions()")

  if (is.null(path)) path = get_build_dir()
  des_path = file.path(path, "DESCRIPTION")
  if (!file.exists(des_path)) msg_error("Missing DESCRIPTION file", stop = TRUE)
  check_version_format(des_path)

  r_old = readLines(des_path)
  #message("Read ", des_path, " - ", length(r_old))
  usethis::use_tidy_description()

  r_new = readLines(des_path)
  #message("Read ", des_path, " - ", length(r_new))

  if (length(r_old) == length(r_new) && all(r_old == r_new)) {
    cli::cli_alert_success("Your description is tidy!")
    return(invisible(NULL))
  }
  for (i in seq_along(r_old)) {
    if (is.na(r_new[i]) || r_old[i] != r_new[i]) {
      cli::cli_alert_warning(glue("  Current line {i}: {r_old[i]}"))
      cli::cli_alert_warning(glue("  Tidied line {i}: {r_new[i]}"))
    }
  }
  msg_error("Run usethis::use_tidy_description() before committing.", stop = TRUE)
}
