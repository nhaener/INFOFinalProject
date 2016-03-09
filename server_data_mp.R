#############################################################
#############################################################
## This file will be used to manipulate our data sets and 
## retrieve relevant information.
##
## File name convention:
## OB <- Obesity Prevalence
## S <- sex
## AC <- Activity
## LL <- Lat & Long
## AB <- State Abbreviation names 
## See google doc and/or issues for what needs to be done.
##
#############################################################
#############################################################

########################## DATA Manipulation ######################################
###################################################################################
## Set working directory
setwd("/Users/Nick/info498f/INFOFinalProject")

## Source formatted data
source("data_format.R")

## Library 
library(dplyr)

#DYPLR functions
avg_OB_yr_state <- function(df, year, my_state){
  #Filter data frame by state and select year
  my_df <- df %>% select(1:3, contains(year)) %>% 
    filter(df$State == my_state)
  
  #create columns
  #colNames <- c(my_state, year, 'Average Percent Obese')
  perCol <- paste0("percent_", year)
  
  #make numeric
  #my_df[,perCol] <- as.numeric(levels(my_df[,perCol])[my_df[,perCol]])
  
  #get rounded average for obesity
  avg <- my_df %>% summarise(mean(my_df[,perCol]))
  rounded_avg <- round(avg, digits = 1)
  
  #create new data frame
  avg_df <- data.frame(my_state, year, rounded_avg)
  names(avg_df) <- c(my_state, year, 'Average Percentage Obese')
  
  return(avg_df)
}

#function test
df <- avg_OB_yr_state(OB,'2004', "Washington")


