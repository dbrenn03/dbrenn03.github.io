# Load required libraries
library(randomForest)
library(rpart)
library(readr)
library(gbm)

# Read the BostonHousing dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/BostonHousing.csv")
# Load external function
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")

# MANAGE

# Convert ISHIGHVAL column to logical
df$ISHIGHVAL = as.logical(df$ISHIGHVAL)
# Remove MEDV column
df$MEDV = NULL
# Convert CHAS and RAD columns to factors
df$CHAS = as.factor(df$CHAS)
df$RAD = as.factor(df$RAD)

# PARTITION

# Get the number of rows in the dataset
N = nrow(df)
# Define the size of the training set as 60% of the total dataset
training_size = round(N*0.6)
# Set seed for reproducibility
set.seed(1234)
# Randomly select indices for the training set
training_cases = sample(N, training_size)
# Create the training set using the selected indices
training = df[training_cases, ]
# Create the test set using the remaining indices
test = df[-training_cases, ]

# BUILD 

# Set stopping rules for decision tree model
stopping_rules = rpart.control(minsplit=1,mindbucket=1,cp=-1)
# Build a decision tree model with default parameters
model_default = rpart(ISHIGHVAL~., data = training, control = stopping_rules) 
# Prune the decision tree model
model_default = easyPrune(model_default)
# Build a random forest model with 500 trees
rf = randomForest(ISHIGHVAL~., data = training, ntree=500)
# Build a gradient boosting machine model with 5000 trees
boost = gbm(ISHIGHVAL~., data = training, n.trees=5000, cv.folds = 4)
# Determine the optimal number of trees for gradient boosting machine
best_size = gbm.perf(boost)

# PREDICT

# Get the true ISHIGHVAL values from the test set
observations = test$ISHIGHVAL
# Make predictions using the decision tree model
predictions = predict(model_default, test) 
# Convert probabilities to binary predictions for decision tree model
predictions = predictions > 0.5
# Make predictions using the random forest model
pred_rf = predict(rf, test)
# Convert probabilities to binary predictions for random forest model
pred_rf = pred_rf > 0.5 
# Make predictions using the gradient boosting machine model
predict_boost = predict(boost,test,best_size, type="response")
# Convert probabilities to binary predictions for gradient boosting machine model
predict_boost = predict_boost > 0.5 

# EVALUATE

# Compute error rate for decision tree model
error_rate = sum(predictions != observations)/nrow(test)
# Compute error rate for random forest model
error_rate_rf = sum(pred_rf != observations)/nrow(test)
# Compute error rate for gradient boosting machine model
error_boost = sum(predict_boost != observations)/nrow(test)

# STACKING

# Make predictions for gradient boosting machine and random forest models on the entire dataset
pred_boost_full = predict(boost, df, best_size, type="response")
pred_rf_full = predict(rf, df)
# Combine predictions with original dataset
df_stacked = cbind(df,pred_boost_full, pred_rf_full)
# Convert ISHIGHVAL column to factor
df_stacked$ISHIGHVAL = as.factor(df$ISHIGHVAL)
# Create stacked training set
train_stacked = df_stacked[training_cases, ]
# Create stacked test set
test_stacked = df_stacked[-training_cases, ]
# Build logistic regression model for stacking
stacked = glm(ISHIGHVAL ~ ., data = train_stacked, family=binomial)
# Make predictions using the stacked model
pred_stacked = predict(stacked, test_stacked, type="response")
# Convert probabilities to binary predictions for stacked model
pred_stacked = (pred_stacked > 0.5)
# Compute error rate for stacked model
error_stacked = sum(pred_stacked != test$ISHIGHVAL)/nrow(test)