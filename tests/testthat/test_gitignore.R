test_that("Testing gitignore", {
  expect_error(check_gitignore(dir = "."))
  expect_null(check_gitignore(system.file("test_gitignore", package = "inteRgrate")))
})
