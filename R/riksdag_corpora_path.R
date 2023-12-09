#' Set and get the path to the Riksdag Corpora
#'
#' @param riksdag_corpora_path The path
#' @export
get_riksdag_corpora_path <- function(){
  Sys.getenv("RIKSDAG_CORPORA_PATH")
}

#' @rdname get_riksdag_corpora_path
#' @export
set_riksdag_corpora_path <-function(riksdag_corpora_path){
  checkmate::assert_directory_exists(riksdag_corpora_path)
  Sys.setenv("RIKSDAG_CORPORA_PATH"=riksdag_corpora_path)
}

