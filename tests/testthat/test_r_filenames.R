test_that("Testing R filenames", {
  expect_null(check_r_filenames(path = "."))
  expect_error(check_r_filenames(path = ".", extension = "r"))
})
