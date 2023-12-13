<!-- badges: start -->
[![R-CMD-check](https://github.com/swerik-project/rcr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/swerik-project/rcr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->
  
# The Riksdag Corpora R package


## Installation

To install the R package, simply run:
```
library(remotes)
remotes::install_github('swerik-project/rcr')
```

## Use
To use the R package you need to download the riksdriksdagen corpus [here](https://github.com/welfare-state-analytics/riksdagen-corpus). The as a first step we point to the directory where the corpus is stored as follows:
```
set_riksdag_corpora_path("[THE PATH TO THE CORPORA HERE]")
```

To extract speeches from the corpus we use ```extract_speeches_from_records()```. Below is an example that assume that the corpora path has has been set and extract the speeches from three different records.

```
fps <-
  c("protocols/1896/prot-1896--ak--042.xml",
    "protocols/1951/prot-1951--fk--029.xml",
    "protocols/1975/prot-1975--036.xml")
sp <- extract_speeches_from_records(fps)
```


