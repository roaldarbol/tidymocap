#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name tidy_anipose
#' @export

tidy_anipose <- function(data, likelihood = FALSE, interpolate = FALSE) {

  # Remove columns ----
  columns_remove <- c("folder_1", "filename", "project") # Can be edited
  data <- data %>%
    select(!any_of(columns_remove))

  # Correct column names ----
  axis_names <- unlist(data[1, ])
  bodypart_names <- gsub("\\..*", "", colnames(data))
  new_column_names <- tibble(axis_names, bodypart_names) %>%
    unite("new_column_names", axis_names:bodypart_names) %>%
    deframe()
  colnames(data) <- new_column_names

  # Make data long ----
  data <- data %>%
    slice(-1) %>%
    rownames_to_column("frame") %>%
    mutate(across(everything(), as.numeric)) %>%
    pivot_longer(cols = !frame,
                 names_to = "bodypart") %>%
    separate(bodypart, c("axis", "bodypart")) %>%
    pivot_wider(names_from = axis,
                values_from = value)

  if (!isFALSE(likelihood)){
    data <- filter_likelihood(data, likelihood)
  }

  if (interpolate == TRUE) {
    data <- interpolate_poses(data)
  }

  return(data)
}


