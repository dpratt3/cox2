library(RSQLite)
library(caret)
library(ROSE)
library(PreProcess)
library(RSQLite)

set.seed(123)

# Threshold will be user specified
threshold = as.numeric(commandArgs(trailing = TRUE))

# Replace 'your_database.db' with the path to your SQLite database file
con <- dbConnect(SQLite(), dbname = "../cox2.db")
print(con)

query <- "SELECT * FROM cox2Data"
result <- dbGetQuery(con, query)
dbDisconnect(con)

print(result)

# incorporate threshold
result$cox2Class = ifelse(result$cox2IC50 < threshold, 0, 1)

split <- createDataPartition(result$cox2Class, p = 0.8, list=FALSE)
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
training_pca <- predict(preProcTraining, selected_training_columns)
testing_pca <- predict(preProcTesting, selected_testing_columns)

print(preProcTraining)
print(preProcTesting)

print(dim(training))
print(dim(testing))

# Use Naive Bayes. It is robust to minor variances in feature dimensions.
training_pca$cox2Class = as.factor(training$cox2Class)

ctrl <- trainControl(
  method = "cv",          
  number = 10,           
  classProbs = FALSE,      
  summaryFunction = twoClassSummary 
)

model <- train(cox2Class ~ ., data = training_pca[, c(1:30, dim(training_pca)[[2]])], method = "rf", TrControl = ctrl)

predictions = predict(model, testing_pca[ ,1:30] )
actual = testing$cox2Class

print(actual)
print(testing)
confusion_matrix = table(actual, predictions)

# Calculate metrics
TP <- confusion_matrix[2, 2]  # True Positives
TN <- confusion_matrix[1, 1]  # True Negatives
FP <- confusion_matrix[1, 2]  # False Positives
FN <- confusion_matrix[2, 1]  # False Negatives

# Accuracy
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)

# Precision (Positive Predictive Value)
precision <- TP / (TP + FP)

# Recall (Sensitivity)
recall <- TP / (TP + FN)

# Specificity
specificity <- TN / (TN + FP)

# F1-Score
f1_score <- 2 * (precision * recall) / (precision + recall)

# Print metrics
cat("Accuracy:", accuracy, "\n")
cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("Specificity:", specificity, "\n")
cat("F1-Score:", f1_score, "\n")

print(confusion_matrix)