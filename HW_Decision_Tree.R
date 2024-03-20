# LOAD 

# Read the ToyotaCorolla dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/ToyotaCorolla.csv")
# Load external function
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")

# MANAGE

# Remove unnecessary column
df$Model = NULL
# Convert Met_Color and Automatic columns to logical
df$Met_Color = as.logical(df$Met_Color)
df$Automatic = as.logical(df$Automatic)
# Convert Fuel_Type column to factor
df$Fuel_Type = as.factor(df$Fuel_Type)

# PARTITION

# Get the number of rows in the dataset
N = nrow(df)
# Define the size of the training set as 60% of the total dataset
training_size = round(N*0.6) #60% goes to the data set 
# Set seed for reproducibility
set.seed(1234)
# Randomly select indices for the training set
training_cases = sample(N, training_size)
# Create the training set using the selected indices
training = df[training_cases, ]
# Create the test set using the remaining indices
test = df[-training_cases, ] 

# BUILD

# Load required libraries
library(rpart)
library(rpart.plot)
# Set stopping rules for pruning
stoppingRules = rpart.control(minsplit=1,minbucket=1, cp=-1)
# Build a decision tree model
model = rpart(Price ~ ., data=training, control=stoppingRules)
# Prune the decision tree model
pruned = easyPrune(model)
# Plot the pruned decision tree
rpart.plot(pruned)

#Predict

# Make predictions on the test set using the pruned decision tree model
predictions = predict(pruned, test)

# Evaluate 

# Get the true car prices from the test set
observations = test$Price
# Compute the errors between predicted and true prices
errors = observations - predictions
# Compute performance metrics

# Root Mean Squared Error (RMSE)
rmse = sqrt(mean(errors^2))
# Mean Absolute Percentage Error (MAPE)
mape = mean(abs(errors/observations))

# Benchmark Predictions and Evaluation

# Compute errors between true prices and mean training set price
errors_bench = observations - mean(training$Price)
# Compute MAPE for benchmark predictions
mape_bench = mean(abs(errors_bench)/observations)