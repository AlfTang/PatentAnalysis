library(shiny)
library(stringr)
library(DT)
library(wordcloud) # Load package to produce word clouds
source("~/shiny test/data viewer/wordFrequency.R")
source("~/shiny test/data viewer/histWF.R")

shinyServer(function(input, output) {
  # "choose_columns": Check boxes
  output$choose_columns <- renderUI({
    # If missing input, return to avoid error later in function
    if (is.null(input$inFile))
      return()
    # Get the data set with the appropriate name
    inputFile <- input$inFile
    dat <- read.csv(inputFile$datapath, nrows = 10)
    colnames <- names(dat)
    # Create the checkboxes and select them all by default
    checkboxGroupInput("columns", "Choose columns", choices = colnames, selected = colnames)
  })
  
  output$buttonWF <- renderUI({
    if (!is.null(input$inFile))
      actionButton("doWF", label = "Get Word Frequency")
  })
  
  output$buttonDownload <- renderUI({
    if (!is.null(input$inFile))
      downloadButton('downloadData', 'Download')
  })
  
  output$minWekaControl <- renderUI({
    if (!is.null(input$inFile))
      textInput('minWeka', 'Min Frequency', value = "1")
  })
  
  output$maxWekaControl <- renderUI({
    if (!is.null(input$inFile))
      textInput('maxWeka', 'Max Frequency', value = "2")
  })
  
  output$downloadData <- downloadHandler(
    filename = "untitled.csv",
    content = function(file) {
      outputFile <-
        read.csv(input$inFile$datapath, stringsAsFactors = FALSE)
      outputFile <- outputFile[, input$columns, drop = FALSE]
      write.csv(outputFile, file, row.names = FALSE)
    }
  )
  
  # "data_table": Output the data
  output$data_table <- DT::renderDataTable({
    # If missing input, return to avoid error later in function
    if (is.null(input$inFile))
      return()
    inputFile <- input$inFile
    # Get the data set
    dat <-
      read.csv(inputFile$datapath, stringsAsFactors = FALSE)
    # Make sure columns are correct for data set (when data set changes, the
    # columns will initially be for the previous data set)
    if (is.null(input$columns) ||
        !(input$columns %in% names(dat)))
      return()
    # Keep the selected columns
    dat <- dat[, input$columns, drop = FALSE]
  },
  options = list(columnDefs = list(list(
    targets = "_all",
    render = JS(
      "function(data, type, row, meta) {",
      "return type === 'display' && data.length > 30 ?",
      "'<span title=\"' + data + '\">' + data.substr(0, 30) + '...</span>' : data;",
      "}"
    )
  )),
  searchHighlight = TRUE),
  filter = "top",
  selection = list(mode = "single", target = "cell"))
  # Render the content in selected cell
  output$text = renderText({
    input$data_table_cell_clicked$value
    #gsub(input$data_table_search, paste("<strong>", input$data_table_search, "</strong>"), input$data_table_cell_clicked$value)
  })
  #tags$head(tags$style("#text1{color: red;
  #                             font-size: 20px;
  #                     font-style: italic;
  #                           }"
  #                     ))
  
  observeEvent(input$doWF, {
    wf <-
      wordFrequency(input$inFile$datapath, input$columns, input$minWeka, input$maxWeka)
    output$wfTable <- DT::renderDataTable({
      wf
    })
    output$histWF <- renderPlot({
      wf[1:30,]    %>%
        ggplot(aes(word, freq)) +
        geom_bar(stat = "identity", fill = "darkred", colour = "darkgreen") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
    output$wordCloud <- renderPlot({
      wordcloud(wf$word[1:100], wf$freq[1:100], colors = brewer.pal(6, "Dark2"))
    })
    
    output$buttonDownloadWF <- renderUI({
      if (!is.null(input$inFile))
        downloadButton('downloadWF', 'Download')
    })
    
    output$downloadWF <- downloadHandler(
      filename = "untitled.csv",
      content = function(file) {
        write.csv(wf, file)
      }
    )
  })
})
