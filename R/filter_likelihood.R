#' Filter likelihood
#'
#' @param data Data frame
#' @param likelihood Minimum likelihood
#'
#' @return
#' @export

filter_likelihood <- function(data, likelihood) {

  low_likelihood <- which({{ data$likelihood }} < {{ likelihood }})
  myvars <- names(data) %in% c("frame", "bodypart", "likelihood")
  data[low_likelihood, !myvars] <- NA

  return(data)
}
