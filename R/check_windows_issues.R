globalVariables("fname")
#' Detects standard Windows related issues
#'
#' This check tests for windows line breaks and file permissions. It ensures
#' that the file is not executable (txt|md|Rmd|yml|json|).
#' @param repo_files By default, we use git to determine the files in the repo. By a
#' vector of files can be passed instead.
#' @export
#' @examples
#' check_file_permissions()
check_file_permissions = function(repo_files = NULL) {
  cli::cli_h3("Checking file permissions...check_file_permissions()")

  # Get all repos files
  if (is.null(repo_files)) {
    repo_files = system2("git",
                         args = c("ls-tree", "--full-tree", "-r", "--name-only", "HEAD"),
                         stdout = TRUE)
  }
  # Remove deleted files
  repo_files = repo_files[file.exists(repo_files)]
  # Grab the permissions and split
  modes = file.info(repo_files, extra_cols = FALSE)[, "mode"]
  modes_list = stringr::str_split(modes, pattern = "")

  # Check for executables
  is_executable = unlist(lapply(modes_list, function(i) any(as.numeric(i) %% 2 != 0)))

  # Only look for certain executable files
  file_type = str_detect(repo_files, pattern = ".*\\.(txt|md|Rmd|yml|json|R|r)$")
  is_executable = is_executable & file_type

  if (!any(is_executable)) {
    cli::cli_alert_success("File modes looks good")
    return(invisible(NULL))
  }

  executable = repo_files[is_executable]
  msg_error("The following files are executable")
  for (i in seq_along(executable)) {
    fname = normalizePath(executable[i])
    msg_error(glue::glue("File {i} of {length(executable)}: {fname}"))
  }
  stop(call. = FALSE)
}

check_line_breaks = function(repo_files = NULL) {
  cli::cli_h3("Checking line breaks...check_line_breaks()")
  if (is.null(repo_files)) {
    repo_files = system2("git",
                         args = c("ls-tree", "--full-tree", "-r", "--name-only", "HEAD"),
                         stdout = TRUE)
  }
  # Remove deleted files
  repo_files = repo_files[file.exists(repo_files)]
  line_breaks = vapply(repo_files,
                       function(fname) system2("grep", args = c("--binary-files=without-match",
                                                                "-Um1", "$'\015'", fname)),
                       FUN.VALUE = integer(1))
  line_breaks = names(line_breaks[line_breaks == 0])
  if (length(line_breaks) == 0L) {
    cli::cli_alert_success("Line breaks look good")
    return(invisible(NULL))
  }
  msg_error("The following files have Windows line breaks")
  for (i in seq_along(line_breaks)) {
    fname = normalizePath(line_breaks[i])
    msg_error(glue::glue("File {i} of {length(line_breaks)}: {fname}"))
  }
  stop(call. = FALSE)
}
