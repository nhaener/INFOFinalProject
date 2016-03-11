#This file creates an output of 2 plotly graphs and 2 output tables that show projections of obesity and inactivity
#------------------------------------------------------------------------------------------------------------------
#setwd("C:/Users/Alexander/Documents/School/College/info498/INFOFinalProject/output/")
#setwd("..") #To be able to write to output in parent directory
#source("data_format.R")

#############################################################
# Load Library
library(dplyr)
library(plotly)

#############################################################
# Read in data
OB <- read.csv("output/OB.csv")
AC <- read.csv("output/AC.csv")

############################################ Functions #########################################################

#function that returns a dataframe with predicted values for 2013-2020
calc_rate <- function(data) {
             df <- data
             df <- df %>%
                    mutate(rate1 = percent_2005 - percent_2004,
                           rate2 = percent_2006 - percent_2005,
                           rate3 = percent_2007 - percent_2006,
                           rate4 = percent_2008 - percent_2007,
                           rate5 = percent_2009 - percent_2008,
                           rate6 = percent_2010 - percent_2009,
                           rate7 = percent_2011 - percent_2010,
                           rate8 = percent_2012 - percent_2011) %>% 
             mutate(rate = rate1 + rate2 + rate3 + rate4 + rate5 + rate6 + rate7 + rate8 / 9)
             return (df)
}

#function to calculate percent increase
calc_percent_increase <- function(data) {
                         df <- group_by(data, State) %>%
                               summarise(
                                 total_growth = sum(rate, na.rm = TRUE),
                                 num_counties = n()
                               ) %>% 
                               mutate(percent_increase = total_growth / num_counties)
                         return (df)
}

#function that generates df with values that go up to 2020 for each state
generate_2025_val <- function(data, data_with_percent_increase) {
                     df_2012 <- group_by(data, State) %>% 
                                summarise(
                                  percent_2004 = mean(percent_2004, na.rm = TRUE),
                                  percent_2005 = mean(percent_2005, na.rm = TRUE),
                                  percent_2006 = mean(percent_2006, na.rm = TRUE),
                                  percent_2007 = mean(percent_2007, na.rm = TRUE),
                                  percent_2008 = mean(percent_2008, na.rm = TRUE),
                                  percent_2009 = mean(percent_2009, na.rm = TRUE),
                                  percent_2010 = mean(percent_2010, na.rm = TRUE),
                                  percent_2011 = mean(percent_2011, na.rm = TRUE),
                                  percent_2012 = mean(percent_2012, na.rm = TRUE)
                                )
                     df_2025 <- left_join(df_2012, data_with_percent_increase, by = 'State')
                     
                     df_final <- df_2025 %>% 
                                 mutate(net_change = percent_increase / 9) %>% 
                                 mutate(percent_2017 = percent_2012 + net_change + net_change + net_change + net_change + net_change) %>% 
                                 mutate(percent_2019 = percent_2017 + net_change + net_change) %>% 
                                 mutate(percent_2021 = percent_2019 + net_change + net_change) %>%
                                 mutate(percent_2023 = percent_2021 + net_change + net_change) %>%
                                 mutate(Change = net_change * 13) %>% 
                                 mutate(percent_2025 = percent_2012 + Change) %>% 
                                 select(-total_growth, -num_counties, -percent_increase)
                     return (df_final)
}

############################################ Data Manipulation #########################################################

#using 'predict' function to create obeisty and leisure activity df's with predicted values
obesity_rate <- calc_rate(OB)
inactivity_rate <- calc_rate(AC)

#rate of obesity growth by state, uses function above
state_obesity_percent_increase <- calc_percent_increase(obesity_rate)
state_inactivity_percent_increase <- calc_percent_increase(inactivity_rate)

#top rankers in obesity/inactivity trends
states_growing_most_obese <- state_obesity_percent_increase %>% filter(percent_increase > 6)
states_growing_most_inactive <- state_inactivity_percent_increase %>% filter(percent_increase > 2)

#generating df's with data to 2020
obesity_2025 <- generate_2025_val(obesity_rate, state_obesity_percent_increase)
inactivity_2025 <- generate_2025_val(inactivity_rate, state_inactivity_percent_increase)

#taking out Puerto Rico
obesity_2025 <- obesity_2025[obesity_2025$State != "Puerto Rico", ]
inactivity_2025 <- inactivity_2025[inactivity_2025$State != "Puerto Rico", ]

#rounding all values in df's
obesity_2025[,-1] <- round(obesity_2025[,-1], 2)
inactivity_2025[,-1] <- round(inactivity_2025[,-1], 2)

#creating df's to display under graphs
projected_obesity <- obesity_2025 %>% 
                     select(-Change, -(percent_2004:percent_2012))

projected_inactivity <- inactivity_2025 %>% 
                        select(-Change, -(percent_2004:percent_2012))

#changing colnames
newcol <- c("State", "Yearly Increase/Decrease", "2017", "2019", "2021", "2023", "2025")
colnames(projected_obesity) <- newcol
colnames(projected_inactivity) <- newcol


############################################ Write data to csv #########################################################

#writing final df's to csv
write.csv(projected_obesity, file = "output/projected_obesity.csv", row.names = FALSE)
write.csv(projected_inactivity, file = "output/projected_inactivity.csv", row.names = FALSE)

write.csv(obesity_2025, file = "output/obesity_2025.csv", row.names = FALSE)
write.csv(inactivity_2025, file = "output/inactivity_2025.csv", row.names = FALSE)




#############################################################
#############################################################
##
## Code to plot data created with this script
##
#############################################################
#############################################################

# #graphing obesity
# plot_ly(obesity_2025,
#         x = net_change,
#         y = State,
#         text = paste(
#           '<b>Percent Increase by Year:</b>', net_change,
#           '<br><b>Percent Obese in 2005:</b>', percent_2005,
#           '<br><b>Percent Obese by 2025:</b>', percent_2025
#         ),
#         mode = "markers",
#         color = Change) %>%
#   layout(title = "Current Obesity Percentage Projected into 2025",
#          xaxis = list(title = "Percent Increase in Obesity"),
#          yaxis = list(title = "State"),
#          margin = list(l = 150))
# 
# #graphing inactivity
# plot_ly(inactivity_2025,
#         x = net_change,
#         y = State,
#         text = paste(
#           '<b>Percent Increase by Year:</b>', net_change,
#           '<br><b>Percent Inactive in 2005:</b>', percent_2005,
#           '<br><b>Percent Inactive by 2025:</b>', percent_2025
#         ),
#         mode = "markers",
#         color = Change) %>%
#   layout(title = "Current Inactivity Percentage Projected into 2025",
#          xaxis = list(title = "Percent Increase in Inactivity"),
#          yaxis = list(title = "State"),
#          margin = list(l = 150))