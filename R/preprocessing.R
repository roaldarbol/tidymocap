tidy_anipose <- function(data) {

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

  return(data)
}

minimum_likelihood <- function(data, likelihood) {

  low_likelihood <- which({{ data$likelihood }} < {{ likelihood }})
  myvars <- names(data) %in% c("frame", "bodypart", "likelihood")
  data[low_likelihood, !myvars] <- NA

  return(data)
}

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
