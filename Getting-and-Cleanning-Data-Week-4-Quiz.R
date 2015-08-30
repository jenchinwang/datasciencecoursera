## Problem 1.
# Question 1
# The American Community Survey distributes downloadable data about United 
# States communities. Download the 2006 microdata survey about housing for
# the state of Idaho using download.file() from here: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
#
# and load the data into R. The code book, describing the variable names 
# is here: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
#
# Apply strsplit() to split all the names of the data frame on the characters 
# "wgtp". What is the value of the 123 element of the resulting list?

# Download data from website
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url1, destfile = "./Idaho2006.csv", method = "auto")
dt1 <- read.csv("./Idaho2006.csv")
# Split all the names of the data frame on the characters "wgtp"
splitNames <- strsplit(names(dt1),"wgtp")
# Retrieve value store in the 123rd element in this list
splitNames[123]



## Problem 2.
# Load the Gross Domestic Product data for the 190 ranked countries in 
# this data set: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
#
# Remove the commas from the GDP numbers in millions of dollars and average 
# them. What is the average? 
#
# Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table

# Download data from website
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url2, destfile = "./FGDP.csv", method = "auto")
dt2 <- read.csv("./FGDP.csv")
# Reconstruct data frame, retain only the columns and rows that carry meaningful variables
FGDP <- dt2[c(5:194),c(1,2,4,5)]
# Give name to variables
colnames(FGDP) <- c("CountryCode","Ranking","Economy","GDP")
# Transform GDP data from facotrs to character in order to get rid of the commas
GDP <- as.character(FGDP$GDP)
# Remove commas and space from GDP strings
GDP <- gsub(",| ","",GDP)
# Transform data from character to numeric so arithmetic operation can be performed
FGDP$GDP <- as.numeric(GDP)
# Use mean function to calculate the average of GDP of all 190 ranked countries
mean(FGDP$GDP)



## Problem 3.
# In the data set from Question 2 what is a regular expression that would allow you 
# to count the number of countries whose name begins with "United"? Assume that the 
# variable with the country names in it is named countryNames. How many countries 
# begin with United?

# Subset data "countryNames" from FGDP
countryNames <- FGDP$Economy
# Regluar expression: show country names, those begin with "United"
grep("^United",countryNames, value = TRUE)



## Problem 4.
# Load the Gross Domestic Product data for the 190 ranked countries in 
# this data set: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
#
# Load the educational data from this data set: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
#
# Match the data based on the country shortcode. Of the countries for which 
# the end of the fiscal year is available, how many end in June? 
#
# Original data sources: 
# http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats

# Download educational data from website
url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url3, destfile = "./ED-STATS.csv", method = "auto")
EDSTATS <- read.csv("./ED-STATS.csv")
# Merge two data set on Country Code
mergeData <- merge(FGDP, EDSTATS, by = "CountryCode", all.x = TRUE)
# Use regular expression to subset the records with indication "Fiscal year end in June in special note
FYinJune <- grep("^Fiscal year end: June", mergeData$Special.Notes)
# Number of country that satified the specified condition
length(FYinJune)



## Problem 5.
# You can use the quantmod (http://www.quantmod.com/) package to get historical 
# stock prices for publicly traded companies on the NASDAQ and NYSE. Use the 
# following code to download data on Amazon's stock price and get the times the data 
# was sampled.
# library(quantmod)
# amzn = getSymbols("AMZN",auto.assign=FALSE)
# sampleTimes = index(amzn) 
# How many values were collected in 2012? How many values were collected on Mondays in 2012?

# Install package quantmod
install.packages("quantmod")
# Use the following code to download data on Amazon's stock price and get the times the data 
# was sampled
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
# Verify the data type
class(sampleTimes)
# How many values were collected in 2012?
samplein2012 <- grep("^2012", sampleTimes)
length(samplein2012)
# How many values were collected on Mondays in 2012?
format(sampleTimes, "%a %m %d %Y")
samplein2012onMon <- grep("Mon (.*) 2012", format(sampleTimes, "%a %m %d %Y"))
length(samplein2012onMon)


