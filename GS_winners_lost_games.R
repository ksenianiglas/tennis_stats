df <- get_tennis_data("wta", 2010:2020)

GS_winners <- df %>%
  filter(tourney_level == "G" & round == "F") %>%
  select(winner_name, tourney_name, year)

df %>%
  semi_join(GS_winners, by = c("tourney_name", "winner_name", "year")) %>%
  select(winner_name, tourney_name, year, score) %>%
  mutate(games_lost = (score %>%
                        str_split(" ")  %>%
                        lapply(function(game) {
                          str_split(game, "-") %>%
                            reduce(c) %>%
                            .[seq(2, length(.), 2)] %>%
                            str_sub(1, 1) %>%
                            as.numeric() %>%
                            sum()
                        }) %>%
                        unlist())) %>%
  group_by(winner_name, tourney_name, year) %>%
  summarise(no_of_games_lost = sum(games_lost)) %>%
  arrange(no_of_games_lost)
  
