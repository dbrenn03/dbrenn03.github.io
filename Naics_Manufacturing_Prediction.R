#Library
library(randomForest)
source("C:/Users/domin/OneDrive/Desktop/R/BabsonAnalytics.R")
library(mice)
library(rpart)
library(rpart.plot)

#GOOGLE MODEL

#LOAD THE DATA
g <- read.csv("C:/Users/domin/OneDrive/Desktop/google_web_scrape.csv")

# Numeric
g$NAICS.on.SoS.site = as.numeric(g$NAICS.on.SoS.site)

# Factor
g$key_0 = as.factor(g$key_0)
g$NAICS.Code = as.factor(g$NAICS.Code)
g$found_percentage = as.factor(g$found_percentage)

# Categorial
g$Food = as.logical(g$Food)
g$Beverage = as.logical(g$Beverage)
g$Tobacco = as.logical(g$Tobacco)
g$Mills = as.logical(g$Mills)
g$Textile = as.logical(g$Textile)
g$Apparel = as.logical(g$Apparel)
g$Leather = as.logical(g$Leather)
g$Footwear = as.logical(g$Footwear)
g$Wood = as.logical(g$Wood)
g$Paper = as.logical(g$Paper)
g$Printing = as.logical(g$Printing)
g$Petroleum = as.logical(g$Petroleum)
g$Coal = as.logical(g$Coal)
g$Chemicals = as.logical(g$Chemicals)
g$Plastics = as.logical(g$Plastics)
g$Rubber = as.logical(g$Rubber)
g$Mineral = as.logical(g$Mineral)
g$Metal = as.logical(g$Metal)
g$Machinery = as.logical(g$Machinery)
g$Electronic = as.logical(g$Electronic)
g$Electrical = as.logical(g$Electrical)
g$Transportation = as.logical(g$Transportation)
g$Furniture = as.logical(g$Furniture)
g$Medical = as.logical(g$Medical)

#NULL Variables
g$Website.URL = NULL
g$Company = NULL
g$Principal.Address = NULL
g$Resident.Agent = NULL
g$Description = NULL
g$keyword_count = NULL
g$found_count = NULL

# Manufacturing we need to change False to 0
g$Manufacturing <- replace(g$Manufacturing, g$Manufacturing == "False", FALSE)
g$Manufacturing <- replace(g$Manufacturing, g$Manufacturing == 1, TRUE)
g$Manufacturing <- replace(g$Manufacturing, g$Manufacturing == 0, FALSE)

# Target variable as Logical 
g$Manufacturing = as.logical(g$Manufacturing)

# PARTITION
N = nrow(g)
training_size = round(N*0.6)
training_cases = sample(N, training_size)
g_training = g[training_cases, ]
g_test = g[-training_cases, ]

#Predict 
observations = g_test$Manufacturing
bench_error = benchmarkErrorRate(g_training$Manufacturing, g_test$Manufacturing)

stopping_rules = rpart.control(minsplit=2,mindbucket=1,cp=-1)
model_google = rpart(Manufacturing~., data = g_training, control = stopping_rules)

prune_google = easyPrune(model_google)
predictions_google = predict(prune_google, g_test) > 0.50
google_error = sum(predictions_google != observations)/nrow(g_test)
table(predictions_google, observations)
rpart.plot(prune_google)

#BING MODEL

#LOAD THE DATA
b <- read.csv("C:/Users/domin/OneDrive/Desktop/bing_web_scrape.csv")

# Numeric
b$NAICS.on.SoS.site = as.numeric(b$NAICS.on.SoS.site)

# Factor
b$key_0 = as.factor(b$key_0)
b$NAICS.Code = as.factor(b$NAICS.Code)
b$found_percentage = as.factor(b$found_percentage)

# Categorial
b$Food = as.logical(b$Food)
b$Beverage = as.logical(b$Beverage)
b$Tobacco = as.logical(b$Tobacco)
b$Mills = as.logical(b$Mills)
b$Textile = as.logical(b$Textile)
b$Apparel = as.logical(b$Apparel)
b$Leather = as.logical(b$Leather)
b$Footwear = as.logical(b$Footwear)
b$Wood = as.logical(b$Wood)
b$Paper = as.logical(b$Paper)
b$Printing = as.logical(b$Printing)
b$Petroleum = as.logical(b$Petroleum)
b$Coal = as.logical(b$Coal)
b$Chemicals = as.logical(b$Chemicals)
b$Plastics = as.logical(b$Plastics)
b$Rubber = as.logical(b$Rubber)
b$Mineral = as.logical(b$Mineral)
b$Metal = as.logical(b$Metal)
b$Machinery = as.logical(b$Machinery)
b$Electronic = as.logical(b$Electronic)
b$Electrical = as.logical(b$Electrical)
b$Transportation = as.logical(b$Transportation)
b$Furniture = as.logical(b$Furniture)
b$Medical = as.logical(b$Medical)

