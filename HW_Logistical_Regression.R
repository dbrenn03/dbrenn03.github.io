# LOAD 

# Read the ebayAuctions dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/ebayAuctions.csv")

# MANAGE

# Convert categorical variables to factors
df$Category = as.factor(df$Category)
df$Currency = as.factor(df$Currency)
df$EndDay = as.factor(df$EndDay)
# Remove unnecessary columns
df$ClosePrice = NULL
# Convert Competitive column to logical
df$Competitive = as.logical(df$Competitive)

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

# Build

# Build a logistic regression model
model = glm(Competitive ~., data=training, family=binomial)
# Perform stepwise model selection to remove unnecessary variables
model = step(model)
# Print summary of the model
summary(model)

# PREDICTION

# Make predictions on the test set using the trained model
predictions = predict(model, test, type="response")
# Convert probabilities to binary predictions
predictions_tf = (predictions > 0.5)

# EVALUATE 

# Get the true competitive status from the test set
observations = test$Competitive
# Create a confusion matrix of predicted vs actual competitive status
table(predictions_tf, observations)

# Compute accuracy rate
accuracy_Rate = sum(predictions_tf == observations)/nrow(test)
# Compute error rate
error_rate = sum(predictions_tf != observations)/nrow(test)

# Benchmark Predictions and Evaluation

# Load benchmark error rate function from external file
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")
# Compute benchmark error rate
error_bench = benchmarkErrorRate(training$Competitive, test$Competitive)

# Compute ratio of error rate to benchmark error rate
ratio = error_rate / error_bench

# Compute sensitivity and specificity
library(caret)
sensitivity = sensitivity(table(predictions_tf, observations))
specificity = specificity(table(predictions_tf, observations))

# Plot ROC curve
ROCChart(observations, predictions)
# Plot lift chart
liftChart(observations, predictions)



