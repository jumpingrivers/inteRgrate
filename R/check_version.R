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
  committed_files = system2("git",
                            args = c("diff", "--name-only", repo),
                            stdout = TRUE)

  if (length(committed_files) == 0L) return(invisible(NULL))
  ## Get ignores and remove ignored files
  ignores = readLines(".Rbuildignore")
  list_ignores = lapply(ignores,
                        function(ignore) grepl(ignore, committed_files))
  mat_ignores = Reduce(rbind, list_ignores)

  ignore_files = colSums(mat_ignores) != nrow(mat_ignores)
  committed_files = committed_files[ignore_files]

  if (length(committed_files) > 0L && !("DESCRIPTION" %in% committed_files)) {
    stop("Please update the package version", call. = FALSE)
  }

  ## Check if version has been updated
  des_diff = system2("git",
                     args = c("diff", "--unified=0", repo, "DESCRIPTION"),
                     stdout = TRUE)
  ## Remove standard diff header
  des_diff = des_diff[-(1:5)]
  if ( length(grep("Version:", des_diff)) == 0L) {
    stop("Please update the package version", call. = FALSE)
  }

  msg = glue("{symbol$tick} Your version has been updated!")
  message(green(msg))
  return(invisible(NULL))
}

