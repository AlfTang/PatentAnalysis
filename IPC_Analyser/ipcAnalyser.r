#============================================================================#
# This code is to sort 4th level IPC in data pool from most frequent one to the least
# 
# Input:  A CSV format file including SN, patent number, and IPC.
#
# Return: An IPC list from most frequent one to least in xlsx format
#
# Alf Tang
#============================================================================#
library("openxlsx") # Load package to deal with xlsx file
library("stringr") # Load package to deal with text string
library("tm") # Load package to deal with text mining
# Set zip path so R could use write.xlsx requiring zip tool in Rtools
Sys.setenv(R_ZIPCMD = "C:/Program Files/Rtools/bin/zip")
# Load raw data
rawdata <- read.csv("test.csv")
# Change all IPC 5th level to "/00"
IPCtemp <- gsub("/[[:digit:]]+", "/00", rawdata$IPC)
# Remove all whitespace
IPCtemp <- gsub(" ", "", IPCtemp)
# IPCs are separated by "\n", so change all "\n" to whitespace
IPCtemp <- gsub("\n", " ", IPCtemp)
# Separate all IPCs by whitespace and store to "IPCtemp2"
IPCtemp2 <- paste(IPCtemp, collapse = " ")
# Set up a text source
reviewSource <- VectorSource(IPCtemp2)
# Create a corpus from the source
corpus <- Corpus(reviewSource)
# Create a document-term matrix stored in sparse matrix
dtm <- DocumentTermMatrix(corpus)
# Sum up the matrix giving a named vector, and sort it to see the most frequent words
freq <- sort(colSums(as.matrix(dtm)), decreasing = TRUE)
# Write data out in xlsx format
output <- data.frame(names(freq), freq)
# Change column names to "4th IPC" and "Frequency"
names(output) <- c("4th IPC", "Frequency")
# Convert IPC to upper case
output$`4th IPC` <- toupper(output$`4th IPC`)
# Dump the result in xlsx format
write.xlsx(output, file="output.xlsx")
