#============================================================================#
# This code is to make a word frequency table based on provided corpus
# 
# Input:  A CSV format file including SN, patent number, title, claim, abstract.
#
# Return: A word frequency table based on provided corpus in xlsx format
#
# Alf Tang
# Ref: Hands-On Data Science with R -- Text Mining by Graham Williams
#============================================================================#
library("openxlsx") # Load package to deal with xlsx file
library("stringr") # Load package to deal with text string
library("tm") # Load package to deal with text mining
library("wordcloud") # Load package to produce word clouds
library("SnowballC")
library("RWeka")
library("sqldf")

# Set zip path so R could use write.xlsx requiring zip tool in Rtools
Sys.setenv(R_ZIPCMD = "C:/Program Files/Rtools/bin/zip")
# Load raw data
rawdata <- read.csv("rawdata.csv")

db=dbConnect(SQLite(), dbname="StopWord.db")

preClean <- c("claim", "according", "wherein", "thereby", "therefore", "thereon", "said", 
              "may", "can", "also", "herein", "without", "onto", "will")
postClean <- c("one", "two", "first", "second", "least")

# Store all titles, claims, and abstracts in one place and separate by a whitespace.
# It pastes all elements of a vector together rather than pasting vectors together.
reviewText <- paste(rawdata$Title, rawdata$Abstract, rawdata$Claim, collapse = " ")
# Set up a text source
reviewSource <- VectorSource(reviewText)
# Create a corpus from the source
corpus <- Corpus(reviewSource)
# Transform all letters in the corpus to lower case
corpus <- tm_map(corpus, content_transformer(tolower))
# Remove numbers
corpus <- tm_map(corpus, removeNumbers)
# Remove all punctuations in the corpus
corpus <- tm_map(corpus, removePunctuation)
# Strip extra whitespace from the corpus
corpus <- tm_map(corpus, stripWhitespace)
# Remove English stopwords from the corpus.  
# Stopwords are common words we may not be interested in.
corpus <- tm_map(corpus, removeWords, stopwords("english"))
# Remove our own defined words
corpus <- tm_map(corpus, removeWords, ourWords)

# Stem corpus and complete the stemmed words
#dictCorpus <- corpus
#corpus <- tm_map(corpus, stemDocument)
#corpus <- tm_map(corpus, stemCompletion, dictionary = dictCorpus)

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))

# Create a document-term matrix stored in sparse matrix telling 
# how frequently each term appears in corpus.
dtm <- TermDocumentMatrix(corpus, control = list(tokenize = BigramTokenizer))
# Convert the document-term matrix into a normal matrix which is easier 
# to work with, and take the column sums of the matrix, which gives a named vector.
freq <- rowSums(as.matrix(dtm))
# Sort this vector to see the most frequently used words
freq <- sort(freq, decreasing = TRUE)
# Remove "said" from word frequency table
# freq <- freq[!names(freq) %in% "said"]
# Create a data frame to dump data
output <- data.frame(names(freq), freq)
# Write data out in xlsx format
write.xlsx(output, "output.xlsx")
# Plot the top 100 words in cloud
wordcloud(names(freq)[1:100], freq[1:100], colors = brewer.pal(6, "Dark2"))
