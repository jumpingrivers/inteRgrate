add_hook = function(type, fname) {
  fname = file.path(system.file("templates", package = "inteRgrate"), fname)
  if (!file.exists(fname)) {
    stop("Missing hook file", call. = FALSE)
  }
  usethis::use_git_hook(type, fname)

  msg_info("check_version() hasn't been added - it's hard")
  msg_info("The hook is a link to the file in the pkg.")
  return(invisible(NULL))
}

#' Adds a git hook
#'
#' Add a pre-commit or pre-push hook.
#' Both hooks are identical. They just get triggered at different times.
#' @export
add_pre_commit = function() {
  add_hook("pre-commit", "pre-commit.sh")
}

#' @export
#' @rdname add_pre_commit
add_pre_push = function() {
  add_hook("pre-push", "pre-push.sh")
}
