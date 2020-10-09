df_wta <- get_tennis_data("wta", 1968:2020)
GS_winners_wta <- df_wta %>%
  filter(tourney_level == "G" & round == "F") %>%
  select(winner_name, tourney_name, year)

df_atp <- get_tennis_data("atp", 1968:2020)
GS_winners_atp <- df_atp %>%
  filter(tourney_level == "G" & round == "F") %>%
  select(winner_name, tourney_name, year)

# Number of games lost
df_wta %>%
  semi_join(GS_winners_wta, by = c("tourney_name", "winner_name", "year")) %>%
  select(winner_name, tourney_name, year, score) %>%
  rowwise() %>%
  mutate(games_lost = no_of_games_lost(score)) %>%
  group_by(winner_name, tourney_name, year) %>%
  summarise(no_of_games_lost = sum(games_lost)) %>%
  arrange(no_of_games_lost)

# Time on court
df_atp %>%
  semi_join(GS_winners_atp, by = c("tourney_name", "winner_name", "year"))  %>%
  filter(year > 2000) %>%
  select(winner_name, tourney_name, year, minutes) %>%
  filter(!is.na(minutes)) %>%
  group_by(winner_name, tourney_name, year) %>%
  summarise(mins_on_court = sum(minutes)) %>%
  arrange(-mins_on_court) 

#games per tournament
df_wta %>%
  filter(tourney_level == "G") %>%
  select(winner_name, tourney_name, year, score) %>%
  rowwise() %>%
  mutate(games_played = no_of_games_played(score)) %>%
  group_by(tourney_name) %>%
  summarise(no_of_games_playd = sum(games_played)) %>%
  arrange(no_of_games_playd)
