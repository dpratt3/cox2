# Install and load the necessary packages
if (!requireNamespace("RSQLite", quietly = TRUE)) {
  install.packages("RSQLite")
}
if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
if (!requireNamespace("caret", quietly = TRUE)) {
  install.packages("caret")
}

library(RSQLite)
library(readr)
library(caret)

# Attach dataset from caret package
data(cox2)
data = cbind.data.frame(cox2Descr, cox2IC50, cox2Class)

# Define the database file name
db_file <- "cox2.db"

# Connect to the SQLite database
con <- dbConnect(SQLite(), db_file)
data$cox2Class = ifelse(data$cox2Class == "Inactive", 0, 1)
table_name = "cox2Data"

# Specify the table name and write the data to the database
tryCatch({
  dbWriteTable(con, name = table_name, value = data, overwrite = TRUE)
  cat("Data has been written to the database.\n")
}, error = function(e) {
  cat("Error while writing data to the database:\n")
  print(e)
})

# Close connection
dbDisconnect(con)

cat("Database has been created and seeded with data.\n")
