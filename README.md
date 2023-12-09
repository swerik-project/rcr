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


