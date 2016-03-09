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
             tabPanel("Overview"
                      
                      
                      
              ),
             tabPanel("Obesity & Activity"),
             tabPanel("Trends"),
             tabPanel("Resources"),
              
             navbarMenu("More", 
                        tabPanel("Other"))
  )
))
