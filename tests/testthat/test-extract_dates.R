test_that("extracting dates works", {
  # library(testthat)
  tfp <- c('prot-1896--ak--042.xml', 'prot-1951--fk--029.xml', 'prot-1975--036.xml')
  tfp <- test_path(file.path("files", tfp))

  expect_silent(sp <- extract_record_dates_from_record(record_path = tfp[1]))
  expect_error(sp <- extract_record_dates_from_record(tfp))
  expect_silent(sp <- extract_record_dates_from_records(record_paths = tfp, mc.cores = 1L))

})
