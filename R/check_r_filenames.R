#' Check R/ filenames
#'
#' Checks that all filenames are lower case and the file extension matches
#' .\code{extension}
#' @param extension Preferred R file extension. Default \code{R}.
#' @export
check_r_filenames = function(extension = "R") {
  set_crayon()
  msg_start("Checking file extensions...check_r_filenames()")

  fnames = list.files("R/", full.names = TRUE)
  ext = substr(fnames, nchar(fnames) - length(extension), nchar(fnames))
  if (!all(ext == paste0(".", extension))) {
    msg_error(paste("File extension for R files should be", extension), stop = TRUE)
  }
  msg_ok("Extensions look good")
  msg_start("Checking file names")

  fnames = list.files("R")
  # Remove extension
  fnames = substr(fnames, 0, nchar(fnames) - 1 - length(extension))
  if (!all(fnames == tolower(fnames))) {
    msg_error("File names should be lower case", stop = TRUE)
  }

  msg_ok("Filenames look good")
  return(invisible(NULL))
}