#NULL Variables
b$Website.URL = NULL
b$Company = NULL
b$Principal.Address = NULL
b$Resident.Agent = NULL
b$Description = NULL
b$keyword_count = NULL
b$found_count = NULL

# Manufacturing we need to change False to 0
b$Manufacturing <- replace(b$Manufacturing, b$Manufacturing == "False", FALSE)
b$Manufacturing <- replace(b$Manufacturing, b$Manufacturing == 1, TRUE)
b$Manufacturing <- replace(b$Manufacturing, b$Manufacturing == 0, FALSE)

# Target variable as Logical 
b$Manufacturing = as.logical(b$Manufacturing)

# PARTITION
N = nrow(b)
training_size = round(N*0.6)
training_cases = sample(N, training_size)
b_training = b[training_cases, ]
b_test = b[-training_cases, ]

#Predict 
observations = b_test$Manufacturing

stopping_rules = rpart.control(minsplit=2,mindbucket=1,cp=-1)
model_bing = rpart(Manufacturing ~., data = b_training, control = stopping_rules)

prune_bing = easyPrune(model_bing)
predictions_bing = predict(prune_bing, b_test) > 0.50
bing_error = sum(predictions_bing != observations)/nrow(b_test)
table(predictions_bing, observations)
rpart.plot(prune_bing)

#YELLOW PAGES MODEL

#LOAD THE DATA
y <- read.csv("C:/Users/domin/OneDrive/Desktop/yellowpage_web_scrape.csv")

# Numeric
y$NAICS.on.SoS.site = as.numeric(y$NAICS.on.SoS.site)

# Factor
y$key_0 = as.factor(y$key_0)
y$NAICS.Code = as.factor(y$NAICS.Code)
y$found_percentage = as.factor(y$found_percentage)

# Categorial
y$Food = as.logical(y$Food)
y$Beverage = as.logical(y$Beverage)
y$Tobacco = as.logical(y$Tobacco)
y$Mills = as.logical(y$Mills)
y$Textile = as.logical(y$Textile)
y$Apparel = as.logical(y$Apparel)
y$Leather = as.logical(y$Leather)
y$Footwear = as.logical(y$Footwear)
y$Wood = as.logical(y$Wood)
y$Paper = as.logical(y$Paper)
y$Printing = as.logical(y$Printing)
y$Petroleum = as.logical(y$Petroleum)
y$Coal = as.logical(y$Coal)
y$Chemicals = as.logical(y$Chemicals)
y$Plastics = as.logical(y$Plastics)
y$Rubber = as.logical(y$Rubber)
y$Mineral = as.logical(y$Mineral)
y$Metal = as.logical(y$Metal)
y$Machinery = as.logical(y$Machinery)
y$Electronic = as.logical(y$Electronic)
y$Electrical = as.logical(y$Electrical)
y$Transportation = as.logical(y$Transportation)
y$Furniture = as.logical(y$Furniture)
y$Medical = as.logical(y$Medical)

#NULL Variables
y$Website.URL = NULL
y$Company = NULL
y$Principal.Address = NULL
y$Resident.Agent = NULL
y$Description = NULL
y$keyword_count = NULL
y$found_count = NULL

# Manufacturing we need to change False to 0
y$Manufacturing <- replace(y$Manufacturing, y$Manufacturing == "False", FALSE)
y$Manufacturing <- replace(y$Manufacturing, y$Manufacturing == 1, TRUE)
y$Manufacturing <- replace(y$Manufacturing, y$Manufacturing == 0, FALSE)

# Target variable as Logical 
y$Manufacturing = as.logical(y$Manufacturing)

# PARTITION
N = nrow(g)
training_size = round(N*0.6)
training_cases = sample(N, training_size)
y_training = g[training_cases, ]
test = y[-training_cases, ]

#Predict 
observations = test$Manufacturing

stopping_rules = rpart.control(minsplit=2,mindbucket=1,cp=-1)
model_yellowp = rpart(Manufacturing~., data = y_training, control = stopping_rules)

prune_yellowp = easyPrune(model_yellowp)
predictions_yellowp = predict(prune_yellowp, test) > 0.50
yellowp_error = sum(predictions_yellowp != observations)/nrow(test)
table(predictions_yellowp, observations)
rpart.plot(prune_yellowp)

# STACKING 

#Setting up models for binding
pred_tree_google = predict(model_google, g)

pred_tree_bing = predict(model_bing, b)

pred_tree_yellowp = predict(model_yellowp, y)

#Partition
df_stack = cbind(g, pred_tree_bing, pred_tree_yellowp, pred_tree_google)
train_stack = df_stack[training_cases, ]
test_stack = df_stack[-training_cases, ]

#Build
model_stack = rpart(Manufacturing~., data = y_training, control = stopping_rules)
prune_model_stacked = easyPrune(model_stack)

#Evaluate
pred_stacked = predict(prune_model_stacked, test_stack)
pred_stacked = (pred_stacked > 0.5)

error_stacked = sum(pred_stacked != test_stack$Manufacturing)/nrow(test_stack)
