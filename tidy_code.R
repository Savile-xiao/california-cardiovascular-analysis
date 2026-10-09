# Loaded packages
library(tidyverse) # Grammar of data manipulation

# Import raw data
imi_results <- read.csv('raw_data/2016-2023-imi-results-long-view.csv')


### Tidy Data
## 1. Use good, informative names and be consistent
colnames(imi_results) # view the original column names
# rename column names
colnames(imi_results) <- c('year', 'county', 'hospital', 'oshpd_id', 
                           'procedure_condition', 'ramr', 'num_of_deaths', 
                           'num_of_cases', 'hospital_ratings', 
                           'longitude', 'latitude') 

## 2. For ensuring each variable forms a column,
# Filter the STATEWIDE summary rows and keep only hospital-level data 
imi_hospitals <- imi_results |> 
  filter(hospital != 'STATEWIDE')

## 3. Use NA to show missing data
imi_hospitals <- imi_hospitals |>
  mutate(
    ramr = replace(ramr, ramr %in% c("", "."), NA),
    
    num_of_deaths = replace(num_of_deaths, num_of_deaths %in% c("", "."), NA),
    
    num_of_cases = replace(num_of_cases, num_of_cases %in% c("", "."), NA),
    
    hospital_ratings = replace(hospital_ratings, 
                               hospital_ratings == "", NA),
    
    longitude = replace(longitude, longitude %in% c("", "."), NA),
    
    latitude = replace(latitude, latitude %in% c("", "."), NA)
    )


### Change data type, which is convenient for plotting later
str(imi_hospitals) # view data frame
imi_hospitals <- imi_hospitals |>
  mutate(
    ramr = as.numeric(ramr),
    num_of_deaths = as.integer(num_of_deaths),
    num_of_cases = as.integer(num_of_cases),
    longitude = as.numeric(longitude),
    latitude = as.numeric(latitude)
  )
str(imi_hospitals)  # check the data type changed

### Using .csv file to export data after tidy and choose good file name

head(imi_hospitals) # have a quick look at cleaned data
write_csv(imi_hospitals, file = 'tidy_data/2016-2023_imi_hospitals_tidy.csv')
