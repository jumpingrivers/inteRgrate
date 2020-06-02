#' @export
#' @rdname add_pre_commit
#' @description git_pre_commit only tests files that have changed.
#' Makes things, especially linting a lot faster.
git_pre_commit = function() {
  out = system2("git",  args = c("diff", "--name-only", "--cached"), stdout = TRUE)
  fnames = unlist(stringr::str_split(out, "\n"))
  # Exit early
  if (length(fnames) == 0) return(invisible(NULL))

  # Remove deleted files!
  fnames = fnames[file.exists(fnames)]

  check_file_permissions(fnames)
  check_line_breaks(fnames)
  if (any(stringr::str_starts(fnames, "R\\/"))) {
    check_r_filenames()
  }

  if (any(stringr::str_detect(fnames, "^NAMESPACE$"))) {
    check_namespace()
  }

  if (any(stringr::str_detect(fnames, "^DESCRIPTION$")) ||
      any(stringr::str_detect(fnames, "^README\\.")) ||
      any(stringr::str_detect(fnames, "^\\.gitignore"))) {
    #check_meta()
  }
  has_error = FALSE
  fnames = fnames[stringr::str_detect(fnames, "\\.R$|\\.r$|\\.Rmd$")]
  for (fname in fnames) {
    cli::cli_alert_info(paste("Checking ", fname))
    l = lintr::lint(fname)
    if (length(l) > 0) {
      print(l)
      has_error = TRUE
    }
  }
  if (isTRUE(has_error)) {
    msg_error("Linting errors", stop = TRUE)
  } else if (length(fnames) > 0L) {
    cli::cli_alert_success("Linting OK")
  }
  return(invisible(NULL))
}

add_hook = function(type, fname) {
  fname = file.path(system.file("templates", package = "inteRgrate"), fname)
  if (!file.exists(fname)) {
    stop("Missing hook file", call. = FALSE)
  }
  usethis::use_git_hook(type, fname)

  cli::cli_alert_info("check_version() hasn't been added - it's hard")
  cli::cli_alert_info("The hook is a link to the file in the pkg.")
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
