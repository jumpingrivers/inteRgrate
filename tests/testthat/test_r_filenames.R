test_that("Testing R filenames", {
  expect_null(check_r_filenames(dir = "."))
  expect_error(check_r_filenames(dir = ".", extension = "r"))
})
