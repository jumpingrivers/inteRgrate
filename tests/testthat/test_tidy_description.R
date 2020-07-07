test_that("Testing tidy description", {
  description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-major")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
  expect_null(check_tidy_description())
  description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-dev")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
  expect_null(check_tidy_description())

  description = file.path(system.file("test_tidy_description", package = "inteRgrate"),
                          "DESCRIPTION")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
  expect_error(check_tidy_description())
})
