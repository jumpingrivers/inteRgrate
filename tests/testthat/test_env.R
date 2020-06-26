test_that("Testing checks", {
  gitlab = file.path(system.file("ci-examples", package = "inteRgrate"), "gitlab-ci.yml")
  file.copy(gitlab, to = ".gitlab-ci.yml")
  expect_equal(get_gitlab_env_var("SPACE"), 0)
}
)
