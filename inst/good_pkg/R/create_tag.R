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

globalVariables(c("token", "project"))
#' Auto-tagging via CI
#'
#' Automatically tag the commit via the version number. This requires the
#' environment variable GITHUB_TOKEN that has write permission.
#'
#' If the version contains an in development component (e.g. X.Y.Z.9001), by
#' default a tag isn't created.
#' @param branch The branch where the tagging will occur. Default master or main.
#' @param in_development Logical default FALSE.
#' @export
create_tag = function(branch = get_origin_name(), in_development = FALSE) {
  cli::cli_h3("Creating a tag...create_tag()")
  if (!is_gitlab() && !is_github()) {
    cli::cli_alert_info("No tagging: doesn't seem to be a CI process")
    return(invisible(NULL))
  }

  if (is_tagging_branch()) {
    cli::cli_alert_info("No tagging: This looks like a tagging CI process")
    return(invisible(NULL))
  }

  if (!in_development && is_in_development()) {
    cli::cli_alert_info("No tagging: in development")
    return(invisible(NULL))
  }

  # Check branch
  if (get_current_branch() != branch) {
    cli::cli_alert_info(paste("No tagging: Not on", branch))
    return(invisible(NULL))
  }

  # Has the package actually changed?
  if (isFALSE(has_pkg_changed(repo = paste0("origin/", branch)))) {
    cli::cli_alert_info("No tagging: Package hasn't changed")
    return(invisible(NULL))
  }

  tag_name = get_tag_name()
  if (is_gitlab()) {
    gitlab_tag(tag_name)
  } else {
    github_tag(tag_name)
  }
  cli::cli_alert_success("Tagging good")
  return(invisible(NULL))
}

github_tag = function(tag_name) {
  # Set a sensible name for the commit
  system2("git", args = c("config", "--global", "user.email",  "'travis.tagger@example.com'"))
  system2("git", args = c("config", "--global", "user.name", "'Travis tagger'"))

  # Get token
  token = get_auth_token()

  # Rewrite URL with PAT
  project = Sys.getenv("TRAVIS_REPO_SLUG")
  git_url = glue::glue("https://{token}@github.com/{project}.git")
  system2("git", args = c("remote", "set-url", "origin", git_url))

  # Tag and push
  system2("git", args = c("tag", "-a", tag_name,  "-m", glue::glue("'Version {tag_name}'")))
  system2("git", args = c("push", "--tags"))
  return(invisible(NULL))

}

gitlab_tag = function(tag_name) {
  gitlab_instead_of()
  SERVER_HOST = Sys.getenv("CI_SERVER_HOST") #nolint
  project = Sys.getenv("CI_PROJECT_ID") #nolint
  CI_COMMIT_SHA = Sys.getenv("CI_COMMIT_SHA") #nolint
  token = get_auth_token()

  url = glue::glue("'https://{SERVER_HOST}/api/v4/projects/{project}/repository/tags?\\
           tag_name={tag_name}&ref={CI_COMMIT_SHA}&private_token={token}'")
  out = system2("curl",
                args = c("-X", "POST", "--silent", "--show-error", "--fail", url),
                stderr = TRUE, stdout = TRUE)

  if (!is.null(attr(out, "status"))) {
    msg_error("Tagging didn't work")
  }
  return(invisible(NULL))
}

## We use tokens instead of ssh, but I suppose we could do both
## For future readers
## When add id_rsa, remember to remove lines breaks and encode base64
#ssh_id = Sys.getenv("id_rsa", NA)
# con = file("~/.ssh/id_rsa")
# writeLines(rawToChar(openssl::base64_decode(ssh_id)), con = con)
# close(con)
# Sys.chmod("~/.ssh/id_rsa", "0600")
