## Problem 1.
# The American Community Survey distributes downloadable data about United 
# States communities. Download the 2006 microdata survey about housing for 
# the state of Idaho using download.file() from here: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
#
# and load the data into R. The code book, describing the variable names is here: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
#
# Create a logical vector that identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products. Assign that 
# logical vector to the variable agricultureLogical. Apply the which() 
# function like this to identify the rows of the data frame where the logical 
# vector is TRUE. which(agricultureLogical) What are the first 3 values that result?

# Download data from website
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dt <- read.csv(url)
# Create logical vector that identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products
agricultureLogical <- dt$ACR >= 3 & dt$AGS >= 6
table(agricultureLogical)
# Get the first three values
head(which(agricultureLogical), n=3)

## Problem 2.
# Using the jpeg package read in the following picture of your instructor 
# into R 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
#
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of 
# the resulting data? (some Linux systems may produce an answer 638 
# different for the 30th quantile)

# Load jpeg package 
install.packages("jpeg")
library(jpeg)
# Read in the following picture of your instructor into R
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url, "./jeff.jpg", mode = "wb")
picture <- readJPEG('jeff.jpg', native = TRUE)
# Get data for 30th and 80th quantiles
quantile(picture, probs = c(0.3,0.8))

## Problem 3.
# Load the Gross Domestic Product data for the 190 ranked countries 
# in this data set: 
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
#
# Load the educational data from this data set: 
#  
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
#
# Match the data based on the country shortcode. How many of the IDs 
# match? Sort the data frame in descending order by GDP rank (so United 
# States is last). What is the 13th country in the resulting data frame? 
#
# Original data sources: 
#  http://data.worldbank.org/data-catalog/GDP-ranking-table 
#  http://data.worldbank.org/data-catalog/ed-stats

library(plyr)
# Download file 1 and file 2
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url1, destfile = "./FGDP.csv", method = "auto")
download.file(url2, destfile = "./FEDSTATS_Country.csv", method = "auto")  
# Load data into R
FGDP <- read.csv("./FGDP.csv")
FGDP <- FGDP[-(1:4),c(1,2,4,5)]
colnames(FGDP) <- c("CountryCode","Ranking","Economy","GDP")
FEDSTATS <- read.csv("./FEDSTATS_Country.csv")
# Merge data
mergeData <- merge(FGDP, FEDSTATS, by = "CountryCode", all = FALSE)
mergeData <- mergeData[mergeData$Ranking != "",]
# Get result:  the 13th country by GDP rank in descending order
mergeData$GDP <- as.numeric(gsub(",","", mergeData$GDP))
mergeData$Ranking <- as.numeric(paste(mergeData$Ranking))
head(arrange(mergeData,GDP),13)
nrow(mergeData)


## Problem 4.
# What is the average GDP ranking for the "High income: OECD" 
# and "High income: nonOECD" group?

fact <- mergeData$Income.Group
tapply(mergeData$Ranking, fact, mean)

## Problem 5.
# Cut the GDP ranking into 5 separate quantile groups. Make a 
# table versus Income.Group. How many countries are Lower middle 
# income but among the 38 nations with highest GDP?

breaks <- quantile(mergeData$Ranking, probs = seq(0, 1, 0.2), na.rm = TRUE)
mergeData$quantileGDP <- cut(mergeData$Ranking, breaks = breaks)
table(mergeData$quantileGDP, fact)
