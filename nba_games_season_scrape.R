library(tidyverse)
library(rvest)
library(lubridate)

base_url <- "https://www.basketball-reference.com"

# Create a list of months in the NBA 2021 season
months <- c("december", "january", "february", "march", "april", "may", "june", "july")

# Create an empty tibble to store the game data
game_data <- tibble()

# Loop over the months and scrape the game data
for (month in months) {
  # Create the URL for the month's game page
  url <- paste0(base_url, "/leagues/NBA_2021_games-", month, ".html")
  
  # Scrape the game data from the page
  page <- read_html(url)
  games <- page %>% html_elements(".center a") %>% html_attr("href")
  
  # Extract the game IDs from the game URLs and generate the URLs for the pbp pages
  game_ids <- games %>% str_extract("\\d{8}") %>% unique()
  pbp_urls <- paste0(base_url, "/boxscores/pbp/", game_ids, ".html")
  
  # Add the game data to the tibble
  game_data <- bind_rows(game_data, tibble(url = pbp_urls))
}

# Save the game data to a CSV file
write_csv(game_data, "nba_2021_game_urls.csv")
