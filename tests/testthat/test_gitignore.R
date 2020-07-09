test_that("Testing gitignore", {

  good_pkg = system.file("good_pkg", package = "inteRgrate")
  expect_null(check_gitignore(path = good_pkg))
})
