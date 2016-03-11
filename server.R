#############################################################
#############################################################
##  
##
##
##
##
##
#############################################################
#############################################################

#############################################################
# Install Packages
# install.packages("choroplethrMaps")
# install.packages("choroplethr")
# install.packages("shinyjs")

#############################################################
# Load Library
library(shiny)
library(plotly)
library(dplyr)
library(choroplethr)
library(choroplethrMaps)
library(shinyjs)

#############################################################
# Load manipulated data
#source("server_data_mp.R")
source("PAGE_Overview_data_mp.R")

#############################################################
# Read in data
OB <- read.csv("data/OB.csv")
OB_S <- read.csv("data/OB_S.csv")
AC <- read.csv("data/AC.csv")
AC_S <- read.csv("data/AC_S.csv")
OB_AC_AVG <- read.csv("data/OBandAC_DF.csv")


# Server
shinyServer(function(input, output) {
  
  #############################################################
  # Output for Overview Page 
  
  # 
  
  output$Overview_OB_map <- renderPlot({
    df <- OB %>% select(1:3, contains("number"), contains("percent"))
    colnames(df)[2] <- "region"
    df <- df %>% select(1:3, contains(paste0(input$Overview_OB_map_select_year)))
    colnames(df)[5] <- "value"
    if(input$Overview_OB_map_select_state != "National") {
      county_choropleth(df, 
                        title= paste(input$Overview_OB_map_select_state, "Obesity by County for", input$Overview_OB_map_select_year),
                        legend = "Percent Obese",
                        state_zoom = tolower(input$Overview_OB_map_select_state))
    } else {
      county_choropleth(df,
                        title= paste(input$Overview_OB_map_select_state, "Obesity Rates for", input$Overview_OB_map_select_year),
                        legend = "Percent Obese")
    }
  })
  
  observeEvent(input$Overview_OB_map_data_show_table, {
    toggle("Overview_OB_map_data")
  })
  
  output$Overview_OB_map_data <- renderDataTable({
    if(input$Overview_OB_map_select_state != "National"){
      map_table <- OB %>% select(1, 3, contains(paste0(input$Overview_OB_map_select_year))) %>%
        filter(State == input$Overview_OB_map_select_state) %>%
        select(2:4)
      colnames(map_table) <- c("County", "Surveyed", "Percent Obese")
      map_table
      
    } else {
      map_table_national <- OB_AC_AVG %>% select(1, contains("OB")) %>% 
        select(1, contains(paste0(input$Overview_OB_map_select_year)))
      col_name <- paste0("number_", input$Overview_OB_map_select_year)
      num_counties_and_surveyed <- OB %>% group_by(State) %>% summarise(n())
      map_table_national <- map_table_national %>% left_join(num_counties_and_surveyed, by = "State")
      colnames(map_table_national) <- c("State", "Avg Percent Obese", "Number of Counties")
      map_table_national
    }
  })
  #############################################################
  # Output for Obesity & Activity
  
  # read in .csv files to be visualized
  OBandAC_data <- read.csv("data/OBandAC_DF.csv")
  state_codes <- read.csv("data/original/StateName_abvr.csv")
  colnames(state_codes) <- c('State', 'code')
  
  # create reactive dataframe for obesity prevalence of states for the year input by user
  obmap_data <- reactive({
    to_obmap <- select(OBandAC_data, State, contains(paste0('OB_percent_', as.character(input$year)))) %>% 
      filter(State!="Alaska", State!="Puerto Rico")
    colnames(to_obmap) = c('State', 'percent')
    to_obmap$hover = with(to_obmap, paste0(to_obmap$State, ": ", round(to_obmap$percent, digits = 3), "%"))
    to_obmap <- left_join(to_obmap, state_codes, by="State")
  })
  
  # outputs the plotly object of obesity of prevalence choropleth map to UI
  output$obmap <- renderPlotly ({
    
    l <- list(color = toRGB("gray"), width = 1)
    
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white'),
      subunitwidth = 1,
      countrywidth = 2,
      subunitcolor = toRGB("white"),
      countrycolor = toRGB("white")
    )
    
    # constructs plotly object to display obesity prevalence of states as a choropleth map
    plot_ly(obmap_data(), type='choropleth', z = percent, locations = code,
            locationmode = 'USA-states', color = percent, colors = 'OrRd', text = hover,
            marker = list(line = l), colorbar = list(title = 'Population Obesity Percentage',
                                                     ticksuffix = "%")) %>% 
      layout(title = 'Obesity Prevalence in America by State', geo = g)
  })
  
  # create reactive dataframe for activity levels of states for the year input by user
  acmap_data <- reactive({
    to_acmap <- select(OBandAC_data, State, contains(paste0('AC_percent_', as.character(input$year)))) %>% 
      filter(State!="Alaska", State!="Puerto Rico")
    colnames(to_acmap) = c('State', 'percent')
    to_acmap$hover = with(to_acmap, paste0(to_acmap$State, ": ", to_acmap$percent, "%"))
    to_acmap <- left_join(to_acmap, state_codes, by="State")
  })
  
  # outputs the plotly object of activity level choropleth map to UI 
  output$acmap <- renderPlotly({
    
    l <- list(color = toRGB("gray"), width = 1)
    
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white'),
      subunitwidth = 1,
      countrywidth = 1,
      subunitcolor = toRGB("white"),
      countrycolor = toRGB("white")
    )
    
    # constructs plotly object to display activity levels of states as a choropleth map
    plot_ly(acmap_data(), type='choropleth', z = percent, locations = code,
            locationmode = 'USA-states', color = percent, colors = 'PuBuGn',
            marker = list(line = l), colorbar = list(title = 'Leisure Time Activity Percentage',
                                                     ticksuffix = "%")) %>% 
      layout(title = 'Leisure Time Dedicated to Physical Activity by State', geo = g)
  })
  
  #############################################################
  # Output for Trends
  
  #############################################################
  # Output for Resources
  
  #############################################################
  # Output for Other
  
  
})
