# Imports 
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")

library(mice)
library(tidyverse)
library(stringr)
library(tidyr)
library(rpart)
library(rpart.plot)
library(gmodels)
library(randomForest)
library(caret)


# Load in Data Frame's Test and Train 

df = read.csv("C:/Users/domin/OneDrive/Desktop/Field Project/ML Project One/train.csv")
#test_1 = read.csv("C:/Users/domin/OneDrive/Desktop/Field Project/ML Project One/test.csv")
# Create a variable (Data Frames had to match to combine)
#PassengerId =  test_1$PassengerId 
# Keeping Track which is test and training 
#test_1$Transported = NA
#Combine Data Sets
#df = rbind(train_1, test_1)

#Manage/ Data cleaning

# Used this as a reference:
# https://www.kaggle.com/code/rizkymerdietio/spaceship-titanic-with-r

# Replacing empty strings and NAs with NA
df[df == "" | is.na(df) | df == "Inf"] = NA

# Extracting relevant information from Cabin column
df$side = str_sub(df$Cabin, -1)
df$PassengerId = str_sub(df$PassengerId, 1, 4)
df$deck = str_sub(df$Cabin, 1, 1)
df$num = str_sub(df$Cabin, 3, 3)

# Handling missing values in newly created columns
df$deck[is.na(df)] == "None"
df$side[is.na(df)] == "None"
df$HomePlanet[is.na(df)] == "None"
df$Transported[is.na(df$Transported)] = "None"
df$num[is.na(df)] == "None"
df$Destination[is.na(df)] == "None"
df$CryoSleep[is.na(df)] == "None"
df$VIP[is.na(df)] == "None"

# Converting categorical variables to factors
df$deck = as.factor(df$deck)
df$side = as.factor(df$side)
df$HomePlanet = as.factor(df$HomePlanet)
df$Destination = as.factor(df$Destination)
df$CryoSleep = as.factor(df$CryoSleep)
df$VIP = as.factor(df$VIP)
df$Transported = as.logical(df$Transported)
df$cabin_s = NULL
df$Cabin = NULL 
df$PassengerId = NULL
df$Name = NULL

# Handling corrupt data by replacing 0s with NA
df$RoomService[df$RoomService == 0] = NA
df$FoodCourt[df$FoodCourt == 0] = NA
df$ShoppingMall[df$ShoppingMall == 0] = NA
df$Spa[df$Spa == 0] = NA
df$VRDeck[df$VRDeck == 0] = NA

# Bootstrapping
impute_df = mice(df, m = 1, method = 'sample')
df = complete(impute_df)

# Partitioning
N = nrow(df)
trainingSize  = round(N * 0.6)
trainingCases = sample(N, trainingSize)
training = df[trainingCases,]
test     = df[-trainingCases,]

# CLASSIFICATION TREE

# Build
model_default = rpart(Transported ~ ., data = training)
rpart.plot(model_default)

# Predict
predictions = predict(model_default, test) > 0.5
observations = test$Transported

# Evaluate
error_tree = sum(predictions != observations) / nrow(test)
error_tree_bench = benchmarkErrorRate(training$Transported, test$Transported)

stopping_rules = rpart.control(minsplit = 2, mindbucket = 1, cp = -1)
model_default = rpart(Transported ~ ., data = training, control = stopping_rules)

predictions_stopping_rules = predict(model_default, test) > 0.5
error_stopping_rules = sum(predictions_stopping_rules != observations) / nrow(test)

# Pruning
model = easyPrune(model_default)
predictions_pruned = predict(model, test) > 0.5
error_pruned = sum(predictions_pruned != observations) / nrow(test)
table(predictions_pruned, observations)
rpart.plot(model)

# Logistic Regression
glm1 = glm(Transported ~ ., data = training, family = binomial)
glm2 = step(glm1) # Removes all the unnecessary variables
summary(glm2)

# Predict
predictions = predict(glm2, test, type = "response")
predictions_tf = (predictions > 0.5)

# Evaluate
observations = test$Transported
table(predictions_tf, observations)

error_rate_glm <- sum(predictions_tf != observations) / nrow(test)

error_glm_bench = benchmarkErrorRate(training$Transported, test$Transported)

Sensitivity = sum(predictions_tf == TRUE & observations == TRUE) / sum(observations == TRUE)
Specificity = sum(predictions_tf == FALSE & observations == FALSE) / sum(observations == FALSE)

ROCChart(test$Transported, predictions_tf)

liftChart(observations, predictions_tf)


plot_gg = function(column) {
  ggplot(data = df, mapping = aes(x = {{column}}, fill = Transported)) +
    geom_bar(position = 'dodge') +
    scale_fill_manual('legend', values = c("Orange", "Red"))
}

# Plotting graphs for different variables
plot_gg(CryoSleep) + 
  ggtitle("Cryosleep Transported Counts")

plot_gg(VIP) + 
  ggtitle("VIP Transported counts")

plot_gg(Destination) + 
  ggtitle("Destination Transported Counts")