# Load necessary libraries
library(tidyverse)
library(readxl)

# Read data from Excel sheets
book = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=1)
author = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=2)
info = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=3)
award = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=4)
checkouts = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=5)
edition = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=6)
publisher = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=7)
ratings = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=8)
series = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=9)
salesq1 = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=10)
salesq2 = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=11)
salesq3 = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=12)
salesq4 = read_xlsx("C:/Users/domin/OneDrive/Desktop/Field Project/bookshop.xlsx",sheet=13)

# Select specific columns from info dataset
info %>% select(BookID1, BookID2)

# Filter info dataset for BookID1 equals "TH"
info %>% filter(BookID1 =="TH")

# Select specific columns and filter from info dataset
info %>% 
  select(-'Staff Comment') %>%
  filter(BookID1 == "TH" & BookID2 == 556)

# Display summary of info dataset
info %>% glimpse()

# Convert BookID2 column to numeric
tmp = info %>% mutate(BookID2 = as.numeric(BookID2))

# Combine BookID1 and BookID2 columns into a single column BookID
info = info %>%
  mutate(BookID = paste(BookID1, BookID2, sep="")) %>%
  select(- 'BookID1') %>%
  select(- 'BookID2')

# Join datasets book, author, and edition
df = inner_join(book, author , by="AuthID") %>%
  inner_join(edition, by="BookID")

# Join datasets book, author, edition, publisher, and info
df = inner_join(book, author , by="AuthID") %>%
  inner_join(edition, by="BookID") %>%
  inner_join(publisher, by= "PubID") %>%
  inner_join(info, by= "BookID")

# Left join datasets award, checkouts, and ratings with df
df = df %>% left_join(award, by="Title") %>%
  left_join(checkouts, by="BookID") %>%
  left_join(ratings, by="BookID")

# Bind sales datasets together
sales = bind_rows(salesq1,salesq2,salesq3,salesq4)

# Count occurrences of ISBN in sales dataset and arrange in descending order
sales %>% count(ISBN) %>% arrange(desc(n))

# Count occurrences of ISBN in df dataset and arrange in descending order
df %>% count(ISBN) %>% arrange(desc(n))

# Join datasets book and edition with sales dataset
book_sales = inner_join(book, edition, by="BookID")%>%
  inner_join(sales,by="ISBN")

# Group book_sales dataset by Title and Format, and calculate mean of numeric variables
tmp = book_sales %>%
  group_by(Title, Format) %>%
  summarise_if(is.numeric, mean)

# Replace NA values in Discount column with 0
book_sales_filled = book_sales %>% replace_na(list(Discount = 0))












  


  




