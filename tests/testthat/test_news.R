test_that("Testing NEWS.md", {
  description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-major")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)

  news = file.path(system.file("test_news", package = "inteRgrate"), "NEWS-major.md")
  file.copy(news, to = "NEWS.md", overwrite = TRUE)
  expect_null(check_news())

  news = file.path(system.file("test_news", package = "inteRgrate"), "NEWS-error.md")
  file.copy(news, to = "NEWS.md", overwrite = TRUE)
  expect_error(test_news())

  description = file.path(system.file("test_news", package = "inteRgrate"), "DESCRIPTION-dev")
  file.copy(description, to = "DESCRIPTION", overwrite = TRUE)
  news = file.path(system.file("test_news", package = "inteRgrate"), "NEWS-dev.md")
  file.copy(news, to = "NEWS.md", overwrite = TRUE)
  expect_null(check_news())

})
