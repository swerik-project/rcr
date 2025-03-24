test_that("extracting speeches works", {
  if(FALSE){
    # Setup testdata
    tdfp <-
      c("data/1896/prot-1896--ak--042.xml",
        "data/1951/prot-1951--fk--029.xml",
        "data/1975/prot-1975--036.xml")
    tdfpf <- file.path(get_riksdag_corpora_path(), tdfp)
    tdfpt <- file.path("tests/testthat/files/", basename(tdfp))
    file.copy(tdfpf, tdfpt)
    cat(paste0("tfp <- c('", paste(basename(tdfp),collapse =  "', '"), "')"))
  }

  tfp <- c('prot-1896--ak--042.xml', 'prot-1951--fk--029.xml', 'prot-1975--036.xml')
  tfp <- test_path(file.path("files", tfp))

  expect_silent(sp <- extract_speeches_from_record(record_path = tfp[1]))
  expect_error(sp <- extract_speeches_from_record(tfp))
  expect_silent(sp <- extract_speeches_from_records(tfp, mc.cores = 1L))
  expect_silent(suppressMessages(sp <- extract_speeches_from_records(record_paths = tfp, mc.cores = 2L)))

  if(FALSE){
    # Test to read in the whole corpus year by year
    years_dir <- list.files(file.path(get_riksdag_corpora_path(), "protocols"), full.names = TRUE)
    for(i in seq_along(years_dir)){
      print(basename(years_dir[i]))
      fps <- dir(years_dir[i], full.names = TRUE)
      res <- extract_speeches_from_records(fps)
    }
  }
})
