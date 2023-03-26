library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

game_data <- read_csv("data/nba_games_2021/urls2021/nba_2021_game_urls.csv")

# Loop over the game URLs and scrape the data for each game
for (i in seq_len(nrow(game_data))) {
  
  page <- read_html (game_data$url[i])
  
  left_team <- page |>
    html_elements(".thead .center:nth-child(2)") |>
    html_text()
  
  right_team <- page |>
    html_elements(".center:nth-child(6)") |>
    html_text()
  
  scores <- page |>
    html_elements("td.center") |>
    html_text()
  
  time <- page |>
    html_elements ("#pbp td:nth-child(1)") |>
    html_text()
  
  date <- page |>
    html_elements (".scorebox_meta div:nth-child(1)") |>
    html_text()
  
  record <- page |>
    html_elements(".scores+ div") |>
    html_text()
  
  nba_game_log <- tibble(
    score = scores,
    time_rem = time
  )
  
  nba_game_log <- nba_game_log |>
    distinct(score, .keep_all = T) |>
    separate(score, into = c(left_team[1], right_team[1]), sep = "-")
  
  nba_game_log$time_rem <- ms(nba_game_log$time_rem)
  quart <- 3
  for (i in 1:nrow(nba_game_log)){
    curr <- nba_game_log$time_rem[i]
    nba_game_log$time_rem[i] <- curr + quart*ms("12:00")
    if (curr == 0) {
      if (grepl("End of", nba_game_log[[1]][i], fixed = T)) {
        quart <- quart -1 
      }
    }
    if (quart < 0) {break}
  }
  
  nba_game_log[1, left_team[1]] <- record[1]
  
  nba_game_log[1, right_team[1]] <- record[2]
  
  date_split <- strsplit(date, ", ") |>
    sapply("[", c(2,3))
  
  month_day <- strsplit(date_split[1], " ")
  
  file_name <- paste0(paste(left_team[1], right_team[1], month_day[[1]][1], 
                            month_day[[1]][2], date_split[2], sep = "_"))
  
  write_csv(nba_game_log, paste0("data/nba_games_2021/", file_name, ".csv"))
  
  Sys.sleep(3)
}
