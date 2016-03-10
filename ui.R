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
library(choroplethrMaps)
library(shinyjs)


#############################################################
# Load manipulated data
#source("server_data_mp.R")
source("PAGE_Overview_data_mp.R")



# Define UI
shinyUI(fluidPage(theme = "bootstrap.css", #sets theme for web app
  useShinyjs(), # Set up toggle ability
  navbarPage("US Obesity",
             tabPanel("Overview",
                      
                      sidebarLayout(
                        sidebarPanel( "View Settings:",
                            selectInput("Overview_OB_map_select_year",
                                        choices = c(2004:2012),
                                        label = "Select year"),
                          selectInput("Overview_OB_map_select_state",
                                      choices = c("National", choices_state()),
                                      label = "Select focus (National or State)"),
                          checkboxInput("Overview_OB_map_data_show_table",
                                        label = "Display data?")
                          
                        ),
                        mainPanel(
                          plotOutput("Overview_OB_map"),
                          dataTableOutput("Overview_OB_map_data"),
                          p("Introduction to this project will go here
                            along with a description of the information
                            presented on this page, and a breif overview
                            of the information avaiable on the other pages")
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
                        tabPanel("About Us",
                                 sidebarLayout(
                                   sidebarPanel( "sidebar panel"),
                                   mainPanel("main panel")
             )  
             ))
  )
))
