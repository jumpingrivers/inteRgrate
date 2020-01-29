get_tag_name = function() {
  des = read.dcf("DESCRIPTION")[1, ]
  version = des[names(des) == "Version"]
  tag_name = paste0("v-", gsub("\\.", "-", version))
  tag_name
}

is_in_development = function() {
  des = read.dcf("DESCRIPTION")[1, ]
  version = des[names(des) == "Version"]
  stringr::str_detect(version, "^[0-9]*\\.[0-9]*\\.[0-9]*\\.9[0-9]{3}$")
}

globalVariables(c("tag_name", "SERVER_HOST", "CI_PROJECT_ID", "CI_COMMIT_SHA"))
#' Auto-tagging via CI
#'
#' Automatically tag the commit via the version number. This requies the
#' environment variable GITHUB_TOKEN that has write permission.
#'
#' If the version contains an in development component (e.g. X.Y.Z.9001), by
#' default a tag isn't created.
#' @param branch The branch where the tagging will occur. Default master.
#' @param in_development Logical default FALSE.
#' @export
create_tag = function(branch = "master", in_development = FALSE) {
  if (!is_gitlab()) {
    message("Doesn't seem to be a gitlab runner. No tagging")
    return(invisible(NULL))
  }
  # Assume GITLAB
  if (Sys.getenv("CI_COMMIT_BRANCH") != branch) {
    message("Not on ", branch, " so no tagging")
    return(invisible(NULL))
  }

  if (!is.na(Sys.getenv("CI_COMMIT_TAG", NA))) {
    message("This looks like a tagging CI process, so I'm not going to tag")
    return(invisible(NULL))
  }

  if (!in_development && is_in_development()) {
    message("In development, not tag")
    return(invisible(NULL))
  }

  tag_name = get_tag_name()
  gitlab_instead_of()
  SERVER_HOST = Sys.getenv("CI_SERVER_HOST") #nolint
  CI_PROJECT_ID = Sys.getenv("CI_PROJECT_ID") #nolint
  CI_COMMIT_SHA = Sys.getenv("CI_COMMIT_SHA") #nolint
  GITLAB_TOKEN = Sys.getenv("GITLAB_TOKEN", NA) #nolint
  if (is.na(GITLAB_TOKEN)) {
    stop("GITLAB_TOKEN missing. Required for tagging", call. = FALSE)
  }
  url = glue::glue("'https://{SERVER_HOST}/api/v4/projects/{CI_PROJECT_ID}/repository/tags?\\
           tag_name={tag_name}&ref={CI_COMMIT_SHA}&private_token={GITLAB_TOKEN}'")
  out = system2("curl",
                args = c("-X", "POST", "--silent", "--show-error", "--fail", url),
                stderr = TRUE, stdout = TRUE)

  if (!is.null(attr(out, "status"))) {
    stop("Tagging didn't work", call. = FALSE)
  }
  return(invisible(NULL))
}
