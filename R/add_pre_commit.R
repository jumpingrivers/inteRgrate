#' @export
add_pre_commit = function() {
  fname = file.path(system.file("templates", package = "inteRgrate"), "pre-commit.sh")
  if (!file.exists(fname)) {
    stop("Missing hook file", call. = FALSE)
  }
  usethis::use_git_hook("pre-commit",fname)

  return(invisible(NULL))
}


