library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

paths_allowed("https://www.basketball-reference.com/boxscores/pbp/202101200TOR.html")

page <- read_html ("https://www.basketball-reference.com/boxscores/pbp/202101200TOR.html")

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
  if (curr == 0) {quart <- quart -1 }
}

nba_game_log[1, left_team[1]] <- record[1]

nba_game_log[1, right_team[1]] <- record[2]

date_split <- strsplit(date, ", ") |>
  sapply("[", c(2,3))
month_day <- strsplit(date_split[1], " ")

file_name <- paste0(paste(left_team[1], right_team[1], month_day[[1]][1], 
                          month_day[[1]][2], date_split[2], sep = "_"))

write_csv(nba_game_log, paste0("data/", file_name, ".csv"))

