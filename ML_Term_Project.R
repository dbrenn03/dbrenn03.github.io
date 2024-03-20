# Load required libraries
library(randomForest)
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")
library(mice)
library(rpart)
library(rpart.plot)

# Read the dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/cs-training.csv")

# MANAGE

# Convert SeriousDlqin2yrs to logical and remove SerialNumber column
df$SeriousDlqin2yrs = as.logical(df$SeriousDlqin2yrs)
df$SerialNumber = NULL

# Predictive Imputation

# Identify missing values and impute them using random forest
idx = is.na(df$SeriousDlqin2yrs)
df$SeriousDlqin2yrs[idx]
impute_rf = mice(df, m=1, method = 'rf')
df_rf = complete(impute_rf)
df_rf$seriousDlqin2yrs[idx]

# PARTITION

# Split the dataset into training and test sets
training_cases = sample(nrow(df_rf), round(nrow(df_rf) * 0.6))
training = df_rf[training_cases, ]
test = df_rf[-training_cases, ]

# Checking if NA values are still present
sum(is.na(df_rf$MonthlyIncome))
sum(is.na(df_rf$NumberOfDependents))
sum(is.na(training))

# Random Forest

# Build a random forest model
rf = randomForest(SeriousDlqin2yrs ~., data = training, ntree = 50)
varImpPlot(rf)

# Predict using random forest
pred_rf = predict(rf, test) > 0.5

# Evaluate random forest model
observations = test$SeriousDlqin2yrs
error_rf = sum(pred_rf != observations)/nrow(test)
error_rf_bench = benchmarkErrorRate(training$SeriousDlqin2yrs, test$SeriousDlqin2yrs)

# Logistic Regression

# Build a logistic regression model
glm1 = glm(SeriousDlqin2yrs ~., data = training, family = binomial)
glm1 = step(glm1) # Remove unnecessary variables
summary(glm1)

# Predict using logistic regression
predictions = predict(glm1, test, type = "response")
predictions_tf = (predictions > 0.5)

# Evaluate logistic regression model
table(predictions_tf, observations)
table(predictions_tf, observations)/nrow(test) # Confusion matrix as a percentage
accuracy_rate_glm = sum(predictions_tf == observations)/nrow(test)
error_glm_rate = 1 - accuracy_rate_glm # or sum(predictions != observations)/nrow(test)
error_glm_bench = benchmarkErrorRate(training$SeriousDlqin2yrs, test$SeriousDlqin2yrs)

ROCChart(observations, predictions)
liftChart(observations, predictions)

# Classification Tree

# Build a classification tree model
model_default = rpart(SeriousDlqin2yrs ~., data = training)
rpart.plot(model_default)

# Predict using classification tree
predictions = predict(model_default, test) > 0.5
observations = test$SeriousDlqin2yrs

error_tree = sum(predictions != observations)/nrow(test)
error_tree_bench = benchmarkErrorRate(training$SeriousDlqin2yrs, test$SeriousDlqin2yrs)

# Pruning
stopping_rules = rpart.control(minsplit=2,mindbucket=1,cp=-1)
model_default = rpart(SeriousDlqin2yrs ~., data = training, control = stopping_rules)
predictions_stopping_rules = predict(model_default, test) > 0.5
error_stopping_rules = sum(predictions_stopping_rules != observations)/nrow(test)

model = easyPrune(model_default)
predictions_pruned = predict(model, test) > 0.5
error_pruned = sum(predictions_pruned != observations)/nrow(test)
table(predictions_pruned, observations)
rpart.plot(model)

# Stacking

# Setting up models for stacking
pred_rf_full = predict(rf, df_rf)
pred_glm1_full = predict(glm1, df_rf)
pred_tree_full = predict(model, df_rf)

# Partition
df_stack = cbind(df_rf, pred_glm1_full, pred_tree_full, pred_rf_full)
train_stack = df_stack[training_cases, ]
test_stack = df_stack[-training_cases, ]

# Build stacking model
model_stack = glm(SeriousDlqin2yrs ~., data = train_stack , family = binomial)
model_stack = step(model_stack)

# Evaluate stacking model
pred_stacked = predict(model_stack, test_stack, type="response")
pred_stacked = (pred_stacked > 0.5)
error_stacked = sum(pred_stacked != test_stack$SeriousDlqin2yrs)/nrow(test_stack)
bench_stacked = benchmarkErrorRate(train_stack$SeriousDlqin2yrs, test_stack$SeriousDlqin2yrs)