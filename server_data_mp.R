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

#This function takes in a state, data frame, and a year and returns a 
#data frame containing averaged information regarding that state for that given year


#this function createS A LARGE DATA FRAME CONTAINING SUMMARISED INFORMATION ABOUT EACH STATE
create_summarised_df <- function(df){
  col <- "percent_"
  summarised_df <- df %>% group_by(State) %>% select(contains(col)) %>% summarise_each(funs(mean))
  return(summarised_df)
}

create_final_df <- function(df1, df2){
  #Obesity
  OB_df <- create_summarised_df(df1)
  names(OB_df) <- c("State", "OB_percent_2004", "OB_percent_2005", "OB_percent_2006", "OB_percent_2007", 
                    "OB_percent_2008", "OB_percent_2009", "OB_percent_2010", "OB_percent_2011", "OB_percent_2012")
  #colnames(OB_df[,-1]) <- colnames(OB_df[,-1], prefix = "OB_")
  
  #Activity level
  AC_df <- create_summarised_df(df2)
  names(AC_df) <- c("State", "AC_percent_2004", "AC_percent_2005", "AC_percent_2006", "AC_percent_2007", 
                    "AC_percent_2008", "AC_percent_2009", "AC_percent_2010", "AC_percent_2011", "AC_percent_2012")
  
  final_df <- left_join(OB_df, AC_df, by = "State")
  
  return(final_df)
}

finished_df <- create_final_df(OB, AC)

write.csv("data/OBandAC_DF.csv")

#finished_df_Sex <- create_final_df(OB_S, AC_S)

