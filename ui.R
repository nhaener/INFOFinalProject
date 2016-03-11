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
library(shinyjs)


#############################################################
# Load manipulated data
#source("server_data_mp.R")
source("PAGE_Overview_data_mp.R")



# Define UI
shinyUI(fluidPage(theme = "bootstrap.css", #sets theme for web app
  useShinyjs(), # Set up toggle ability
  navbarPage("USA Obesity",
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
                        
                        sidebarPanel("Use the slider below to select which year to visualize data for",
                                     
                                     sliderInput("year", label = h3("View data for the year:"), min = 2004, max = 2012, value = 2012,
                                                 sep = "")
                                     
                        ),
                        
                        mainPanel(
                          h4("The two maps below display the prevalence of obesity across American states for a given year
                             (upper map) and the percentage of leisure time that people of a state do not spend performing 
                             physical activity for the same year (lower map). The intensity of the colors of the maps are 
                             directly related to the percentage of that state's population that is considered obese or the 
                             average percentage of leisure time people of a state are spending inactive."),
                          br(),
                          br(),
                          plotlyOutput('obmap'),
                          plotlyOutput('acmap')
                          )
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
