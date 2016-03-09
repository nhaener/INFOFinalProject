library(plotly)
library(dyplyr)

## Set working directory
setwd("/Users/Nick/info498f/INFOFinalProject")

## Source formatted data
source("data_format.R")

data <- OB %>% select(1:3, contains('2004')) %>% 
  filter(OB$State == "Washington")

#create interactive global map
#create map
g <- list(
  scope = 'usa', 
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray85"), 
  subunitwidth = 0.5,
  countrywidth = 0.5,
  subunitcolor = toRGB("white"), 
  countrycolor = toRGB('white')
)

#create plot
# Create graph with varrying marker sizes based on percentage obese
plot_ly(data, 
        lon = long, 
        lat = lat, 
        text = paste(data$County, ', ', data$State, 
                     '<br><b>Percentage Obese:</b>', data$percent_2004),
        hoverinfo = 'text',
        marker = list(size = data$percent_2004 , opacity = .4, color = 'red'),
        type = 'scattergeo', 
        locationmode = 'USA-states'
) %>%
  layout(title = '2004 Crowdsourced Obesity Statistics', geo = g)

