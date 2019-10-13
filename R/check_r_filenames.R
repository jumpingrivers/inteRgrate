#' Check R/ filenames
#'
#' Checks that all filenames are lower case and the file extension matches
#' .\code{extension}
#' @param extension Preferred R file extension. Default \code{R}.
#' @export
check_r_filenames = function(extension = "R") {
  set_crayon()
  msg = glue("{symbol$circle_filled} Checking file extensions...check_r_filenames()")
  message(blue(msg))

  fnames = list.files("R/", full.names = TRUE)
  ext = substr(fnames, nchar(fnames) - length(extension), nchar(fnames))
  if (!all(ext == paste0(".", extension))) {
    msg = glue("{symbol$cross} File extension for R files should be .{extension}")
    message(red(msg))
    stop(call. = FALSE)
  }
  msg = glue("{symbol$tick} Extensions look good")
  message(green(msg))

  msg = glue("{symbol$circle_filled} Checking file names")
  message(blue(msg))

  fnames = list.files("R")
  # Remove extension
  fnames = substr(fnames, 0, nchar(fnames) - 1 - length(extension))
  if (!all(fnames == tolower(fnames))) {
    msg = glue("{symbol$cross} File names should be lower case")
    message(red(msg))
    stop(call. = FALSE)
  }

  msg = glue("{symbol$tick} Filenames look good")
  message(green(msg))
  return(invisible(NULL))
}
