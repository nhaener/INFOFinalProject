# Load Library
library(shiny)
library(plotly)
library(dplyr)
library(choroplethrMaps)




#############################################################
# Read in data
OB <- read.csv("data/OB.csv")
OB_S <- read.csv("data/OB_S.csv")
AC <- read.csv("data/AC.csv")
AC_S <- read.csv("data/AC_S.csv")



map_table <- OB %>% select(1, 3, contains(paste0(2004))) %>%
        filter(State == 'Washington') %>%
        select(2:4)
      colnames(map_table) <- c("County", "Surveyed", "Percent Obese")
      map_table















# df <- OB %>% select(1:3, contains("number"), contains("percent"), contains('Lat'), contains('Long'))
# colnames(df)[2] <- "region"
# df <- df %>% select(1:3, contains("2004"), contains('Lat'), contains('Long'))
# colnames(df)[5] <- "value"
# 
# #df <- df %>% filter(State == "washington")
# 
#   map <- county_choropleth(df, state_zoom = "washington")
# 
#   map <- county_choropleth(df)
#   
#   
#   df$hover <- with(df, paste(State, '<br>', "Number Surveyed", number_2004, "Percent Obese", value))
#   # give state boundaries a white border
#   l <- list(color = toRGB("white"), width = 2)
#   # specify some map projection/options
#   g <- list(
#     scope = 'usa',
#     projection = list(type = 'albers usa'),
#     showlakes = TRUE,
#     lakecolor = toRGB('white'),
#     landcolor = toRGB('grey')
#   )
#   
#   
#   ggplot() +
#     geom_polygon(data = df, 
#                  aes(x = Long, y = Lat), 
#                  color = "black", size = 0.25) + 
#     coord_map()
#   
#   
#   
#  map <- plot_ly(df, z = value, text = hover, locations = region, type = 'choropleth',
#           locationmode = 'USA-states', color = value, colors = 'Purples',
#           marker = list(line = l), colorbar = list(title = "Percent Obese")) %>%
#     layout(title = 'Obesity 2004<br>(Hover for breakdown)', geo = g)
#   
#  map 
#   
#   choro <- CountyChoropleth$new(df)
#   choro$title <- "2004 Obesity Data"
# 
# mapg <-   choro$render()
# 
#   
#   plot(map)
# 
# 
# 
# 
# 
# 
# 
# 
