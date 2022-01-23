library(tidyverse)
library(zoo)
library(plotly)

data_raw <- read.csv('/Users/roaldarbol/tracking/anipose/discus/summaries/pose_2d.csv')
data_tidy <- tidy_anipose(data_raw, 0.8, interpolate = FALSE)
data_clean <- filter_likelihood(data_tidy, 0.8)
data_cleaner <- interpolate_poses(data_tidy)
data_cleaner$y <- -data_cleaner$y # Switch up/down

framerate <- 10
rollmean_frames <- 30

data_augmented <- augment_poses(data_cleaner, 10, 10) # Adds velocities and more...
# data_summary <- analyse_discus() # Discus-specific analysis

gg <- data_augmented %>%
  filter(frame > 800 && frame < 1300) %>%
  ggplot(aes(x, y, color = bodypart)) +
    geom_point(aes(frame = frame, ids = bodypart))

ggplotly(gg) +
  animation_opts(frame = 30,
                 transition = 0)

data_cleaner %>%
  filter(frame > 800 & frame < 1300) %>%
  plot_ly(
    x = ~x,
    y = ~y,
    frame = ~frame,
    color = ~bodypart,
    type = 'scatter',
    mode = 'markers',
    showlegend = TRUE
  ) %>%
  animation_opts(
    frame = 10,
    transition = 0
  )


