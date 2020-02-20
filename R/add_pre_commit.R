#' Adds a pre-commit hook
#'
#' Adds a pre-commit hook
#' @export
add_pre_commit = function() {
  fname = file.path(system.file("templates", package = "inteRgrate"), "pre-commit.sh")
  if (!file.exists(fname)) {
    stop("Missing hook file", call. = FALSE)
  }
  usethis::use_git_hook("pre-commit", fname)

  msg_info("check_version() hasn't been added - it's hard")
  msg_info("The hook is a link to the file in the pkg.")
  return(invisible(NULL))
}
