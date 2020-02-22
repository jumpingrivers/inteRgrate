#' @export
#' @rdname add_pre_commit
#' @description git_pre_commit only tests files that have changed. Makes things, especially linting
#' a lot faster.
git_pre_commit = function() {
  out = system2("git",  args = c("diff", "--name-only", "--cached"), stdout = TRUE)
  fnames = unlist(stringr::str_split(out, "\n"))

  if (any(stringr::str_detect(fnames, "DESCRIPTION"))) {
    check_tidy_description()
  }

  if (any(stringr::str_starts(fnames, "R\\/"))) {
    check_r_filenames()
  }

  if (any(stringr::str_detect(fnames, "NAMESPACE"))) {
    check_namespace()
  }

  has_error = FALSE
  fnames = fnames[stringr::str_detect(fnames, "\\.R$|\\.r$|\\.Rmd$")]
  for (fname in fnames) {
    msg_info(paste("Checking ", fname))
    l = lintr::lint(fname)
    if (length(l) > 0) {
      print(l)
      has_error = TRUE
    }
  }
  if (isTRUE(has_error)) {
    msg_error("Linting errors", stop = TRUE)
  } else {
    msg_ok("Linting OK")
  }
  return(invisible(NULL))
}

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
