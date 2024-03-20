# LOAD 
df = read.csv("C:/Users/domin/OneDrive/Desktop/Data/ebayAuctions.csv")

# MANAGE
df$Category = as.factor(df$Category)
df$Currency = as.factor(df$Currency)
df$EndDay = as.factor(df$EndDay)
df$ClosePrice = NULL
df$Competitive = as.logical(df$Competitive)

# PARTITION
N = nrow(df)
training_size = round(N*0.6) #60% goes to the data set 
set.seed(1234)
training_cases = sample(N, training_size)
training = df[training_cases, ]
test = df[-training_cases, ] 

# Build
model = glm(Competitive ~., data=training, family=binomial)
model = step(model) #removes unecessary variables
summary(model)

# PREDICTION
predictions = predict(model, test, type="response")
predictions_tf = (predictions > 0.5)

# EVALUATE 
observations = test$Competitive
table(predictions_tf, observations)

accuracy_Rate = sum(predictions_tf == observations)/nrow(test)
error_rate = sum(predictions_tf != observations)/nrow(test)

source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")
error_bench = benchmarkErrorRate(training$Competitive, test$Competitive)

ratio = error_rate / error_bench

library(caret)
sensitivity = sensitivity(table(predictions_tf, observations))
specificity = specificity(table(predictions_tf, observations))

ROCChart(observations, predictions)
liftChart(observations, predictions) # if I predicted 99% right but got wrong..




