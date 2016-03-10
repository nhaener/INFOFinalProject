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
library(shiny)
library(plotly)
library(dplyr)
library(choroplethr)
library(choroplethrMaps)


#############################################################
# Load manipulated data
#source("server_data_mp.R")
source("PAGE_Overview_data_mp.R")


# Define UI
shinyUI(fluidPage(
  
  navbarPage("US Obesity",
             tabPanel("Overview",
                      
                      sidebarLayout(
                        sidebarPanel( "View Settings:",
                            selectInput("Overview_OB_map_select_year",
                                        choices = c(2004:2012),
                                        label = "Select year"),
                          selectInput("Overview_OB_map_select_state",
                                      choices = c("National", choices_state()),
                                      label = "Select focus (National or State)")
                        ),
                        mainPanel("",
                          plotOutput("Overview_OB_map")
                        ))
              ),
             tabPanel("Obesity & Activity",
                      sidebarLayout(
                        sidebarPanel( "sidebar panel"),
                        mainPanel("main panel")
                      )  
                      
                      
                      
             ),
             tabPanel("Trends",
                      sidebarLayout(
                        sidebarPanel( "sidebar panel"),
                        mainPanel("main panel")
                      )  
             
                      
                      
             ),
             tabPanel("Resources",
                      sidebarLayout(
                        sidebarPanel( "sidebar panel"),
                        mainPanel("main panel")
                      )  
                      
                      
                      
                      
             ),
              
             navbarMenu("More", 
                        tabPanel("Other",
                                 sidebarLayout(
                                   sidebarPanel( "sidebar panel"),
                                   mainPanel("main panel")
             )  
             ))
  )
))
