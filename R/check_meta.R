#' @importFrom utils glob2rx
check_meta = function() {
  set_crayon()
  msg_start("Checking meta...check_meta()")
  if (file.exists("README.Rmd")) {
    msg_start("Checking README")
    if (file.info("README.Rmd")$ctime < file.info("README.md")$ctime) {
      msg_error("README.md appears to be out of date", stop = TRUE)
    }
    msg_ok("README OK")
  }

  msg_start("Checking gitignore")
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
      msg_error(paste("Missing", ignore, " from .gitignores"))
    }
    msg_error("Please update your .gitignore")
    msg_error("Copying github.com/github/gitignore/blob/master/R.gitignore is a good start.",
              stop = TRUE)
  }

  msg_ok()

}
