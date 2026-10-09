### Preparation

# Load data manipulation and plotting packages. 
library(tidyverse)
library(leaflet)

# Import data after tidying
imi_hospital_tidy <- read.csv('tidy_data/2016-2023_imi_hospitals_tidy.csv')


### Filter data about AMI medical conditions treated in 2023
AMI_imi_2023 <- imi_hospital_tidy |>
  filter(year == 2023,
         procedure_condition == 'AMI') |>
  drop_na()   #remove NA value for analysis

str(AMI_imi_2023)  #quick look at the data

# sort by worse to better, avoid alphabetical order and convenient for plotting later
AMI_imi_2023$hospital_ratings <- 
  factor(AMI_imi_2023$hospital_ratings, 
         levels = c('Worse', 'As Expected', 'Better'))


### Histogram
##show the distribution of hospitals by RAMR and hospital ratings
AMI_histogram <-
  ggplot(data = AMI_imi_2023, 
       mapping = aes(x = ramr, fill = hospital_ratings)) +
  geom_histogram(binwidth = 1, color = 'white') + #set bin width, show border clearly
  xlab('Risk Adjusted Mortality Rate (%)') + #label x and y axis
  ylab('Number of Hospitals') +
  xlim(0, 30) + #adjust the range of x, y axis
  ylim(0, 50) +
  theme_classic()  #fix noisy background
# show the graph
AMI_histogram
# Export plot
ggsave('AMI_histogram.jpg', AMI_histogram, width = 6, height = 4)

# look at the hospital with highest RAMR
head(filter(AMI_imi_2023, ramr == max(ramr)))


### spatial graph
# set a function for mapping data to color
pal <- colorFactor(c('red', 'yellow', 'blue'), 
                   domain = AMI_imi_2023$hospital_ratings)
# plotting map
leaflet(data = AMI_imi_2023) |> 
  addTiles() |>   # add map background
  addCircleMarkers(lat = ~latitude,
                   lng = ~longitude,
                   color = ~pal(hospital_ratings), #set point color
                   stroke = FALSE,    #do not display the point border
                   fillOpacity = 0.7, #adjust transparency of points
                   radius = 6) |>     #adjust point size
  addLegend(position = 'topleft',
            pal = pal,                  #match color
            values = ~hospital_ratings) #categorical var showed in legend
# Take a screenshot for map, used in news
