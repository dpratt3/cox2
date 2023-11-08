setwd("~/git/cox/scripts")
library(RSQLite)
library(caret)
library(RSQLite)
library(randomForest)
library(pROC)

set.seed(123)

# # # Threshold will be user specified
threshold = as.numeric(commandArgs(trailing = TRUE))

# # # Replace 'your_database.db' with the path to your SQLite database file
# con <- dbConnect(SQLite(), dbname = "../cox2.db")
# # print(con)

# query <- "SELECT * FROM cox2Data"
# result <- dbGetQuery(con, query)
# dbDisconnect(con)

# Attach dataset from caret package
data(cox2)
data = cbind.data.frame(cox2Descr, cox2IC50, cox2Class)
result = data
data$cox2Class = ifelse(data$cox2Class == "Inactive", 0, 1)

# print(result)

split <- createDataPartition(result$cox2IC50, p = 0.8, list=FALSE)
training <- result[split, !names(result) %in% "cox2Class"]
class_actual <- result[-split, names(result) %in% "cox2Class"]
testing <- result[-split, !names(result) %in% "cox2Class"]

# Find the optimal level for mtry
# x <- training[, -ncol(training)]  
# y <- training[, ncol(training)]  

# # Now you can use tuneRF
# tuneRF(x, y, stepFactor = 1.5)

model <- randomForest(cox2IC50 ~ ., 
                      data = training, 
                      ntree = 1499, 
                      mtry = 30, 
                      nodesize = 0.25,
                      rsq = TRUE)

predictions <- predict(model, testing)

residuals = testing$cox2IC50 - predictions

class_predictions = ifelse(predictions > threshold, 1, 0)
class_actual = ifelse(testing$cox2IC50 > threshold, 1, 0)

# print(class_predictions)
# print(class_actual)

confusion_matrix <- table(class_actual, class_predictions)
print(confusion_matrix)

# Accuracy
accuracy <- (confusion_matrix[1, 1] + confusion_matrix[2, 2]) / sum(confusion_matrix)
cat("Accuracy:", accuracy, "\n")

# Precision
precision <- confusion_matrix[2, 2] / sum(confusion_matrix[, 2])
cat("Precision:", precision, "\n")

# Recall (Sensitivity)
recall <- confusion_matrix[2, 2] / sum(confusion_matrix[2, ])
cat("Recall:", recall, "\n")

# Specificity
specificity <- confusion_matrix[1, 1] / sum(confusion_matrix[1, ])
cat("Specificity:", specificity, "\n")

# F1-Score
f1_score <- 2 * (precision * recall) / (precision + recall)
cat("F1-Score:", f1_score, "\n")

# ROC-AUC
roc_auc <- auc(roc(class_actual, class_predictions))
cat("ROC-AUC:", roc_auc, "\n")

