test_that("Testing Parsing .gitlab-ci", {
  gitlab = file.path(system.file("ci-examples", package = "inteRgrate"), "gitlab-ci.yml")
  file.copy(gitlab, to = ".gitlab-ci.yml", overwrite = TRUE)

  expect_equal(get_gitlab_env_var("SPACE"), 10)
  expect_equal(get_gitlab_env_var("NO_SPACE"), 10)
  expect_equal(get_gitlab_env_var("COMMENT"), 10)
  expect_null(get_gitlab_env_var("MISSING"))

}
)

test_that("Testing Parsing travis", {
  travis = file.path(system.file("ci-examples", package = "inteRgrate"), "travis.yml")
  file.copy(travis, to = ".travis.yml", overwrite = TRUE)

  expect_equal(get_github_env_var("SPACE"), 10)
  expect_equal(get_github_env_var("NO_SPACE"), 10)
  expect_equal(get_github_env_var("COMMENT"), 10)
  expect_null(get_github_env_var("MISSING"))
}
)
