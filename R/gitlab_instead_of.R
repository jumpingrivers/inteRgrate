# nolint start
#' @title Gitlab rewrite
#'
#' Rewrites the gitlab URL. This can be handy if you want to push to another GitLab repo
#' on successful builds. Uses the environment variable CI_SERVER_HOST to determine
#' the HOST.
#' @export
gitlab_instead_of = function() {
  SERVER_HOST = Sys.getenv("CI_SERVER_HOST")
  system2("git",
          args = c("config",
                   '--global url."https://gitlab-ci-token:${CI_JOB_TOKEN}@{SERVER_HOST}/".insteadOf',
                   '"git@{SERVER_HOST}:"'))
  return(invisible(NULL))
}
# nolint end
