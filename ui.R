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

# Define UI
shinyUI(fluidPage(
  
  navbarPage("US Obesity",
             tabPanel("Overview"#,
                    
                      #plotlyOutput("OB_St_level"),
                      #sliderInput("OB_st_level_year")
                      
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
