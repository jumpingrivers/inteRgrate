# nolint start
#' @title Gitlab rewrite
#'
#' Rewrites the gitlab URL. Using this means we don't require specific runner gitlab commands.
#' @export
gitlab_instead_of = function() {
  system2("git",
          args = c("config",
                   '--global url."https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.com/".insteadOf',
                   '"git@gitlab.com:"'))
  return(invisible(NULL))
}

# nolint end
