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
             tabPanel("Documentation",
                        mainPanel( 
                          #HTML Formatted Text
                          h1("Project Documentation"),
                          h3("Created by: Nick Haener, Christopher Kites, Alexander Bonilla, Warren Cho"),
                          br(), 
                          h2("Project Description"), 
                          h3("What is the data?"),
                          p("All the data sets we worked with can be found at: http://www.cdc.gov/diabetes/atlas/countydata/County_ListofIndicators.html "), 
                          p("For a quick link to the site", 
                            tags$a(href = "http://www.cdc.gov/diabetes/atlas/countydata/County_ListofIndicators.html", "Click Here!")),
                          p("This data set is based on information from the CDC website on obesity rates by county in each state. 
                             This data set has obesity statistics from 2004 to 2012."),
                          p("The data sets we used are:"), 
                          tags$ul(
                            tags$li("Obesity Prevalance"), 
                            tags$li("Leisure-time physical inactivity prevalance")),
                          h3("Why do we care?"),
                          p("This data teaches you about the obesity prevalence (prevalence by state) and visualizes the relationship between obesity prevalence 
                            and leisure-time devoted to physical activity. This information can be used for an array of purposes including but not limited to:"),
                          tags$ul(
                            tags$li("Health care industry (obesity impacts hospital infrastructure such as bed size, availability of lifts to help move patients, 
                                    staff training to safely care for over weight patients, etc.)"),
                            tags$li("legislators (they set funding levels for health care spending, research on obesity related illnesses)"),
                            tags$li("other government officials (national, state, local) that set the policies to deal with the impacts of a increasingly obese population.")
                          ),br(),
                          h2("Technical Description"),
                          h3("What libraries were used?"),
                          p("To create the visual representations we used ", 
                            #Linked Library Documentation
                            tags$a(href = "http://shiny.rstudio.com/", "shiny"), ", ",
                            tags$a(href = "https://plot.ly/r/", "plotly"), ", ",
                            tags$a(href = "https://cran.r-project.org/web/packages/choroplethr/", "choroplethr"), ", ",
                            tags$a(href = "https://cran.r-project.org/web/packages/choroplethrMaps/index.html", "choroplethrMaps"), ", and ",
                            tags$a(href = "https://cran.r-project.org/web/packages/shinyjs/shinyjs.pdf", "shinyjs"), ". ",
                            "For the in depth data manipulation we used ",
                            tags$a(href = "https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html", "dplyr"), "."
                            ),
                          h3("What aspects of the data sets were used?"),
                          p("We focused mainly on the percentages of people obese and the percentage of time during lesiure time spent inactive with respect 
                                to every state in the U.S. and every county within each state. Below is a breakdown of what the terms used mean:", 
                            tags$ul(
                              tags$li("County - All counties within given state"),
                              tags$li("Surveyed - Number of people surveyed in a given state or county"),
                              tags$li("Percent Obese - a person is considered obese if they have a Body Mass Index (BMI) of over 30; for a given county, this is the direct 
                              percentage of people obese from the number of people surveyed; for a given state, Percent Obese refers to the the state average of people who are obese.")
                            )
                          
                          

                        )
             )
    ))
))


#################################################SHINY HTML DOCUMENTATION ######################################################

# link to documentation: http://shiny.rstudio-staging.com/tutorial/lesson2/
# shiny function	HTML5 equivalent	creates
# p	      <p>	      A paragraph of text
# h1	    <h1>	    A first level header
# h2	    <h2>	    A second level header
# h3	    <h3>	    A third level header
# h4	    <h4>	    A fourth level header
# h5	    <h5>	    A fifth level header
# h6	    <h6>	    A sixth level header
# a	      <a>	      A hyper link
# br	    <br>	    A line break (e.g. a blank line)
# div	    <div>	    A division of text with a uniform style
# span    <span>	  An in-line division of text with a uniform style
# pre	    <pre>	    Text ‘as is’ in a fixed width font
# code    <code>	  A formatted block of code
# img	    <img>	    An image
# strong	<strong>	Bold text
# em	    <em>	    Italicized text
# HTML	 	          Directly passes a character string as HTML code


# ui.R Example
#shinyUI(fluidPage(
#   titlePanel("My Shiny App"),
#   sidebarLayout(
#     sidebarPanel(),
#     mainPanel(
#       p("p creates a paragraph of text."),
#       p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
#       strong("strong() makes bold text."),
#       em("em() creates italicized (i.e, emphasized) text."),
#       br(),
#       code("code displays your text similar to computer code"),
#       div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
#       br(),
#       p("span does the same thing as div, but it works with",
#         span("groups of words", style = "color:blue"),
#         "that appear inside a paragraph.")
#     )
#   )
# ))








