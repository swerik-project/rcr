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

test_that("relative paths are resolved against the configured corpus path", {
  old_path <- Sys.getenv("RIKSDAG_CORPORA_PATH", unset = NA_character_)
  on.exit({
    if (is.na(old_path)) {
      Sys.unsetenv("RIKSDAG_CORPORA_PATH")
    } else {
      Sys.setenv(RIKSDAG_CORPORA_PATH = old_path)
    }
  }, add = TRUE)

  corpus_root <- tempfile("rcr-test-corpus-")
  dir.create(file.path(corpus_root, "data", "1896"), recursive = TRUE)
  writeLines(
    c(
      "title: Test corpus",
      "version: 0.0.0",
      "date-released: 2026-08-11",
      "repository-code: https://example.com/swerik-test",
      "url: https://example.com/swerik-test"
    ),
    file.path(corpus_root, "CITATION.cff")
  )

  relative_path <- "data/1896/prot-1896--ak--042.xml"
  file.copy(
    test_path("files", "prot-1896--ak--042.xml"),
    file.path(corpus_root, relative_path)
  )

  expect_message(set_riksdag_corpora_path(corpus_root), "title")
  expect_silent(speeches <- extract_speeches_from_record(relative_path))
  expect_s3_class(speeches, "data.frame")
  expect_gt(nrow(speeches), 0)
  expect_named(
    speeches,
    c("record_id", "speech_no", "speech_id", "who", "id", "text")
  )

  expect_silent(
    speech_batch <- extract_speeches_from_records(relative_path, mc.cores = 1L)
  )
  expect_equal(speech_batch, speeches)
})

test_that("missing relative paths fail before parallel extraction", {
  old_path <- Sys.getenv("RIKSDAG_CORPORA_PATH", unset = NA_character_)
  on.exit({
    if (is.na(old_path)) {
      Sys.unsetenv("RIKSDAG_CORPORA_PATH")
    } else {
      Sys.setenv(RIKSDAG_CORPORA_PATH = old_path)
    }
  }, add = TRUE)

  corpus_root <- tempfile("rcr-test-corpus-")
  dir.create(corpus_root)
  writeLines(
    c(
      "title: Test corpus",
      "version: 0.0.0",
      "date-released: 2026-08-11",
      "repository-code: https://example.com/swerik-test",
      "url: https://example.com/swerik-test"
    ),
    file.path(corpus_root, "CITATION.cff")
  )

  expect_message(set_riksdag_corpora_path(corpus_root), "title")
  expect_error(
    extract_speeches_from_records(
      "data/1896/prot-1896--ak--missing.xml",
      mc.cores = 2L
    ),
    "Assertion on 'record_paths' failed"
  )
})
