<!-- badges: start -->
[![R-CMD-check](https://github.com/swerik-project/rcr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/swerik-project/rcr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->
  

# The Riksdag Corpora R package

## Installation

To install the R package, run:
```
library(remotes)
remotes::install_github('swerik-project/rcr')
```

## Use
To use the R package, download the riksdagen-records corpora [here](https://github.com/swerik-project/riksdagen-records). As a first step, we point to the directory where the corpora are stored as follows:
```
library(rcr)
set_riksdag_corpora_path("[THE PATH TO THE CORPORA HERE]")
```

To extract speeches from the corpora, we use ```extract_speeches_from_records()```. Below is an example that assumes that the corpora path has been set and extracts the speeches from three different records.

```
fps <-
  c("data/1896/prot-1896--ak--042.xml",
    "data/1951/prot-1951--fk--029.xml",
    "data/1975/prot-1975--036.xml")
sp <- extract_speeches_from_records(fps)
```

Similarly we can extract the dates from the records with
```
ds <- extract_record_dates_from_records(fps)
```
