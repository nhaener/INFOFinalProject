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
library(choroplethr)
library(choroplethrMaps)
library(shinyjs)

#############################################################
# Sources
source("scripts/server_and_ui_functions.R")


# Define UI
shinyUI(fluidPage(theme = "bootstrap.css", #sets theme for web app
        useShinyjs(), # Set up toggle ability
        navbarPage("USA OBESITY",
           #############################################################
           ## UI for Overview page
           tabPanel("Overview",
                    sidebarLayout(
                      sidebarPanel( "View Settings:", width = 3,
                                    # Slider to select what year to show data for on map and table
                                    # Has animation that goes through years
                                    sliderInput("Overview_OB_map_slider_year",
                                                2004, 2012, 1, sep = "",
                                                label = "Select year", 
                                                animate = animationOptions(interval = 4000)),
                                    # Dropdown box to select national or state to view  
                                    selectInput("Overview_OB_map_select_state",
                                                choices = c("National", choices_state()),
                                                label = "Select focus (National or State)"),
                                    # Toggle for showing data table below map
                                    checkboxInput("Overview_OB_map_data_show_table",
                                                  label = "Display data")
                      ),
                      mainPanel(
                        # Renders the map of obesity data
                        plotOutput("Overview_OB_map"),
                        # Renders the data table
                        dataTableOutput("Overview_OB_map_data"),
                        
                        # Text giving an introduction to our project and data
                        p("The American waistline has been steadily rising over the past several decades.  
                          Just how much however depends on many factors, such as location, age, sex, 
                          genetics, etc. This resource focuses on how location plays a role in rates of 
                          obesity. Obesity is defined as someone with a Body Mass Index greater than 30. 
                          (For example, someone with a height of 5\' 8\" would be considered obese if 
                          they weigh 200 pounds or more). This resource provides information about obesity 
                          rates in the United States, including information on rates by county. The graphic 
                          above can be used to see obesity rates for the entire country, or for a selected 
                          state using the \"Select focus\" dropdown on the right.  To select the year to 
                          display data for use the \"Select year\" dropdown.  To see the specific obesity 
                          rates for a given view, select the \"Display data\" option."),
                        br(),
                        p("In addition to data on obesity, the Obesity & Activity page allows for the 
                          comparison between obesity rates by state and the percentage of leisure 
                          time spent being inactive.  On the Trends page, obesity rates are projected 
                          through 2025. The Documentation page provides information on where the obesity 
                          and activity data is from and describes what the values actually mean. ")
                        )
                        )
                        ),
           #############################################################
           ## UI Obesity & Activity
           tabPanel("Obesity & Activity",
                    sidebarLayout(
                      sidebarPanel("Use the slider below to select which year to visualize data for",
                                   # Slider communicates with Server.R to wrangle data for the desired year
                                   sliderInput("year", label = h3("View data for the year:"), min = 2004, max = 2012, value = 2012,
                                               sep = "", animate = animationOptions(interval = 2000, loop = TRUE))
                      ),
                      # contains the information paragraph and the two reactive choropleth maps of obesity and inactivity
                      mainPanel(
                        h4("The two maps below display the prevalence of obesity across American states for a given year
                           (upper map) and the percentage of leisure time that people of a state do not spend performing 
                           physical activity for the same year (lower map). The intensity of the colors of the maps are 
                           directly related to the percentage of that state's population that is considered obese or the 
                           average percentage of leisure time people of a state are spending inactive."),
                        br(), br(),
                        plotlyOutput('obmap'),
                        plotlyOutput('acmap')
                        )
                      )  
                    ),
           
           #############################################################
           ## UI for Trends
           tabPanel("Trends",
                    titlePanel("Trends Projected into 2025"),
                    sidebarLayout(
                      #everything that goes into the side panel, includes text and interactive textbox
                      sidebarPanel("The interactive graphs to the right depict the rate of increase in obesity and inactivity by state.
                                   Hover to see the projected percentages in 2025.",
                                   br(), br(),
                                   "In addition, toggle the button below to display exact percentages for each state by year.",
                                   #adding checkbox
                                   checkboxInput("trends_checkbox", label = "Display data"), br(),
                                   "One of the questions we wanted to ask was if obesity rates correlated with inactivity rates.
                                   According to the data we have gathered, there is actually little evidence to support this:", br(),
                                   strong("Louisiana"), "is the state with the highest projected obesity (see right), but is one
                                   of the few states that is projected to ", strong("decrease"), "rates of inactivity. The same situation
                                   occurs with ", strong("Kentucky"), " (on data table).", br(), br(),
                                   "Finally, the graphs show an interesting phenomenon:", br(), "Even though there are quite a few states
                                   that are projected to ", strong("decrease"), " inactivity levels (see inactivity graph), ", strong("all"), " of 
                                   the states are projected to ", strong("increase"), " obesity rates. This is yet another example of how the graphs show
                                   no correlation between obesity and inactivity."
                      ),
                      #everything that goes into the main panel, includes 2 plotly graphs and 2 data tables that come from 'trendline.R'
                      mainPanel(
                        plotlyOutput("obesity_plot"), br(), br(),
                        dataTableOutput("table1"), br(),
                        plotlyOutput("inactivity_plot"), br(), br(),
                        dataTableOutput("table2")
                      )
                      )
                    ),
           #############################################################
           ## UI for Documentation
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
                          ), br(),
                        tags$img(src = "http://www.vertex42.com/ExcelTemplates/Images/body-mass-index-chart.gif", width = "500px", height = "600px")
                        )
                      )
           )
           ######################################################
           ## End of UI tabs
        )
))




