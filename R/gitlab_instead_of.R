# nolint start
#' @title Gitlab rewrite
#'
#' Rewrites the gitlab URL. This can be handy if you want to push to another GitLab repo
#' on successful builds.
#' @export
gitlab_instead_of = function() {
  system2("git",
          args = c("config",
                   '--global url."https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.com/".insteadOf',
                   '"git@gitlab.com:"'))
  return(invisible(NULL))
}

# nolint end
