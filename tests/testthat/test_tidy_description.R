test_that("Testing tidy description", {

  ## Hard to test, as use_tidy_description looks at the current .Rproj
  ## XXX: Could create a dummy .Rproj file?

  withr::with_dir(
    tempdir(), {
      description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-major")
      file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
      expect_null(check_tidy_description())
  })

  withr::with_dir(
    tempdir(), {
      description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-dev")
      file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
      expect_null(check_tidy_description())
  })
})
