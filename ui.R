## Author: Michail Xenakis
library(shiny)

ui <- fluidPage(
        titlePanel("Simple Word Prediction Application"),
        h6("Developer: Michail Xenakis"),
        sidebarLayout(
                sidebarPanel(
                        h4("Word Predictor"),
                        h6("The application will predict the next word based on an N-Gram algorithm being deployed in a backoff mode."),
                        h1(" "),
                        h4("Guidance"),
                        h6("I.Type one or more words into the text box."),
                        h6("II. Upon the word(s) you have entered in the text box the algorithm will predict the next word."),
                        h6("III. You can add the predicted word to your text or put another word and submit the new - expanded - sentence again!")
                ),
                
                mainPanel(
                        textInput("inputText",label = h4("Enter your word(s) here:")),
                        submitButton('Submit'),
                        h4('Is this the next word? '),
                        verbatimTextOutput("prediction")
                        
                )
        ))