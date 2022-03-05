#' Interpolate Poses
#'
#' @param data Data frame
#'
#' @import dplyr
#' @importFrom zoo na.spline
#'
#' @return
#' @export
#'

interpolate_poses <- function(data) {

  likelihoods <- tibble(likelihood = data$likelihood)

  if ("z" %in% names(data)) {
    data <- data %>%
      select(!likelihood) %>%
      pivot_wider(names_from = bodypart,
                  values_from = c(x,y,z)) %>%
      select(!frame)
  } else {
    data <- data %>%
      select(!likelihood) %>%
      pivot_wider(names_from = bodypart,
                  values_from = c(x,y)) %>%
      select(!frame)
  }


  for (i in 1:ncol(data)){
    if (!all(is.na(data[,i]))){
      min <- min(which(!is.na(data[,i])))
      max <- max(which(!is.na(data[,i])))
      data[min:max,i] <- zoo::na.spline(data[min:max,i], na.rm=TRUE)
    }
  }

  data <- data %>%
    rowid_to_column() %>%
    rename(frame = rowid) %>%
    pivot_longer(cols = !frame,
                 names_sep = "_",
                 names_to = c("axis", "bodypart")) %>%
    pivot_wider(names_from = axis,
                values_from = value) %>%
    bind_cols(likelihoods)

  return(data)
}
