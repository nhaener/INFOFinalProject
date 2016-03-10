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
# Load Library
library(shiny)
library(plotly)
library(dplyr)
library(choroplethr)
library(choroplethrMaps)

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


# Server
shinyServer(function(input, output) {
  
  #############################################################
  # Output for Overview Page 
  
  # function to coerce setup df
  
  output$Overview_OB_map <- renderPlot({
    df <- OB %>% select(1:3, contains("number"), contains("percent"), contains("Lat"), contains("Long"))
    colnames(df)[2] <- "region"
    df <- df %>% select(1:3, contains(paste0(input$Overview_OB_map_select_year)), contains("Lat"), contains("Long"))
    colnames(df)[5] <- "value"
    if(input$Overview_OB_map_select_state != "National") {
      county_choropleth(df, state_zoom = c(tolower(input$Overview_OB_map_select_state)))
    } else {
      county_choropleth(df)
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
