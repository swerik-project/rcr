% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_speeches.R
\name{extract_speeches_from_record}
\alias{extract_speeches_from_record}
\alias{extract_speeches_from_records}
\alias{assert_and_complement_paths}
\title{Extract Speeches from Records}
\usage{
extract_speeches_from_record(record_path)

extract_speeches_from_records(
  record_paths,
  mc.cores = getOption("mc.cores", detectCores() - 1L),
  ...
)

assert_and_complement_paths(record_paths)
}
\arguments{
\item{record_path}{a file path to a record XML file}

\item{record_paths}{a vector of file paths to a record XML file}

\item{mc.cores}{the number of cores to use (Linux and Mac only) in \code{mclapply}.
Defaults to available cores - 1.}

\item{...}{further arguments supplied to \code{mclapply}.}
}
\value{
The function returns a \code{tibble} data frame with the following variables:
\describe{
  \item{record_id}{The id of the record.}
  \item{speech_no}{The speech number in the record.}
  \item{speech_id}{The id of the XML node to the introduction of the speaker.}
  \item{who}{The id of the person giving the speech.}
  \item{id}{The id of the XML node for the segment of the speech.}
  \item{text}{The speech segment as plain text.}
}
}
\description{
The function extract speeches from the Riksdagen Records based on the
definition of a speech as the utterances (<u>) coming after a speaker
introduction (<note type="speaker">). The function returns the segments
of the speech.

For multiple files, parallelism can be used.
}
\details{
The function checks if there is a file at the record_path.
If its not a file, it test to complement with the corpora path
}
