###################################### Data Format Functions ###################################
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

