#' Check R/ filenames
#'
#' Checks that all filenames in the directory \code{R/}
#' are lower case and the file extension matches .\code{extension}
#' @param extension Preferred R file extension. Default \code{R}.
#' @inheritParams check_pkg
#' @export
#' @examples
#' check_r_filenames()
check_r_filenames = function(extension = "R", path = "R") {
  cli::cli_h3("Checking file extensions...check_r_filenames()")

  fnames = list.files(path, full.names = TRUE, pattern = "(\\.R|\\.r)$")
  ext = substr(fnames, nchar(fnames) - length(extension), nchar(fnames))
  if (!all(ext == paste0(".", extension))) {
    msg_error(paste("File extension for R files should be", extension), stop = TRUE)
  }
  cli::cli_alert_info("{length(fnames)} R files found")
  cli::cli_alert_success("Extensions look good")
  fnames = list.files(path, pattern = "(\\.R|\\.r)$")
  # Remove extension
  fnames = substr(fnames, 0, nchar(fnames) - 1 - length(extension))
  if (!all(fnames == tolower(fnames))) {
    msg_error("File names should be lower case", stop = TRUE)
  }

  cli::cli_alert_success("Filenames look good")
  return(invisible(NULL))
}
