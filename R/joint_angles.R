#' Joint angles
#'
#' @param data Data frame
#' @param joints Joints
#'
#' @return
#' @export

joint_angles <- function(data, joints) {
  #https://stackoverflow.com/a/1211243/13240268
  output <- data %>%
    select(frame) %>%
    as_tibble()

  joint_names <- names(joints)

  for (i in 1:length(joints)) {
    joint_name <- joint_names[i]
    i_data <- as_tibble(joints[[i]])
    arm <- select(i_data, "arm") %>%
      as_vector()
    arm_x <- sym(paste("x", arm, sep = "_"))
    arm_y <- sym(paste("y", arm, sep = "_"))
    vertex <- select(i_data, "vertex") %>%
      as_vector()
    vertex_x <- sym(paste("x", vertex, sep = "_"))
    vertex_y <- sym(paste("y", vertex, sep = "_"))
    base <- select(i_data, "base") %>%
      as_vector()
    base_x <- sym(paste("x", base, sep = "_"))
    base_y <- sym(paste("y", base, sep = "_"))

    if ("z" %in% colnames(data)) {
      arm_z <- sym(paste("z", arm, sep = "_"))
      vertex_z <- sym(paste("z", vertex, sep = "_"))
      base_z <- sym(paste("z", base, sep = "_"))
    }

    temp <- data %>%
      filter(bodypart %in% i_data) %>%
      pivot_wider(
        names_from = bodypart,
        values_from = c(x,y,likelihood)) %>%
      mutate(
        dist_vertex_arm = sqrt(( !!vertex_x - !!arm_x )^2 + ( !!vertex_y - !!arm_y )^2),
        dist_vertex_base = sqrt(( !!vertex_x - !!base_x )^2 + ( !!vertex_y - !!base_y )^2),
        dist_arm_base = sqrt(( !!base_x - !!arm_x )^2 + ( !!base_y - !!arm_y )^2),
        angle = acos((.data$dist_vertex_arm^2 + .data$dist_vertex_base^2 - .data$dist_arm_base^2) / (2 * .data$dist_vertex_arm * .data$dist_vertex_base)),
        joint = joint_name
      ) %>%
      select(frame, joint, angle)

    output <- bind_rows(output, temp)
  }
  output <- arrange(output, frame) %>%
    drop_na(joint) %>%

  return(output)
}
