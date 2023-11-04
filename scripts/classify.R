library(RSQLite)
library(caret)

# Threshold will be user specified
threshold = commandArgs(trailing = TRUE)

library(RSQLite)

# Replace 'your_database.db' with the path to your SQLite database file
con <- dbConnect(SQLite(), dbname = "../cox2.db")
print(con)

query <- "SELECT * FROM cox2Data"
result <- dbGetQuery(con, query)

print(result)
