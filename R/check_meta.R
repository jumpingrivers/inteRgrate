check_readme = function() {
  msg_start("Checking meta...check_meta()")
  if (file.exists("README.Rmd")) {
    msg_start("Checking README.Rmd timestamps")
    if (file.info("README.Rmd")$ctime > file.info("README.md")$ctime) {
      msg_error("README.md appears to be out of date", stop = TRUE)
    }
    msg_ok("README OK")
  }
  return(invisible(NULL))
}

check_gitignore = function() {
  msg_start("Checking .gitignore...check_meta()")
  ## Get ignores and remove ignored files
  ignores = readLines(".gitignore")
  ignores = ignores[stringr::str_detect(ignores, pattern = "^#", negate = TRUE)]
  ignores = ignores[nchar(ignores) > 0L]

  ## This is a hack to get rid of brackets in some reg ex,
  ## .e.g *.synctex(busy)
  ignores = ignores[!stringr::str_detect(ignores, pattern = "\\(|\\)")]

  list_ignores = sapply(glob2rx(ignores, trim.head = FALSE, trim.tail = FALSE),
                        function(ignore) stringr::str_detect(git_global_ignore, ignore))

  mat_ignores = matrix(list_ignores, ncol = length(git_global_ignore), byrow = TRUE)

  ignore_files = apply(mat_ignores, 2, any)
  missing_ignores = git_global_ignore[!ignore_files]
  if (length(missing_ignores) != 0L) {
    for (ignore in missing_ignores) {
      msg_error(paste("Missing", ignore, " from .gitignore"))
    }
    msg_error("Copying github.com/github/gitignore/blob/master/R.gitignore is a good start.")
    msg_error("Please update your .gitignore", stop = TRUE)
  }
  return(invisible(NULL))
}
#' Checks Meta files
#'
#' Checks for a tidy description file (via the \code{usethis} function
#' \code{use_tidy_description}). It also checks that the version numbers conform
#' to the tidy format - X.Y.Z or X.Y.Z.9ABC, if the README is up to date, and
#' if .gitignore contains sensible values.
#' @export
#' @importFrom utils glob2rx
check_meta = function() {
  set_crayon()
  check_tidy_description()
  check_readme()
  check_gitignore()

  msg_ok("Meta files look good")
  return(invisible(NULL))
}
