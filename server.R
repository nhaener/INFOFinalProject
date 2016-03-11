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
#source("scripts/trendline.R")

#############################################################
# Read in data
OB <- read.csv("output/OB.csv")
OB_S <- read.csv("output/OB_S.csv")
AC <- read.csv("output/AC.csv")
AC_S <- read.csv("output/AC_S.csv")
OB_AC_AVG <- read.csv("output/OBandAC_DF.csv")

projected_obesity <- read.csv("output/projected_obesity.csv")
projected_inactivity <- read.csv("output/projected_inactivity.csv")
obesity_2025 <- read.csv("output/obesity_2025.csv")
inactivity_2025 <- read.csv("output/inactivity_2025.csv")


# Server
shinyServer(function(input, output) {
  
  #############################################################
  # Output for Overview Page 
  
  # 
  
  output$Overview_OB_map <- renderPlot({
    df <- OB %>% select(1:3, contains("number"), contains("percent"))
    colnames(df)[2] <- "region"
    df <- df %>% select(1:3, contains(paste0(input$Overview_OB_map_slider_year)))
    colnames(df)[5] <- "value"
    if(input$Overview_OB_map_select_state != "National") {
      county_choropleth(df, 
                        title= paste(input$Overview_OB_map_select_state, "Obesity by County for", input$Overview_OB_map_slider_year),
                        legend = "Percent Obese",
                        state_zoom = tolower(input$Overview_OB_map_select_state))
    } else {
      county_choropleth(df,
                        title= paste(input$Overview_OB_map_select_state, "Obesity Rates for", input$Overview_OB_map_slider_year),
                        legend = "Percent Obese")
    }
  })
  
  observeEvent(input$Overview_OB_map_data_show_table, {
    toggle("Overview_OB_map_data")
  })
  
  output$Overview_OB_map_data <- renderDataTable({
    if(input$Overview_OB_map_select_state != "National"){
      map_table <- OB %>% select(1, 3, contains(paste0(input$Overview_OB_map_slider_year))) %>%
        filter(State == input$Overview_OB_map_select_state) %>%
        select(2:4)
      colnames(map_table) <- c("County", "Surveyed", "Percent Obese")
      map_table
      
    } else {
      map_table_national <- OB_AC_AVG %>% select(1, contains("OB")) %>% 
        select(1, contains(paste0(input$Overview_OB_map_slider_year)))
      col_name <- paste0("number_", input$Overview_OB_map_slider_year)
      num_counties_and_surveyed <- OB %>% group_by(State) %>% summarise(n())
      map_table_national <- map_table_national %>% left_join(num_counties_and_surveyed, by = "State")
      colnames(map_table_national) <- c("State", "Avg Percent Obese", "Number of Counties")
      map_table_national
    }
  })
  #############################################################
  # Output for Obesity & Activity
  
  # read in .csv files to be visualized
  OBandAC_data <- read.csv("output/OBandAC_DF.csv")
  # read in state name abbrevations/codes to be accepted into 'location' argument of the plotly choropleth maps
  state_codes <- read.csv("data/StateName_abvr.csv")
  colnames(state_codes) <- c('State', 'code')
  
  # create reactive dataframe for obesity prevalence of states for the year input by user, leaving out
  # states with NULL values
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
  
  # create reactive dataframe for activity levels of states for the year input by user, leaving out
  # states with NULL values
  acmap_data <- reactive({
    to_acmap <- select(OBandAC_data, State, contains(paste0('AC_percent_', as.character(input$year)))) %>% 
      filter(State!="Alaska", State!="Puerto Rico")
    colnames(to_acmap) = c('State', 'percent')
    to_acmap$hover = with(to_acmap, paste0(to_acmap$State, ": ", to_acmap$percent, "%"))
    to_acmap <- left_join(to_acmap, state_codes, by="State")
  })
  
  # outputs the plotly object of inactivity level choropleth map to UI
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
    
    # constructs plotly object to display inactivity levels of states as a choropleth map
    plot_ly(acmap_data(), type='choropleth', z = percent, locations = code,
            locationmode = 'USA-states', color = percent, colors = 'PuBuGn',
            marker = list(line = l), colorbar = list(title = 'Leisure Time Inactivity Percentage',
                                                     ticksuffix = "%")) %>% 
      layout(title = 'Leisure Time Not Spent Performing Physical Activity by State', geo = g)
  })
  
  #############################################################
  # Output for Trends
  
    #rendering obesity graph
    output$obesity_plot <- renderPlotly(
      plot_ly(obesity_2025,
              x = net_change,
              y = State,
              text = paste(
                '<b>Percent Increase by Year:</b>', net_change,
                '<br><b>Percent Obese in 2005:</b>', percent_2005,
                '<br><b>Percent Obese by 2025:</b>', percent_2025
              ),
              mode = "markers",
              color = Change) %>%
        layout(title = "Current Obesity Percentage Projected into 2025",
               xaxis = list(title = "Percent Increase in Obesity"),
               yaxis = list(title = "State"),
               margin = list(l = 150))
    )
    #rendering inactivity graph
    output$inactivity_plot <- renderPlotly(
      plot_ly(inactivity_2025,
              x = net_change,
              y = State,
              text = paste(
                '<b>Percent Increase by Year:</b>', net_change,
                '<br><b>Percent Inactive in 2005:</b>', percent_2005,
                '<br><b>Percent Inactive by 2025:</b>', percent_2025
              ),
              mode = "markers",
              color = Change) %>%
        layout(title = "Current Inactivity Percentage Projected into 2025",
               xaxis = list(title = "Percent Increase in Inactivity"),
               yaxis = list(title = "State"),
               margin = list(l = 150))
      
    )
    #calling the tables if button is pressed
    observeEvent(input$trends_checkbox, {
      toggle("table1")
      toggle("table2")
    })
    #rendering tables 1 and 2
    output$table1 <- renderDataTable({
      projected_obesity
    })
    output$table2 <- renderDataTable({
      projected_inactivity
    })
  
  #############################################################
  # Output for Documentation
})
