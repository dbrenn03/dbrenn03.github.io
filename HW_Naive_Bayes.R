library(e1071)
library(gmodels)

# Load external function
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")

# Load UniversalBank dataset
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/UniversalBank.csv.")

# MANAGE

# Remove unnecessary columns
df$ID = NULL
df$ZIP.Code = NULL
df$CCAvg = NULL
df$Experience = NULL
df$Income = NULL
df$Family = NULL
df$Age = NULL
df$Mortgage = NULL

# Convert selected columns to factors
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

#MODEL

# Build a Naive Bayes model
model = naiveBayes(Personal.Loan ~ ., data=training)
# Make predictions on the test set using the trained model
pred = predict(model, test)
# Get the true personal loan status from the test set
obs = test$Personal.Loan

# Create a confusion matrix of predicted vs actual personal loan status
table(pred,obs)

# Compute error rate
error_rate = sum(pred != obs)/nrow(test)
# Compute benchmark error rate
error_bench = benchmarkErrorRate(training$Personal.Loan, test$Personal.Loan)

# Display distribution of personal loan status in the training set
table(training$Personal.Loan)/nrow(training)

# Display ratio of "yes" to "no" personal loans in the training set
sum(training$Personal.Loan == "1")/sum(training$Personal.Loan == "0")