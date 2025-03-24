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
#' @importFrom xml2 read_xml xml_ns_strip xml_attr xml_root
#' @export
extract_record_dates_from_record <- function(record_path, all=F){
  record_path <- assert_and_complement_paths(record_path)

  x <- read_xml(record_path)
  x <- xml_ns_strip(x)

  id <- xml_attr(xml_root(x),attr = "id")
  xs <- xml_find_all(x,".//docDate")
  df <- tibble("record_id" = id,
               "doc_date" = as.Date(xml_text(xs)))

  return(df)
}


#' @rdname extract_speeches_from_record
#' @export
extract_record_dates_from_records <- function(record_paths, mc.cores = getOption("mc.cores", detectCores() - 1L), ...){
  record_paths <- assert_and_complement_paths(record_paths)

  if(mc.cores > 1L & .Platform$OS.type == "unix"){
    message(mc.cores, " cores are used to process the data.")
    res <- parallel::mclapply(record_paths, extract_record_dates_from_record, mc.cores = mc.cores, ...)
  } else {
    res <- lapply(record_paths, extract_record_dates_from_record)
  }

  res <- bind_rows(res)
  res[, c("record_id", "doc_date")]
}
