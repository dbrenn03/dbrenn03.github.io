# Read the UniversalBank dataset
df=read.csv("C:/Users/domin/OneDrive/Desktop/Data/UniversalBank.csv")

# MANAGE

# Convert Personal.Loan column to a factor
df$Personal.Loan = as.factor(df$Personal.Loan)
# Remove unnecessary columns
df$ID = NULL
df$ZIP.Code = NULL
df$Education = NULL
df$Securities.Account = NULL
df$CD.Account = NULL
df$Online = NULL
df$CreditCard = NULL

# Standardize the remaining variables
standardizer = preProcess(df,method=c("center","scale"))
df = predict(standardizer, df)

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

# Build a k-Nearest Neighbors model with k=3
model = knn3(Personal.Loan ~ ., data = training, k = 3)

# PREDICT

# Make predictions on the test set using the trained model
predictions = predict(model, test, type="class")

# EVALUATE

# Get the true loan status from the test set
observations = test$Personal.Loan
# Create a confusion matrix of predicted vs actual loan status
table(predictions,observations)
# Compute accuracy rate
accuracy_Rate = sum(predictions == observations)/nrow(test)
# Compute error rate
error_rate = sum(predictions != observations)/nrow(test)

# Benchmark Predictions and Evaluation

# Load benchmark error rate function from external file
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")
# Compute benchmark error rate
error_bench = benchmarkErrorRate(training$Personal.Loan, test$Personal.Loan)