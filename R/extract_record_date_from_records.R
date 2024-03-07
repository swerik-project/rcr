#' Extract Date from Record
#'
#' @description
#' The function extract date from the Riksdagen Records.
#'
#' @param record_path a file path to a record XML file
#' @param record_paths a vector of file paths to a record XML file
#' @param mc.cores the number of cores to use (Linux and Mac only) in \code{mclapply}.
#'                 Defaults to available cores - 1.
#' @param ... further arguments supplied to \code{mclapply}.
#'
#' @return
#' The function returns a \code{tibble} data frame with the following variables:
#' \describe{
#'   \item{record_id}{The id of the record.}
#'   \item{record_date}{The date of the record.}
#' }
#'
#' @importFrom xml2 read_xml xml_ns_strip, xml_attr
#' @export
extract_record_dates_from_record <- function(record_path, all=F){
  checkmate::assert_string(record_path)
  rcp <- get_riksdag_corpora_path()
  rcfp <- file.path(rcp, record_path)
  if(file.exists(rcfp)){
    record_path <- rcfp
  }
  checkmate::assert_file_exists(record_path)

  x <- read_xml(record_path)
  x <- xml_ns_strip(x)

  id <- xml_attr(xml_find_all(x, "TEI"),attr = "id")
  xs <- xml_find_all(x,".//docDate")
  df <- tibble("record_id" = id,
               "doc_date" = as.Date(xml_text(xs)))

  return(df)
}


#' @rdname extract_speeches_from_record
#' @export
extract_record_dates_from_records <- function(record_paths, mc.cores = getOption("mc.cores", detectCores() - 1L), ...){
  checkmate::assert_character(record_paths)
  rcp <- get_riksdag_corpora_path()
  rcfp <- file.path(rcp, record_paths)
  for(i in seq_along(rcfp)){
    if(file.exists(rcfp[i])){
      record_paths[i] <- rcfp[i]
    }
  }
  checkmate::assert_file_exists(record_paths)

  if(mc.cores > 1L & .Platform$OS.type == "unix"){
    message(mc.cores, " cores are used to process the data.")
    res <- parallel::mclapply(record_paths, extract_record_dates_from_record, mc.cores = mc.cores, ...)
  } else {
    res <- lapply(record_paths, extract_record_dates_from_record)
  }

  res <- bind_rows(res)
  res[, c("record_id", "doc_date")]
}
