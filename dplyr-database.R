## working with databases in R
library(dplyr)

## Connect to the database
my_db <- src_sqlite("data/portal_data.sqlite")

## You can ask for simple queries
tbl(my_db, sql("SELECT * FROM surveys"))

## You can make more complex queries to prepare the data frame you'll need in
##  your analysis
surveys_query <- tbl(my_db,
    sql("SELECT surveys.record_id, surveys.month, surveys.day, surveys.year,
        surveys.plot_id, surveys.hindfoot_length, surveys.weight,
        species.genus, species.species
        FROM surveys
        JOIN species
        ON species.species_id = surveys.species_id
        "))

## To get all the data in memory you need to use the collect function
surveys <- collect(surveys_query)

## It becomes powerful when you want to combine R code with your SQL
## Here we create a sequence for every other year for which we have data
seq_year <- seq(min(surveys$year), max(surveys$year), by = 2)

surveys_query %>% 
  filter(year %in% seq_year)
