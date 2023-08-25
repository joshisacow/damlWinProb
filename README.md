# NBA Win Probability
As a part of the Duke Applied Machine Learning club (DAML), we have been working on this project to develop a machine learning model to evaluate the win probability of NBA games. This project eventually aims to calculate win probabilities on the fly, by scraping data or finding an API that will give live play-by-play or box score data from NBA games. The model can be trained from the data of previous seasons and used effectively on live games, which has happened on small scale so far.

## How it works
This project is built in a Python Jupyter Notebook. It uses the scikit-learn package to build a logistic regression model to evaluate the win probability of games from the 2021 NBA season. The data used was scraped in R from basketball-reference. Dash was integrated to generate dynamic and visually appealing plots for win probability representation over the course of a game.
