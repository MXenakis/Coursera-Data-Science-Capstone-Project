## Author: Michail Xenakis
library(shiny)
library(tm)
source("PredictionModelling.R")

shinyServer(
        function(input, output) {
                output$prediction <- renderText({WordPrediction(input$inputText)})
        }
)