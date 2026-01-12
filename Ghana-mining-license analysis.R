# Import the data
library(tidyverse)
library(janitor)


# Read the data
raw_df = read_csv("C:\\Users\\AWENARE SUB 1\\DS-Practice\\Portfolio Projects\\Ghana mining project\\ghana_mining_license_report.csv")


# initial inspection
raw_df |> head()

# how many rows and coolumns are present?
dim(raw_df)


# Check column names and dtypes
names(raw_df)

glimpse(raw_df)
str(raw_df)
sapply(raw_df, class)

# standardise column names
raw_df <- raw_df |> 
  clean_names()

# check for the changes
names(raw_df)


# Convert the start_date column to datetime type
raw_df <- raw_df |> 
  mutate(start_date = parse_date_time(start_date, orders = "d/m/Y"))

# confirm the changes
glimpse(raw_df)

# number of rows before deduplication
raw_df |> nrow()

# Check for duplicates
raw_df <- raw_df |> 
  distinct()

# 4 duplicates were removed

# check for missing values
colSums(is.na(raw_df))


# inspect the missing values
missing_data <-  raw_df |> 
  filter(if_any(everything(), ~ is.na(.x)))

# Drop rows where all the values are missing
raw_df <-  raw_df |> 
  filter(!if_all(everything(), ~ is.na(.x)))

# Check for missing values again
colSums(is.na(raw_df))


# Extract the license type from the type column

raw_df |> 
  mutate(license_type = str_extract(type, "[\\w\\s]+"), .keep = "used")

# assign the extracted to the DataFrame
raw_df <- raw_df |> 
  mutate(license_type = str_extract(type, "[\\w\\s]+"), .after = type)

# Extract district of operation from regions
raw_df <- raw_df |> 
  mutate(district_of_operation = str_extract(regions, ".+([\\w\\s]+)[Dd]istrict", group = 1), .after = regions)

# Extract region of operation from regions
raw_df <- raw_df |> 
  mutate(region_of_operation = str_extract_all(regions, "[\\w ]+[Rr]egion", simplify = TRUE))
raw
