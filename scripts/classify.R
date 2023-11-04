library(RSQLite)
library(caret)
library(ROSE)

# Threshold will be user specified
threshold = commandArgs(trailing = TRUE)

library(RSQLite)

# Replace 'your_database.db' with the path to your SQLite database file
con <- dbConnect(SQLite(), dbname = "../cox2.db")
print(con)

query <- "SELECT * FROM cox2Data"
result <- dbGetQuery(con, query)

print(result)

# incorporate threshold
result$cox2Class = ifelse(result$cox2IC50 < threshold, 0, 1)

split <- createDataPartition(result$cox2Class, p = 0.8, list=FALSE)
training <- result[split,]
test <- result[-split,]

# Check class balance before SMOTE
cat("Class balance before SMOTE")
 table(training$cox2Class) # should be roughly equal

# SMOTE the training data to balance classes
class_label <- "cox2Class"
formula <- as.formula(paste(class_label, "~ ."))

# Apply SMOTE using the ROSE function with the formula
smote_data <- ROSE(formula, data = training, N = nrow(training) * 2, seed = 123)
training = smote_data$data

# Make sure dataset is balanced
cat("Class balance after SMOTE")
 table(training$cox2Class) # should be roughly equal