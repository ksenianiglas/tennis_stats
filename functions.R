library(RCurl)
library(tidyverse)

# read necessary data
get_tennis_data <- function(tour, years) {
  lapply(years, function(year) {
    pth <- str_c("https://raw.githubusercontent.com/JeffSackmann/tennis_",
                 tour,
                 "/master/",
                 tour,"_matches_",
                 year,
                 ".csv")
    
    pth %>%
      getURL() %>%
      read_csv()
  }) %>%
    reduce(rbind) %>%
    mutate(year = str_sub(tourney_date, 1, 4))
}

# count no of games lost
no_of_games_lost <- function(score) {
  if (score %in% c("W/O", "Walkover")) {
    return(0)
  }
  score %>%
    str_split(" ")  %>%
    unlist() %>%
    setdiff("RET") %>%
    lapply(function(game) {
      str_split(game, "-") %>%
        reduce(c) %>%
        .[seq(2, length(.), by = 2)] %>%
        str_sub(1, 1) %>%
        as.numeric() %>%
        sum()
    }
    ) %>%
    unlist() %>%
    sum()
}

