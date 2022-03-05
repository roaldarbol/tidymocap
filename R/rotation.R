rotation <- function(data, joints) {

}

for (i in joints) {
  a <- i[[1]]
  temp <- data_cleaner %>%
    filter(bodypart %in% a) %>%
    #pivot_wider() Bodypart and x and y
    mutate(
      across(contains("_"), ~ ),
      dist_a = sqrt((P1x - P2x)^2 + (P1y - P2y)^2),
      angle = acos((P122 + P132 - P232) / (2 * P12 * P13))
      )) #https://stackoverflow.com/a/1211243/13240268
    #pivot_longer()
}
