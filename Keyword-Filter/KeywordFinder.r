#============================================================================#
# This code is to filter keyword in title, claim, abstract of patents 
# automatically.  The occurrence of keyword in these fields and total 
# occurrence are counted 
# 
# Input:  A CSV format file converted from a xlsx file dumped from M-Trends, 
#         including SN, patent number, title, claim, abstract, assignee, 
#         assginee's address, assignee's country, and data source.
#
# Return: A xlsx file including patent number, keyword occurrence in title, 
#         claim, and abstract, respectively, and total keyword occurrence, 
#         as well as title, claim, and abstract associated with patent number.
#
# Alf Tang, 2015/07/01
#============================================================================#

library("openxlsx") # Load package to deal with xlsx file
library("stringr") # Load package to deal with text string

# Set zip path so R could use write.xlsx requiring zip tool in Rtools
Sys.setenv(R_ZIPCMD = "C:/Program Files/Rtools/bin/zip")

# Load data, it shall allow user to select from locale in the future version
rawData <- read.csv("test.csv")

# Define column names
outputNames <- c("PN","Keywords in Title","Keywords in Claim","Keywords in Abst","Total count", "Title", "Claim", "Abstract")

# Count the occurrence of keyword in Title (the keyword is "board" here)
keywordTitle <- str_count(rawData[,4], "board")

#length(regmatches(rawData$Title[2275],gregexpr("\\bboard\\b",tolower(rawData$Title[2275]),perl=TRUE))[[1]])
# http://r.789695.n4.nabble.com/str-count-counts-the-substring-td4677235.html

# Count the occurrence of keyword in Claim
keywordClaim <- str_count(rawData[,8], "board")

# Count the occurrence of keyword in Abstract
keywordAbstract <- str_count(rawData[,9], "board")

# Count total occurrence of keyword
totalCount <- keywordTitle[] + keywordClaim[] + keywordAbstract[]

# Create a data frame to store patent number and keyword occurrence in above fields
outputTest <- data.frame(as.character(rawData$PN), keywordTitle, keywordClaim, keywordAbstract, totalCount, rawData$Title, rawData$Claim, rawData$Abstract)

# Select data where the keyword appears in either title, claim, or abstract
outputTest <- outputTest[outputTest$totalCount > 0,]

# Set column names to the data frame
colnames(outputTest) <- outputNames

# Remove '0' in the beginning of US patent numbers dumped from M-Trends
outputTest$PN <- gsub("^0", "", outputTest$PN)

# Dump the filtered result in xlsx format
write.xlsx(outputTest, file="output.xlsx")
