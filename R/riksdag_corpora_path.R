#' Set and get the path to the Riksdag Corpora
#'
#' @param riksdag_corpora_path The path
#' @export
get_riksdag_corpora_path <- function(){
  Sys.getenv("RIKSDAG_CORPORA_PATH")
}

#' @rdname get_riksdag_corpora_path
#'
#' @param riksdag_corpora_path a full path to a riksdag corpus
#'
#' @export
set_riksdag_corpora_path <-function(riksdag_corpora_path){
  checkmate::assert_directory_exists(riksdag_corpora_path)
  assert_riksdag_repo(riksdag_corpora_path)
  Sys.setenv("RIKSDAG_CORPORA_PATH"=riksdag_corpora_path)
}

assert_riksdag_repo <- function(riksdag_corpora_path){
  cfn <- file.path(riksdag_corpora_path,"CITATION.cff")
  if(!checkmate::test_file_exists(cfn)){
    stop("File path does not contain CITATION.cff")
  } else {
    cff <- yaml::read_yaml(cfn)
    nms <- c("title", "version", "date-released", "repository-code", "url")
    checkmate::assert_names(names(cff), must.include = nms)
    message(yaml::as.yaml(cff[nms]))
  }
}

