library(plotly)
library(dplyr)

## Set working directory
setwd("/Users/Nick/info498f/INFOFinalProject")

## Source formatted data
source("data_format.R")

data <- OB %>% select(1:3, contains('2004'), contains("Lat"), contains("Long")) %>% 
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
        lon = Long, 
        lat = Lat, 
        text = paste(data$County, ', ', data$State, 
                     '<br><b>Percentage Obese:</b>', data$percent_2004),
        hoverinfo = 'text',
        marker = list(size = data$percent_2004 / 4 , opacity = .4, color = 'red'),
        type = 'scattergeo', 
        locationmode = 'USA-states'
) %>%
  layout(title = '2004 Crowdsourced Obesity Statistics', geo = g)



################################# CHOROPLETH ##########################################
data$hover <- with(data, paste(State, '<br>', "Beef", beef, "Dairy", dairy, "<br>",
                           "Fruits", total.fruits, "Veggies", total.veggies,
                           "<br>", "Wheat", wheat, "Corn", corn))
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

plot_ly(df, z = total.exports, text = hover, locations = code, type = 'choropleth',
        locationmode = 'USA-states', color = total.exports, colors = 'Purples',
        marker = list(line = l), colorbar = list(title = "Millions USD")) %>%
  layout(title = '2011 US Agriculture Exports by State<br>(Hover for breakdown)', geo = g)
