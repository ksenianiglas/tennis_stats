library(RCurl)
library(tidyverse)

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
    reduce(rbind)
  }
