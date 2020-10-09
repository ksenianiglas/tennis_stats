df <- get_tennis_data("atp", 2001:2020)

GS_winners <- df %>%
  filter(tourney_level == "G" & round == "F") %>%
  select(winner_name, tourney_name, year)

df %>%
  semi_join(GS_winners, by = c("tourney_name", "winner_name", "year")) %>%
  select(winner_name, tourney_name, year, score) %>%
  rowwise() %>%
  mutate(games_lost = no_of_games_lost(score)) %>%
  group_by(winner_name, tourney_name, year) %>%
  summarise(no_of_games_lost = sum(games_lost)) %>%
  arrange(no_of_games_lost)
  
