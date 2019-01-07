## PredictionModelling.R
## Purpose of Script: Predict the next word based on an input sentence
## Author: Michail Xenakis

#Load the necessary library
library(tm)

#Load the Unigram, Bigram, Trigram and Tetragram word datasets 

load("gramN_1.Rds")
load("gramN_2.Rds")
load("gramN_3.Rds")
load("gramN_4.Rds")

textFix <- function(text){
        text <- tolower(text)
        text <- removePunctuation(text)
        text <- removeNumbers(text)
        text <- stripWhitespace(text)
        splitted <- unlist(strsplit(text, " "))
        length <- length(splitted)
        if (length == 0){return(NULL)}
        #if there are more than three words keep only the last three words
        if(length > 3){text <- paste(splitted[length-2], splitted[length-1], splitted[length])}
        return(text)
}


NGram <- function(sentence, length){
        if(length == 1){NGramData <- gramN_2FRdata}
        if(length == 2){NGramData <- gramN_3FRdata}
        if(length == 3){NGramData <- gramN_4FRdata}
        for(i in 1:nrow(NGramData)){
                NGword <- unlist(strsplit(as.character(NGramData$word[i])," "))
                if(length == 1){NGsamelength <- NGword[1]}
                if(length == 2){NGsamelength <- paste(NGword[1], NGword[2])}
                if(length == 3){NGsamelength <- paste(NGword[1], NGword[2], NGword[3])}
                if(identical(sentence, NGsamelength)){return(NGword[length+1]); break}
        }
        
        return(NULL)
}

WordPrediction <- function(sentence){
        
        predictedWord <- NULL
        sentence <- textFix(sentence)
        if(is.null(sentence)){return("Please, write one or more words in the text box above...")}
        text <- unlist(strsplit(sentence," "))

        if(length(text) == 3){
             predictedWord <- NGram(sentence, 3)
             if(is.null(predictedWord)){
                     sentence <- c(text[length(text)-1], text[length(text)])
             }
        }
        if(length(text) == 2){
                predictedWord <- NGram(sentence, 2)
                if(is.null(predictedWord)){
                        sentence <- text[length(text)]
                }
        }
        if(length(text) == 1){
                predictedWord <- NGram(sentence, 1)
        }
        if(is.null(predictedWord)){
                predictedWord <- as.character(sample(gramN_1FRdata$word[1:10], 1))
        }
        
        return(predictedWord)
}


