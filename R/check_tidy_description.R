#' Tidy description
#'
#' Checks for a tidy description file (via the \code{usethis} function
#' \code{use_tidy_description}).
#' @inheritParams check_pkg
#' @export
check_tidy_description = function(path = NULL) {
  set_crayon()
  msg = glue("{symbol$circle_filled} Checking tidy descriptions")
  message(blue(msg))

  if (is.null(path)) path = get_build_dir()
  des_path = file.path(path, "DESCRIPTION")
  if (!file.exists(des_path)) stop("Missing DESCRIPTION file", call. = FALSE)

  r_old = readLines(des_path)
  #message("Read ", des_path, " - ", length(r_old))
  usethis::use_tidy_description()

  r_new = readLines(des_path)
  #message("Read ", des_path, " - ", length(r_new))

  if (length(r_old) == length(r_new) && all(r_old == r_new)) {
    msg = glue("{symbol$tick} Your description is tidy!")
    message(green(msg))
    return(invisible(NULL))
  }
  msg = glue("{symbol$cross} Run usethis::use_tidy_description() before committing.")
  message(red(msg))
  for (i in seq_along(r_old)) {
    if (is.na(r_new[i]) || r_old[i] != r_new[i]) {
      message(red(glue("Current line {i}: {r_old[i]}")))
      message(red(glue("Tidied line {i}: {r_new[i]}")))
    }
  }
  stop(call. = FALSE)
}
