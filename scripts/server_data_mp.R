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
#setwd("/Users/Nick/info498f/INFOFinalProject")
#setwd("..") #to be able to write to output in parent directory and read from output

#############################################################
# Load Library
library(dplyr)

#############################################################
# Read in data
OB <- read.csv("output/OB.csv")
OB_S <- read.csv("output/OB_S.csv")
AC <- read.csv("output/AC.csv")
AC_S <- read.csv("output/AC_S.csv")



############################################ DYPLR Functions #########################################################
find_max_min_yr <- function(df, year){
  max <- df %>% select(contains("percent"), year) %>% summarise_each(funs(max))
}



#this function creates a data frame for obesity rates vs activity level with gender neutral
create_summarised_df <- function(df){
  col <- "percent_"
  summarised_df <- df %>% group_by(State) %>% select(contains(col)) %>% summarise_each(funs(mean))
  return(summarised_df)
}

#Creates a data frame for obesity rates vs activity level with gender specific
sum_df_gender <- function(df){
  #Men
  summarised_df_M <- AC_S %>% group_by(State) %>% select(contains("percent (men)_")) %>% summarise_each(funs(mean))
  
  #Women
  colFem <- "percent (women)_"
  summarised_df_F <- df %>% group_by(State) %>% select(contains(colFem)) %>% summarise_each(funs(mean))
  
  #Join Data Frames
  summarised_df_MF <- left_join(summarised_df_M, summarised_df_F, by = "State")
  
  return(summarised_df_MF)
}


#Creates the merged data frame for obesity rates vs activity level with gender neutral
create_final_df <- function(df1, df2){
  #Obesity
  OB_df <- create_summarised_df(df1)
  names(OB_df) <- c("State", "OB_percent_2004", "OB_percent_2005", "OB_percent_2006", "OB_percent_2007", 
                    "OB_percent_2008", "OB_percent_2009", "OB_percent_2010", "OB_percent_2011", "OB_percent_2012")
  
  #Activity level
  AC_df <- create_summarised_df(df2)
  names(AC_df) <- c("State", "AC_percent_2004", "AC_percent_2005", "AC_percent_2006", "AC_percent_2007", 
                    "AC_percent_2008", "AC_percent_2009", "AC_percent_2010", "AC_percent_2011", "AC_percent_2012")
  
  final_df <- left_join(OB_df, AC_df, by = "State")
  
  return(final_df)
}

#Creates the merged data frame for obesity rates vs activity level with gender specific
create_final_df_S <- function(df1, df2){
  #Obesity
  OB_df_S <- sum_df_gender(df1)
  names(OB_df_S) <- c("State", "OB_S_percent(M)_2009", "OB_S_percent(M)_2010", "OB_S_percent(M)_2011", "OB_S_percent(M)_2012",
                      "OB_S_percent(F)_2009", "OB_S_percent(F)_2010", "OB_S_percent(F)_2011", "OB_S_percent(F)_2012")
  
  #Activity level
  AC_df_S <- sum_df_gender(df2)
  names(AC_df_S) <- c("State", "AC_S_percent(M)_2009", "AC_S_percent(M)_2010", "AC_S_percent(M)_2011", "AC_S_percent(M)_2012",
                      "AC_S_percent(F)_2009", "AC_S_percent(F)_2010", "AC_S_percent(F)_2011", "AC_S_percent(F)_2012")
  
  final_df <- left_join(OB_df_S, AC_df_S, by = "State")
  
  return(final_df)
}

#Create summary table with percentage change for each year
write_sum_tbl <- function(){
  #Create Summary Table OB
  nums <- finished_df %>% select(1:9) %>% mutate("OBchange'04 (in %)" = 0)
  nums <- nums %>% mutate("OBchange'05 (in %)" = round(finished_df$OB_percent_2005 - finished_df$OB_percent_2004, 3))
  nums <- nums %>% mutate("OBchange'06 (in %)" = round(finished_df$OB_percent_2006 - finished_df$OB_percent_2005, 3))
  nums <- nums %>% mutate("OBchange'07 (in %)" = round(finished_df$OB_percent_2007 - finished_df$OB_percent_2006, 3))
  nums <- nums %>% mutate("OBchange'08 (in %)" = round(finished_df$OB_percent_2008 - finished_df$OB_percent_2007, 3))
  nums <- nums %>% mutate("OBchange'09 (in %)" = round(finished_df$OB_percent_2009 - finished_df$OB_percent_2008, 3))
  nums <- nums %>% mutate("OBchange'10 (in %)" = round(finished_df$OB_percent_2010 - finished_df$OB_percent_2009, 3))
  nums <- nums %>% mutate("OBchange'11 (in %)" = round(finished_df$OB_percent_2011 - finished_df$OB_percent_2010, 3))
  nums <- nums %>% mutate("OBchange'12 (in %)" = round(finished_df$OB_percent_2012 - finished_df$OB_percent_2011, 3))
  nums <- nums %>% select(-2:-9)
  
  #Create Summary Table AC
  nums2 <- finished_df %>% select(1, 11:19) %>% mutate("ACchange'04 (in %)" = 0)
  nums2 <- nums2 %>% mutate("ACchange'05 (in %)" = round(finished_df$AC_percent_2005 - finished_df$AC_percent_2004, 3))
  nums2 <- nums2 %>% mutate("ACchange'06 (in %)" = round(finished_df$AC_percent_2006 - finished_df$AC_percent_2005, 3))
  nums2 <- nums2 %>% mutate("ACchange'07 (in %)" = round(finished_df$AC_percent_2007 - finished_df$AC_percent_2006, 3))
  nums2 <- nums2 %>% mutate("ACchange'08 (in %)" = round(finished_df$AC_percent_2008 - finished_df$AC_percent_2007, 3))
  nums2 <- nums2 %>% mutate("ACchange'09 (in %)" = round(finished_df$AC_percent_2009 - finished_df$AC_percent_2008, 3))
  nums2 <- nums2 %>% mutate("ACchange'10 (in %)" = round(finished_df$AC_percent_2010 - finished_df$AC_percent_2009, 3))
  nums2 <- nums2 %>% mutate("ACchange'11 (in %)" = round(finished_df$AC_percent_2011 - finished_df$AC_percent_2010, 3))
  nums2 <- nums2 %>% mutate("ACchange'12 (in %)" = round(finished_df$AC_percent_2012 - finished_df$AC_percent_2011, 3))
  nums2 <- nums2 %>% select(-2:-10)
  summaryTable <- left_join(nums, nums2, by = "State")
  
  return(summaryTable)
}


############################################ Data Manipulation #########################################################




#Final data frames
finished_df <- create_final_df(OB, AC)

#finished_df_S <- create_final_df_S(OB_S, AC_S)
# creates error: 
              # Error in names(OB_df_S) <- c("State", "OB_S_percent(M)_2009", "OB_S_percent(M)_2010",  : 
              #                                'names' attribute [9] must be the same length as the vector [1]

#Summary Table for percentage change in obesity and activity level by year
sumTbl <- write_sum_tbl()


#Summary Information
##highest obesity states by year
# high_OB <- finished_df %>% arrange(1:19) 
#Creates error: Error: incorrect size (19), expecting : 52

############################################ Write data to csv #########################################################

#Write final data frames to CSV
write.csv(finished_df, file = "output/OBandAC_DF.csv", row.names = FALSE)
#write.csv(finished_df_S, file = "output/OB_SandAC_S_DF.csv", row.names = FALSE)
write.csv(sumTbl, file = "output/OBvsAC_sumTbl.csv", row.names = FALSE)




