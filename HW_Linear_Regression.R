# LOAD 

# Read the BostonHousing dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/BostonHousing.csv")

# MANAGE

# Remove the ISHIGHVAL column from the dataset
df$ISHIGHVAL = NULL
# Convert CHAS and RAD columns to factors
df$CHAS = as.factor(df$CHAS)
df$RAD = as.factor(df$RAD)

# Partition

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

# Build a linear regression model predicting MEDV using all available variables
model = lm(MEDV ~ ., data=training)
# Print summary of the model
summary(model)

# Perform stepwise model selection
model = step(model)
# Print summary of the updated model
summary(model)

# PREDICTION

# Make predictions on the test set using the trained model
predictions = predict(model, test)

# EVALUATE 

# Find the true house values in the test set
observations = test$MEDV
# Compute the errors between predicted and true values
errors = observations - predictions
# Compute performance metrics

# Root Mean Squared Error (RMSE)
rmse = sqrt(mean(errors^2))
# Mean Absolute Percentage Error (MAPE)
mape = mean(abs(errors/observations))

# Benchmark Predictions and Evaluation
# Predictions using the mean of the training set MEDV as the benchmark
predictions_bench = mean(training$MEDV)
# Errors between true values and benchmark predictions
errors_bench = observations - predictions_bench
# Root Mean Squared Error for benchmark
rmse_bench = sqrt(mean(errors_bench^2))
# Mean Absolute Percentage Error for benchmark
mape_bench = mean(abs(errors_bench/observations)))