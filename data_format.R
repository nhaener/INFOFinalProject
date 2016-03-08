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
# setwd()

#############################################################
## Library
library(DataCombine)
library(apply)
library(dplyr)


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
OB_S <- format_data(OB_S, 2009:2012, 4, 17)
AC <- format_data(AC, 2004:2012, 4, 10)
AC_S <- format_data(AC_S, 2009:2012, 4, 17)

# Changes column names in each file
OB <- fix_df(OB, OB_col_names)


# Format data function
format_data <- function(df, years, start, end) {
  df_repeated_col <- get_last(df, 1, start, end)
  df_col_names <- c("State", "FIPS_Codes", "County", years(df_repeated_col, years))
  df <- fix_df(df, df_col_names)
  return(df)
}

# Functions to add year to col names, return vector of strings
years <- function(col_values, years) {
  values <- c()
  for (int in years) {
    values <- append(values, cn_year(col_values, int))
  }
  return(values)
}

cn_year <- function(col_values, year) {
  values <- c()
  for (string in col_values) {
    values <- append(values, value_year(string, year))
  }
  return(values)
}

value_year <- function(value, year) {
  return(paste(value, year, sep = "_"))
}

# function to get last value
get_last <- function(df, row, start, end) {
  df <- df[row,start:end]
  values <- c()
  for (int in c(1:(end - start))) {
    values <- append(values, as.character(factor(df[[row, int]])))
  }
  return(values)
}
# Functions to update data sets
fix_df <- function(df, new_colnames) {
  colnames(df) <- new_colnames
  return(df[-1,])
}