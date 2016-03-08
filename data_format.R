#############################################################
#############################################################
## This file will be used to organize our data sets into the
## format we need for our project.
##
## File name convention:
## OB <- Obesity Prevalence
## S <- sex
## AC <- Activity
## LL <- Lat & Long
## AB <- State Abbreviation names 
##
## See google doc and/or issues for what needs to be done.
##
#############################################################
#############################################################

#############################################################
## Set working directory
setwd("/Users/Nick/info498f/INFOFinalProject")

#############################################################
## Library
library(DataCombine)
library(dplyr)

#############################################################
#Source data formatting functions
source

#############################################################
## Reads in files to be worked on
LL <- read.csv("data/Lat_long_by_county.csv")
AB <- read.csv("data/StateName_abvr.csv")
OB <- read.csv("data/OB_PREV_ALL_STATES.csv")
OB_S <- read.csv("data/OB_PREV_by_sex_ALL_STATES.csv")
AC <- read.csv("data/LTPIA_PREV_ALL_STATES.csv")
AC_S <- read.csv("data/LTPIA_PREV_by_sex_ALL_STATES.csv")

#############################################################
#############################################################
## Section to work on LL and AB data
#############################################################
#############################################################

# Corrects LL to have full state name, requires DataCombine package 
# to be loaded. 
LL <- FindReplace(LL, "USPS", AB, from = "Abbreviation", to ="US.State",
            exact = TRUE)

#############################################################
#############################################################
## Section to: correct column names of all files
#############################################################
#############################################################

# Formats column names for each file
OB <- format_data(OB, 2004:2012, 4, 10)
OB_S <- format_data(OB_S, 2009:2012, 4, 18)
AC <- format_data(AC, 2004:2012, 4, 10)
AC_S <- format_data(AC_S, 2009:2012, 4, 18)

