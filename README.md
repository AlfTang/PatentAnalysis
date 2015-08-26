# PatentAnalysis
Several tools may be useful for patent analysis as follows:

1. Assignee -- Filter patents by specific assignees, which may have different names.

2. IPC_Analyser -- Sort 4th level IPC in data pool from most frequent one to the least.

3. Keyword-Filter -- Filter patents where keyword existing in title, claim, or abstract.  The occurrence of keyword in these fields and total occurrence are counted.

4. WordFrequency-Shiny -- A shiny app for making word frequency.  Users can: 
     *Upload their own data in csv format
     *Choose columns they want to display/analyse
     *Search keyword in entire dataset, or search different keywords in different column
     *The clicked cell will be rendered on top for reading
     *Make word frequency table, and choose n-gram model
     *Download data, WYSIWYG
     *Produce histogram on top 30 frequent words
     *Produce wordcloud

5. WordFrequency-standalone -- Make a word frequency table from provided corpus.
