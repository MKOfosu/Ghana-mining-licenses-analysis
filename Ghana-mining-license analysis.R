# Import the data
library(tidyverse)
library(janitor)

# Data Cleaning ----------------------------
# Read the data
raw_df = read_csv("C:\\Users\\AWENARE SUB 1\\DS-Practice\\Portfolio Projects\\Ghana mining project\\ghana_mining_license_report.csv")

# initial inspection
head(raw_df)

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

# Check for and remove duplicates
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
  mutate(license_type = str_extract(type, "[\\w\\s]+"), 
         .keep = "used")

# Extract district of operation from regions
raw_df |> 
  mutate(district_of_operation = str_extract(regions, ".+([\\w\\s]+)[Dd]istrict", group = 1), 
         .keep = 'used')

# multiple cleaning operations piped together
clean_df <- raw_df |>
  # Extract the license type from the type column
  mutate(license_type = str_extract(type, "[\\w\\s]+"), 
         .after = type) |> 
  
  # Extract district of operation from regions
  mutate(district_of_operation = str_extract(regions, ".+([\\w\\s]+)[Dd]istrict", group = 1), 
         .after = regions) |> 
  
  # extract multiple regions into rows
  mutate(region_of_operation = str_extract_all(regions, ".*[Rr]egion")) |> 
  unnest(region_of_operation) |>
  
  # remove unneeded columns
  select(-type, -regions) |>
  
  # trim all character columns of leading/ending whitespaces and make them title case
  mutate(across(where(is.character), ~str_to_title(str_squish(.x))),
         # make the license column uppercase
         license_code = str_to_upper(license_code)) |> 
  
  # # Break down the start date into year, month and day
  mutate(start_year = year(start_date),
         start_month = month(start_date),
         start_day = day(start_date))

# Check the unique values in license type
clean_df |> 
  distinct(license_type) |> 
  arrange(license_type)

# Clean the license_type column by standardising small scaled mining license type
clean_df |> 
  mutate(license_type = str_replace(license_type, "Small Scale.+", "Small Scale License")) |> 
  distinct(license_type) |> 
  arrange(license_type)

# make the change permanent
clean_df <- clean_df |> 
  mutate(license_type = str_replace(license_type, "Small Scale.+", "Small Scale License"))
  
clean_df |> 
  group_by(license_type) |> 
  summarise(number = n_distinct(license_code)) |> 
  arrange(desc(number))

# check the minerals
clean_df |> 
  summarise(number = n_distinct(license_code),
            .by = minerals) |> 
  arrange(desc(number))

#clean the minerals column 
clean_df <- clean_df |> 
  mutate(minerals = case_when(minerals %in% c("Gold Diamonds", "Diamonds Gold") ~ "Gold & Diamonds",
                              minerals %in% c(". Gold", "Gold .") ~ "Gold",
                              TRUE ~ minerals
                              )
         )

# check the minerals again
clean_df |> 
  group_by(minerals) |> 
  summarise(number = n_distinct(license_code)) |> 
  arrange(desc(number))


# Exploratory Data Analysis -----------------------------------------------
# number of unique companies licensed
clean_df |> 
  summarise(number_of_entities = n_distinct(owner))

# inspect the region of operation
clean_df |> 
  distinct(region_of_operation) |> 
  arrange(region_of_operation)

# How many licenses has been granted so far
clean_df |> 
  summarise(number_of_licenses = n_distinct(license_code))

# examine the distribution of the license status
clean_df |> 
  group_by(status) |> 
  summarise(number = n_distinct(license_code))

# when was the first license given
clean_df |> 
  summarise(first_license_date = min(start_date))

# when was the last license given
clean_df |> 
  summarise(last_license_date = max(start_date))

# Zooming in on small scale licenses --------------------------
small_scale_df = clean_df |> 
  filter(license_type == "Small Scale License")

# status of small scale license
small_scale_df |> 
  group_by(status) |> 
  summarise(count = n_distinct(license_code))

# Which year saw the highest number of licenses given?
annual_trends <- small_scale_df |> 
  group_by(start_year) |> 
  summarise(number = n_distinct(license_code))

# plot the number of licenses granted annually
annual_trends |> 
  ggplot(aes(x = as.factor(start_year), y = number, group = 1))+
  geom_line(linejoin = 'round', 
            linewidth = 0.75,
            color = 'red')+
  geom_point(shape = 21, 
             size = 2.5, 
             fill = 'red', 
             color = 'red')+
  labs(title = "Annual Trend of Small scale license granted",
       x = "year",
       y = 'count') +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold")
  )

# monthly trends
monthly_trends <- small_scale_df |> 
  group_by(start_month) |> 
  summarise(count = n_distinct(license_code))

# plot the monthly trends
monthly_trends |> 
  ggplot(aes(x = as_factor(start_month), y = count, group = 1)) +
  geom_line(linejoin = 'round', 
            linewidth = 0.75,
            color = 'red')+
  geom_point(shape = 21, 
             size = 2.5, 
             fill = 'red', 
             color = 'red')+
  labs(title = "Monthly Trend of Small scale license granted",
       x = "year",
       y = 'count') +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold")
  )

# Which regions or districts are small mining happening the most?
small_scale_df |> 
  group_by(region_of_operation) |> 
  summarise(count = n()) |> 
  arrange(desc(count))

# Which minerals are commonly mined using small scale license?
minerals_mined <- small_scale_df |> 
  summarise(count = n_distinct(license_code),
            .by = minerals)

# visualise the distribution of minerals extracted
minerals_mined |> 
  ggplot(aes(x = count, y = fct_rev(minerals)))+
  geom_col(width = 0.4,
           fill = 'red')+
  labs(title = 'Minerals extracted under small scale license',
       y = 'minerals')+
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = 'bold'),
        axis.title.x = element_text(face = 'bold'),
        axis.title.y = element_text(face = 'bold'))

# ggsave('minerals-mined.png', dpi = 1200)
