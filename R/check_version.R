get_current_branch = function() Sys.getenv("TRAVIS_BRANCH", Sys.getenv("CI_COMMIT_BRANCH"))
get_sha_range = function() Sys.getenv("TRAVIS_COMMIT_RANGE", Sys.getenv("CI_COMMIT_BEFORE_SHA"))

has_pkg_changed = function(repo) {
  current_branch = get_current_branch()
  sha_range = get_sha_range()

  if (current_branch != "master") {
    system2("git", args = c("remote", "set-branches", "--add", "origin", "master"))
    system2("git", args = "fetch")
    committed_files = system2("git", args = c("diff", "--name-only", repo),
                              stdout = TRUE)
  } else {
    # TRAVIS_COMMIT_RANGE returns empty on first commit
    committed_files = system2("git", args = c("diff", "--name-only", sha_range),
                              stdout = TRUE)
  }

  if (length(committed_files) == 0L) {
    return(FALSE)
  }

  ## Get ignores and remove ignored files
  ignores = readLines(".Rbuildignore")
  list_ignores = sapply(ignores,
                        function(ignore) stringr::str_detect(committed_files, ignore))
  mat_ignores = matrix(list_ignores, ncol = length(committed_files), byrow = TRUE)

  ignore_files = apply(mat_ignores, 2, any)
  committed_files = committed_files[!ignore_files]
  any_changes = length(committed_files) != 0L
  return(any_changes)

}

#' Version check
#'
#' Check if the package version has been updated compared to the a
#' master repo (default is origin/master). This ensures that when branches are merged
#' the package version is bumped.
#'
#' Files listed in .Rbuildignore don't count as changes.
#'
#' Technically we only check for a change in the Version line of the DESCRIPTION file, not an
#' actual version increase.
#' @param repo Default origin/master. The repo to compare against.
#' @export
check_version = function(repo = "origin/master") {
  set_crayon()
  msg_start("Checking version...check_version()")

  pkg_changed = has_pkg_changed(repo)
  if (isFALSE(pkg_changed)) {
    msg_ok("Your version is fine!")
    return(invisible(NULL))
  }

  current_branch = get_current_branch()
  ## Check if version has been updated
  if (current_branch != "master") {
    des_diff = system2("git",
                       args = c("diff", "--unified=0", repo, "DESCRIPTION"),
                       stdout = TRUE)
  } else {
    des_diff = system2("git",
                       args = c("diff", "--unified=0", get_sha_range(), "DESCRIPTION"),
                       stdout = TRUE)
  }

  ## Remove standard diff header
  ## Works even if DESCRIPTION hasn't been changed
  des_diff = des_diff[-1:-5]
  if (length(grep("Version:", des_diff)) == 0L) {
    msg_error("Please update the package version", stop = TRUE)
  }

  msg_ok("Version looks good")
  return(invisible(NULL))
}
