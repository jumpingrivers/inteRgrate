test_that("Testing R filenames", {
  good_pkg = system.file("good_pkg", package = "inteRgrate")
  expect_null(check_r_filenames(path = good_pkg))
  expect_error(check_r_filenames(path = good_pkg, extension = "r"))
})
