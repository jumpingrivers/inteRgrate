test_that("Testing gitignore", {

  expect_error(check_gitignore(path = system.file("tests/testthat", package = "inteRgrate")))
  good_pkg = system.file("good_pkg", package = "inteRgrate")
  expect_null(check_gitignore(path = good_pkg))
})
