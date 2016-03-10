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
  
  #############################################################
  # Output for Trends
  
  #############################################################
  # Output for Resources
  
  #############################################################
  # Output for Other
  
  
})
