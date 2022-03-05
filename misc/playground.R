library(tidyverse)
library(zoo)
library(plotly)
library(yaml)
library(tidymocap)

yaml::write_yaml(unique(data_tidy$bodypart), "openpose")
data_raw <- read.csv('/Users/roaldarbol/tracking/anipose/discus/summaries/pose_2d.csv')
data_tidy <- tidy_anipose(data_raw, 0.8, interpolate = FALSE)
data_tidy$bodypart <- as_factor(data_Ætidy$bodypart)
data_clean <- filter_likelihood(data_tidy, 0.8)
data_cleaner <- interpolate_poses(data_tidy)
data_cleaner$y <- -data_cleaner$y # Switch up/down
data_augmented <- augment_poses(data_cleaner, 10, 10) # Adds velocities and more...

framerate <- 10
rollmean_frames <- 30


# data_summary <- analyse_discus() # Discus-specific analysis

gg <- data_augmented %>%
  filter(#frame > 800,
         #frame < 1300,
         bodypart == "forehead") %>%
  ggplot(aes(frame, x)) +
    geom_line()

ggplotly(gg) +
  animation_opts(frame = 30,
                 transition = 0)

# TEST 3D PLOT
data_aug <- data_augmented %>%
  mutate(z = y,
         y = 10)
data_aug %>%
  filter(frame > 800 & frame < 1300) %>%
  plot_ly(
    x = ~x,
    y = ~y,
    z = ~z,
    frame = ~frame,
    color = ~sqrt(v)) %>%
  add_markers() %>%
  animation_opts(
    frame = 20,
    transition = 0
  )


