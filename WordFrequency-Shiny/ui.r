library(shiny)

shinyUI(navbarPage("NAIP Patent Analysis",

  tabPanel('Data Viewer',
    sidebarPanel(
      fileInput("inFile", "Choose datasheet to display"),
      uiOutput("choose_columns"),
      fluidRow(
        column(4, uiOutput("minWekaControl")),
        column(5, uiOutput("maxWekaControl"))
      ),
      uiOutput("buttonWF"),
      br(),
      uiOutput("buttonDownload")
    ),
    mainPanel(
      #uiOutput("text"),
      verbatimTextOutput("text"),
      DT::dataTableOutput("data_table")
    )
  ),
  tabPanel('Word Frequency', 
    sidebarPanel(
      DT::dataTableOutput("wfTable"),
      uiOutput("buttonDownloadWF")
    ),
    mainPanel(
      plotOutput("histWF"),
      plotOutput("wordCloud")
    )
  ),
  tabPanel('Life Cycle'),
  inverse = TRUE
))
