library(ggplot2) # Plot word frequencies.
histWF <- function(inputFile) {
  subset(inputFile, freq>250)    %>%
    ggplot(aes(word, freq)) +
    geom_bar(stat="identity", fill="darkred", colour="darkgreen") +
    theme(axis.text.x=element_text(angle=45, hjust=1))
}
