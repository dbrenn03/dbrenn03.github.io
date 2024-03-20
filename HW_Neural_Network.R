# Load required libraries
library(nnet)
library(NeuralNetTools)
# Load external function
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")

# Read the UniversalBank dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/UniversalBank.csv.")

# Data Preprocessing

# Standardize the data
library(caret)
standardizer = preProcess(df, method=c("center", "scale"))
df = predict(standardizer, df)

# MANAGE

# Remove unnecessary columns
df$ID = NULL
df$ZIP.Code = NULL
# Convert Education, Personal.Loan, Securities.Account, CD.Account, Online, CreditCard columns to factors
df$Education = as.factor(df$Education)
df$Personal.Loan = as.factor(df$Personal.Loan)
df$Securities.Account = as.factor(df$Securities.Account)
df$CD.Account = as.factor(df$CD.Account)
df$Online = as.factor(df$Online)
df$CreditCard = as.factor(df$CreditCard)

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

# MODEL

# Build a neural network model with 4 hidden neurons
Model = nnet(Personal.Loan ~ ., data = training, size = 4)
# Plot the neural network model
par(mar = numeric(4))
plotnet(Model, pad_x = 0.5)

# PREDICT

# Make predictions using the neural network model
predictions = as.factor(predict(Model, test, type ="class" ))
# Get the true Personal Loan values from the test set
observations = test$Personal.Loan

# Evaluate

# Create a contingency table of predicted vs observed values
table(predictions, observations)
# Compute error rate
error_rate = sum(predictions != observations) / nrow(test)