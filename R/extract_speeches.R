#' Extract Speeches from Records
#'
#' @description
#' The function extract speeches from the Riksdagen Records based on the
#' definition of a speech as the utterances (<u>) coming after a speaker
#' introduction (<note type="speaker">). The function returns the segments
#' of the speech.
#'
#' For multiple files, parallelism can be used.
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
#'   \item{speech_no}{The speech number in the record.}
#'   \item{speech_id}{The id of the XML node to the introduction of the speaker.}
#'   \item{who}{The id of the person giving the speech.}
#'   \item{id}{The id of the XML node for the segment of the speech.}
#'   \item{text}{The speech segment as plain text.}
#' }
#'
#' @importFrom xml2 read_xml xml_ns_strip xml_name xml_attr xml_text xml_find_all
#' @importFrom tidyr fill
#' @importFrom dplyr tibble bind_rows
#' @importFrom parallel mclapply detectCores
#' @export
extract_speeches_from_record <- function(record_path){
  record_path <- assert_and_complement_paths(record_path)

  x <- xml2::read_xml(record_path)
  x <- xml2::xml_ns_strip(x)

  # Extract speeches
  id <- xml2::xml_attr(xml2::xml_root(x), attr = "id")
  xs <- xml2::xml_find_all(x, ".//note[@type = 'speaker']|.//u|.//seg")
  df <- dplyr::tibble("record_id" = id,
                      "type_speaker" = xml2::xml_attr(xs, attr = "type") == "speaker",
                      "name" = xml2::xml_name(xs),
                      "who" = xml2::xml_attr(xs, attr = "who"),
                      "id" = xml2::xml_attr(xs, attr = "id"),
                      "text" = xml2::xml_text(xs, trim = TRUE))
  df$type_speaker[is.na(df$type_speaker)] <- FALSE
  df$speech_no <- cumsum(df$type_speaker)
  df$speech_id <- df$id
  df$speech_id[!df$type_speaker] <- NA
  df <- tidyr::fill(df, "who", "speech_id")
  df <- df[df$name == "seg",]
  df$type_speaker <- NULL
  df$name <- NULL
  df[, c("record_id", "speech_no", "speech_id", "who", "id", "text")]
}

#' @rdname extract_speeches_from_record
#' @export
extract_speeches_from_records <- function(record_paths, mc.cores = getOption("mc.cores", detectCores() - 1L), ...){
  record_paths <- assert_and_complement_paths(record_paths)

  if(mc.cores > 1L & .Platform$OS.type == "unix"){
    message(mc.cores, " cores are used to process the data.")
    res <- parallel::mclapply(record_paths, extract_speeches_from_record, mc.cores = mc.cores, ...)
  } else {
    res <- lapply(record_paths, extract_speeches_from_record)
  }

  res <- bind_rows(res)
  res[, c("record_id", "speech_no", "speech_id", "who", "id", "text")]
}

#' @details
#' The function checks if there is a file at the record_path.
#' If its not a file, it test to complement with the corpora path
#'
assert_and_complement_paths <- function(record_paths){
  # Assert the file exists
  checkmate::assert_character(record_paths)
  rcp <- get_riksdag_corpora_path()
  rcfp <- file.path(rcp, record_paths)

  for(i in seq_along(record_paths)){
    if(!file.exists(record_paths[i]) & file.exists(rcfp[i])){
      record_paths[i] <- rcfp[i]
    }
  }
  checkmate::assert_file_exists(record_paths)
  return(record_paths)
}
