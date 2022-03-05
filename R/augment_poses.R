#' Augment poses
#'
#' @param data Data frame
#' @param framerate Frame rate
#' @param rollmean_frames Number of frames for rolling mean
#'
#' @import dplyr
#' @importFrom zoo rollmean
#'
#' @return
#' @export
#'
augment_poses <- function(data, framerate, rollmean_frames){
  if (!is.null(data[['z']])){
    data %>%
      group_by(bodypart) %>%
      mutate(x = zoo::rollmean(x, rollmean_frames, na.pad = TRUE),
             x_d = abs(x - lag(x)),
             y_d = abs(y - lag(y)),
             z_d = abs(z - lag(z)),
             d = sqrt(x_d^2 + y_d^2 + z_d^2),
             x_v = x_d * framerate,
             y_v = y_d * framerate,
             z_v = z_d * framerate,
             v = d * framerate,
             x_a = abs(x_v - lag(x_v)) * framerate,
             y_a = abs(y_v - lag(y_v)) * framerate,
             z_a = abs(z_v - lag(z_v)) * framerate,
             a = abs(v - lag(v)) * framerate,
      )
  } else {
    data %>%
      group_by(bodypart) %>%
      mutate(x = zoo::rollmean(x, rollmean_frames, na.pad = TRUE),
             x_d = abs(x - lag(x)),
             y_d = abs(y - lag(y)),
             d = sqrt(x_d^2 + y_d^2),
             x_v = x_d * framerate,
             y_v = y_d * framerate,
             v = d * framerate,
             x_a = abs(x_v - lag(x_v)) * framerate,
             y_a = abs(y_v - lag(y_v)) * framerate,
             a = abs(v - lag(v)) * framerate,
      )
  }
}
