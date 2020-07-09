test_that("Testing gitignore", {
  good_pkg = system.file("good_pkg", package = "inteRgrate")

  expect_error(check_gitignore(path = "."))
  expect_null(check_gitignore(path = good_pkg))
})
