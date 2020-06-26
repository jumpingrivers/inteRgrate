test_that("Testing checks", {
  gitlab = file.path(system.file("ci-examples", package = "inteRgrate"), "gitlab-ci.yml")
  file.copy(gitlab, to = ".gitlab-ci.yml")
  on.exit(file.remove(".gitlab-ci.yml"))
  expect_equal(get_gitlab_env_var("SPACE"), 0)
  expect_equal(get_gitlab_env_var("NO_SPACE"), 0)
  expect_equal(get_gitlab_env_var("COMMENT"), 0)
  expect_null(get_gitlab_env_var("MISSING"))
}
)
