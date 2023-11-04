library(RSQLite)
library(caret)
library(ROSE)
library(PreProcess)
library(RSQLite)

# Threshold will be user specified
threshold = commandArgs(trailing = TRUE)

# Replace 'your_database.db' with the path to your SQLite database file
con <- dbConnect(SQLite(), dbname = "../cox2.db")
print(con)

query <- "SELECT * FROM cox2Data"
result <- dbGetQuery(con, query)
dbDisconnect(con)

print(result)

# incorporate threshold
result$cox2Class = ifelse(result$cox2IC50 < threshold, 0, 1)

split <- createDataPartition(result$cox2Class, p = 0.7, list=FALSE)
training <- result[split,]
testing <- result[-split,]

# Check class balance before SMOTE
cat("Class balance before SMOTE")
 table(training$cox2Class) # should be roughly equal

# SMOTE the training data to balance classes
class_label <- "cox2Class"
formula <- as.formula(paste(class_label, "~ ."))

# Apply SMOTE using the ROSE function with the formula
# smote_data <- ROSE(formula, data = training, N = nrow(training) * 2, seed = 123)
# training = smote_data$data

# Make sure dataset is balanced
cat("Class balance after SMOTE")
table(training$cox2Class) # should be roughly equal

# PCA both training and testing dat. Variance threshold insures congruency.
selected_training_columns <- training[, !names(training) %in% class_label]
selected_training_columns <- selected_training_columns[, apply(selected_training_columns, 2, var) > 0.5]
selected_testing_columns <- testing[, !names(testing) %in% class_label]
selected_testing_columns <- selected_testing_columns[, apply(selected_testing_columns, 2, var) > 0]

# Perform PCA
preProcTraining <- preProcess(selected_training_columns, method = "pca", zv = TRUE)
preProcTesting <- preProcess(selected_testing_columns, method = "pca", zv = TRUE)

# Apply the PCA transformation to your data
training <- predict(preProcTraining, selected_training_columns)
testing <- predict(preProcTesting, selected_testing_columns)

print(preProcTraining)
print(preProcTesting)

print(dim(training))
print(dim(testing))

# Use Naive Bayes. It is robust to minor variances in feature dimensions.
