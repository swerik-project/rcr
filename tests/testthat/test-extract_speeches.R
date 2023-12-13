test_that("extracting speeches works", {
  if(FALSE){
    # Setup testdata
    tdfp <-
      c("protocols/1896/prot-1896--ak--042.xml",
        "protocols/1951/prot-1951--fk--029.xml",
        "protocols/1975/prot-1975--036.xml")
    tdfpf <- file.path(get_riksdag_corpora_path(), tdfp)
    tdfpt <- file.path("tests/testthat/files/", basename(tdfp))
    file.copy(tdfpf, tdfpt)
    cat(paste0("tfp <- c('", paste(basename(tdfp),collapse =  "', '"), "')"))
  }

  tfp <- c('prot-1896--ak--042.xml', 'prot-1951--fk--029.xml', 'prot-1975--036.xml')
  tfp <- test_path(file.path("files", tfp))

  expect_silent(sp <- extract_speeches_from_record(tfp[1]))
  expect_error(sp <- extract_speeches_from_record(tfp))
  expect_silent(sp <- extract_speeches_from_records(tfp))

})
