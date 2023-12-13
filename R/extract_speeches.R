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
#'
#'
#' @return
#' The function returns a tibble data frame with the following variables:
#' \describe{
#'   \item{speech_no}{The speech number in the record.}
#'   \item{speech_id}{The id of the XML node to the introduction of the speaker.}
#'   \item{who}{The id of the person giving the speech.}
#'   \item{id}{The id of the XML node for the segment of the speech.}
#'   \item{text}{The speech segment as plain text.}
#' }
#'
#' @importFrom xml2 read_xml xml_ns_strip xml_name xml_attr xml_text xml_find_all
#' @importFrom tidyr fill
#' @importFrom dplyr tibble
#' @export
extract_speeches_from_record <- function(record_path){
  # Assert the file exists
  checkmate::assert_string(record_path)
  rcp <- get_riksdag_corpora_path()
  rcfp <- file.path(rcp, record_path)
  if(file.exists(rcfp)){
    record_paths <- rcfp
  }
  checkmate::assert_file_exists(record_path)

  x <- read_xml(record_path)
  x <- xml_ns_strip(x)

  # Extract speeches
  xs <- xml_find_all(x, ".//note[@type = 'speaker']|.//u|.//seg")
  df <- tibble("type_speaker" = xml_attr(xs, attr = "type") == "speaker",
               "name" = xml_name(xs),
               "who" = xml_attr(xs, attr = "who"),
               "id" = xml_attr(xs, attr = "id"),
               "text" = xml_text(xs, trim = TRUE))
  df$type_speaker[is.na(df$type_speaker)] <- FALSE
  df$speech_no <- cumsum(df$type_speaker)
  df$speech_id <- df$id
  df$speech_id[!df$type_speaker] <- NA
  df <- fill(df, "who", "speech_id")
  df <- df[df$name == "seg",]
  df$type_speaker <- NULL
  df$name <- NULL
  df[, c("speech_no", "speech_id", "who", "id", "text")]
}

