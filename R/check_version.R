get_current_branch = function() Sys.getenv("TRAVIS_BRANCH", Sys.getenv("CI_COMMIT_BRANCH"))
get_sha_range = function() Sys.getenv("TRAVIS_COMMIT_RANGE", Sys.getenv("CI_COMMIT_BEFORE_SHA"))
is_tagging_branch = function() {
  !is.na(Sys.getenv("CI_COMMIT_TAG", Sys.getenv("TRAVIS_TAG", NA)))
}

get_origin_name = function() {
  origin = system2("git", c("branch"), stdout = TRUE)
  origin = stringr::str_trim(origin)
  is_master = any(stringr::str_detect(origin, "master$"))
  if (is_master) "master" else "main"
}

has_pkg_changed = function(repo) {
  current_branch = get_current_branch()
  sha_range = get_sha_range()

  if (!(current_branch %in% c("master", "main"))) {
    system2("git", args = c("remote", "set-branches", "--add", "origin", get_origin_name()))
    system2("git", args = c("fetch", "origin", get_origin_name()))
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
  ## .Rbuildignore is case insensitive
  ignores = stringr::str_to_lower(readLines(".Rbuildignore"))
  ignores = ignores[nchar(ignores) > 0L]
  lower_committed = stringr::str_to_lower(committed_files)
  list_ignores = sapply(ignores,
                        function(ignore) stringr::str_detect(lower_committed, ignore))
  mat_ignores = matrix(list_ignores, ncol = length(committed_files), byrow = TRUE)

  ignore_files = apply(mat_ignores, 2, any)
  committed_files = committed_files[!ignore_files]

  ## Handle case where there is more than one pkg per repo
  ## Remove any files not in this repo
  repo_root = system2("git", args = c("rev-parse", "--show-toplevel"), stdout = TRUE)
  committed_files = file.path(repo_root, committed_files)
  committed_files = committed_files[stringr::str_detect(committed_files, pattern = getwd())]

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
#' @param repo Default origin/master or origin/main. The repo to compare against.
#' @inheritParams check_pkg
#' @export
check_version = function(repo = NULL, path = ".") {
  if (is.null(repo)) {
    repo = paste0("origin/", get_origin_name())
  }
  op = setwd(path)
  on.exit(setwd(op))
  cli::cli_h3("Checking version...check_version()")

  pkg_changed = has_pkg_changed(repo)
  if (isFALSE(pkg_changed)) {
    cli::cli_alert_success("Your version is fine!")
    return(invisible(NULL))
  }

  current_branch = get_current_branch()
  ## Check if version has been updated
  if (!(current_branch %in% c("master", "main"))) {
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
    msg_error("Please update the package version")
  } else {
    cli::cli_alert_success("Version looks good")
  }
  return(invisible(NULL))
}
