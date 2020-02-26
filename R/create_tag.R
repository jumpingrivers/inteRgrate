get_tag_name = function() {
  des = read.dcf("DESCRIPTION")[1, ]
  version = des[names(des) == "Version"]
  tag_name = paste0("v", version)
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
  set_crayon()

  msg_start("Creating a tag...create_tag()")
  if (!is_gitlab() && !is_github()) {
    msg_info("Doesn't seem to be a gitlab runner, so no tagging")
    return(invisible(NULL))
  }

  if (is_tagging_branch()) {
    msg_info("This looks like a tagging CI process, so no tagging")
    return(invisible(NULL))
  }

  if (!in_development && is_in_development()) {
    msg_info("In development, so no tagging")
    return(invisible(NULL))
  }

  # Check branch
  if (get_current_branch() != branch) {
    msg_info(paste("Not on", branch, "so no tagging"))
    return(invisible(NULL))
  }

 # if (isFALSE(has_pkg_changed(repo = paste0("origin/", branch)))) {
#    msg_info("Package hasn't changed, so no tagging")
#    return(invisible(NULL))
#  }

  tag_name = get_tag_name()
  if (is_gitlab()) {
    gitlab_tag(tag_name)
  } else {
    github_tag(tag_name)
  }
  msg_ok("Tagging good.")
  return(invisible(NULL))
}

github_tag = function(tag_name) {
  system2("git", args = c("config", "--global", "user.email",  "'travis.tagger@example.com'"))
  system2("git", args = c("config", "--global", "user.name", "'Travis tagger'"))
  github_pat = Sys.getenv("GITHUB_PAT", NA)
  if (is.na(github_pat)) {
    msg_error("GITHUB_PAT missing. Required for tagging", stop = TRUE)
  }
  repo = Sys.getenv("TRAVIS_REPO_SLUG", NA)
  git_url = glue::glue("https://{github_pat}@github.com/{repo}.git")
  system2("git", args = c("remote", "set-url", "origin", git_url))
  system2("git", args = c("tag", "-a", tag_name,  "-m", glue::glue("Version {tag_name}")))
  system2("git", args = c("push", "--tags"))
  return(invisible(NULL))

}

gitlab_tag = function(tag_name) {
  gitlab_instead_of()
  SERVER_HOST = Sys.getenv("CI_SERVER_HOST") #nolint
  CI_PROJECT_ID = Sys.getenv("CI_PROJECT_ID") #nolint
  CI_COMMIT_SHA = Sys.getenv("CI_COMMIT_SHA") #nolint
  GITLAB_TOKEN = Sys.getenv("GITLAB_TOKEN", NA) #nolint
  if (is.na(GITLAB_TOKEN)) {
    msg_error("GITLAB_TOKEN missing. Required for tagging", stop = TRUE)
  }
  url = glue::glue("'https://{SERVER_HOST}/api/v4/projects/{CI_PROJECT_ID}/repository/tags?\\
           tag_name={tag_name}&ref={CI_COMMIT_SHA}&private_token={GITLAB_TOKEN}'")
  out = system2("curl",
                args = c("-X", "POST", "--silent", "--show-error", "--fail", url),
                stderr = TRUE, stdout = TRUE)

  if (!is.null(attr(out, "status"))) {
    msg_error("Tagging didn't work", stop = TRUE)
  }
  return(invisible(NULL))
}
