# INFOFinalProject
INFO 498f Final Group Project

# Project Proposal

## Description

### What is the data?
Data set from: http://www.cdc.gov/diabetes/atlas/countydata/County_ListofIndicators.html
Stored in sub directory data
This data set is based on information from the CDC website on obesity rates by county in each state. This data set has obesity statistics from 2004 to 2012. 

Other possible data sets in addition to obesity data:
- Obesity related health care spending
- Obese population demographics (age, gender, race, other characteristics)
- Data on physical activity (geographically)


### Who is the data for?
This data is for people who want to learn about obesity prevalence (prevalence by state and prevalence by sex by state). Also those people who want to see the relationship between obesity prevalence and diagnosed diabetes prevalence and leisure-time physical inactivity prevalence. 

- Health care industry (obesity impacts hospital infrastructure such as bed size, availability of lifts to help move patients, staff training to safely care for over weight patients, etc.)
- legislators (they set funding levels for health care spending, research on obesity related illnesses)
- other government officials (national, state, local) that set the policies to deal with the impacts of a increasingly obese population. 


### What do they want to learn?
The audience may want to compare obesity prevalence between sexes within a state or between two states. Three example questions may be:
- What is the obesity prevalence of men in Washington state compared to obesity prevalence in women?
- How do the regions of America (west, midwest, south, etc.) compare in terms of obesity prevalence?
- How has obesity prevalence changed over the eight years represented in data?

## Technical Description

### Format?
Shiny app, allowing client to filter obesity data based on different factors such as seeing overall data for state, county level data, data for specific year, etc. 

### Reading in data?
These datasets will be read in as static .csv files, likely with the `read.csv()` function and set to variable(s) to be manipulated and used to visualize.

### Types of data-wrangling
We'll likely be needing to use `select()`, `filter()`, and various join functions to view/alter data from multiple datasets for given years. We may need to compile all the datasets we're using into a single data frame.

### What (new) libraries will be used?
We will mainly be using `Shiny` and `plotly`. We may experiment with the use of other data visualization packages such as `googleVis` and `choroplethr`.

### Questions answered with statistical analysis/machine learning?

### What major challenges do you anticipate?
- One major challenge will be figuring out what visualization will provide the clearest picture of the problem with obesity. This will still need to provide enough detail to allow the client to see possible solutions/or areas to look into in more detail. 
- The other major challenge will be figuring out what other data should be included with obesity statistics to give a better picture of the impact of obesity in other areas.

