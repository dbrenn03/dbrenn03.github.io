# Load necessary libraries
library(tidyverse)
library(lubridate)
library(dplyr)

# Read data from CSV file
df = read.csv('C:/Users/domin/OneDrive/Desktop/Field Project/bike_share.csv')

# Define factor columns
fct_cols = c("season","holiday","workingday","weather")

# Convert selected columns to factor and date-time format
df = df %>% 
  mutate_at(fct_cols, as.factor) %>%
  mutate(datetime = mdy_hm(datetime)) %>%
  mutate(hour = as.factor(hour(datetime))) %>%
  mutate(weekday = as.factor(wday(datetime)))

# GGPLOT BASICS

# Plot casual bike share over time with constant color
df %>% ggplot(aes(x=datetime, y=casual)) + geom_line(color='orange')

# Plot casual bike share over time with color based on season
df %>% ggplot(aes(x=datetime, y=casual, color=season)) + geom_line()

# Plot casual bike share over time with color based on temperature
df %>% ggplot(aes(x=datetime, y=casual, color=temp)) + geom_line()

# COMPARISON

# Plot casual bike share by season
df %>% ggplot(aes(x=season, y=casual)) + 
  geom_bar(stat='identity') +
  scale_fill_brewer(palette='Set2')

# DISTRIBUTION

# Plot histogram of casual bike share
df %>% ggplot(aes(x=casual)) + geom_histogram(bins=100)

# Plot casual bike share by weekday and hour
df %>% group_by(weekday, hour) %>%
  summarize_if(is.numeric, sum) %>%
  ggplot(aes(x=weekday,y=hour,fill=casual)) + geom_tile()

# For composition chart, pivot data longer
df_long = df %>% pivot_longer(cols='registered':'casual',
                              values_to = 'rides', 
                              names_to = 'type')

# Plot bike share by weekday with type as fill
df_long %>% ggplot(aes(x=weekday, y=rides,fill=type)) + 
  geom_bar(stat ='identity') +
  scale_fill_brewer(palette='Set2')

# FACETS

# Plot mean bike share by season, faceted by workingday
df %>% ggplot(aes(x=season,y=count, fill=season)) + 
  geom_bar(stat='summary',fun='mean') +
  facet_grid(cols=vars(workingday))

# Plot casual bike share against apparent temperature, faceted by workingday and season
df %>%
  filter(hour==12) %>%
  ggplot(aes(x=atemp, y=casual)) + geom_point() + 
  geom_smooth(method = 'lm') + 
  facet_grid(rows = vars(workingday), cols=vars(season))



