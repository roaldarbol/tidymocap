#' Rad2Deg
#'
#' Changes between radians and degrees
#' @param ang Angle in radians
#' @export
#'

rad2deg <- function(ang){
  val <- (ang * 180) / pi
  return(val)
}

#' Deg2Rad
#'
#' Changes between radians and degrees
#' @param ang Angle in degrees
#' @export
#'
deg2rad <- function(ang){
  val = (ang * pi) / 180
  return(val)
}
