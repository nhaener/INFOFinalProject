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
# setwd("")

#############################################################
## Install any packages
# install.packages("DataCombine")

#############################################################
## Library
library(DataCombine)
library(dplyr)

#############################################################
#Source data formatting functions
source("format_functions.R")

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
# Sets LL Column names 
colnames(LL) <- c("State", "GEOID", "ANSICODE", "County", "Lat", "Long")

#############################################################
#############################################################
## Section to: correct column names of all files
#############################################################
#############################################################

# Formats column names for each file
OB <- format_data(OB, 2004:2012, 4, 11)
OB_S <- format_data(OB_S, 2009:2012, 4, 18)
AC <- format_data(AC, 2004:2012, 4, 11)
AC_S <- format_data(AC_S, 2009:2012, 4, 18)


#############################################################
#############################################################
## Section to: remove unnecessary information
#############################################################
#############################################################
OB <- remove_cols(OB)
OB_S <- remove_cols(OB_S)
AC <- remove_cols(AC)
AC_S <- remove_cols(AC_S)


#############################################################
#############################################################
## Section to: change percents and numbers to integer values
#############################################################
#############################################################

OB <- make_numeric(OB)
OB_S <- make_numeric(OB_S)
AC <- make_numeric(AC)
AC_S <- make_numeric(AC_S)

#############################################################
#############################################################
## Section to: add LL data to all files
#############################################################
#############################################################

OB <- add_location(OB, LL)
OB_S <- add_location(OB_S, LL)
AC <- add_location(AC, LL)
AC_S <- add_location(AC_S, LL)
