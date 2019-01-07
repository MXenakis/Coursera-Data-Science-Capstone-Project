## NGramsFreq.R
## Purpose of Script: Produce NGrams
## Author: Michail Xenakis

require(dplyr)
require(stringi)
require(tm)
require(RWeka)

## Read .txt files

blgCon <- file("final/en_US/en_US.blogs.txt", open = "r")
blg <- readLines(blgCon, encoding = "UTF-8", skipNul = TRUE)
close(blgCon)

nwsCon <- file("final/en_US/en_US.news.txt", open = "r")
nws <- readLines(nwsCon, encoding = "UTF-8", skipNul = TRUE)
close(nwsCon)

twterCon <- file("final/en_US/en_US.twitter.txt", open = "r")
twter <- readLines(twterCon, encoding = "UTF-8", skipNul = TRUE)
close(twterCon)

## Remove variables to clear memory space
rm(blgCon)
rm(nwsCon)
rm(twterCon)

## Sample the three .txt files (0.4% is approximately 17 thousand lines of text in total for all three files)
blgSample <- sample(blg, length(blg)*0.004)
nwsSample <- sample(nws, length(nws)*0.004)
twterSample <- sample(twter, length(twter)*0.004)
sampleText <- c(blgSample, nwsSample, twterSample)

## Remove variables to clear memory space
rm(blg)
rm(nws)
rm(twter)
rm(blgSample)
rm(nwsSample)
rm(twterSample)

## Clean the sampled text (convert to lower case, remove punctuation - white spaces - numbers - profanity words)
sampleTextcorpus <- VCorpus(VectorSource(sampleText))
sampleTextcorpus <- tm_map(sampleTextcorpus, content_transformer(tolower))
sampleTextcorpus <- tm_map(sampleTextcorpus, removePunctuation, preserve_intra_word_dashes = TRUE)
sampleTextcorpus <- tm_map(sampleTextcorpus, stripWhitespace)
sampleTextcorpus <- tm_map(sampleTextcorpus, removeNumbers)
sampleTextcorpus <- tm_map(sampleTextcorpus, removeWords, stopwords("english"))
badWordList <- VectorSource(readLines("final/en_US/full-list-of-bad-words_text-file_2018_07_30.txt"))
sampleTextcorpus <- tm_map(sampleTextcorpus, removeWords, badWordList)

## Remove variables to clear memory space
rm(badWordList)
rm(sampleText)

## Tokenization - 4 levels (Token1, Token2, Token3, Token4): 
## Unigrams, Bigrams, Trigrams, Tetragrams (gramN_1, gramN_2, gramN_3, gramN_4)

Token1 <- function(x){
        NGramTokenizer(x, control = Weka_control(min = 1, max = 1))}
Token2 <- function(x){
        NGramTokenizer(x, control = Weka_control(min = 2, max = 2))}
Token3 <- function(x){
        NGramTokenizer(x, control = Weka_control(min = 3, max = 3))}
Token4 <- function(x){
        NGramTokenizer(x, control = Weka_control(min = 4, max = 4))}

gramN_1 <- DocumentTermMatrix(sampleTextcorpus, control = list(tokenize = Token1))
gramN_2 <- DocumentTermMatrix(sampleTextcorpus, control = list(tokenize = Token2))
gramN_3 <- DocumentTermMatrix(sampleTextcorpus, control = list(tokenize = Token3))
gramN_4 <- DocumentTermMatrix(sampleTextcorpus, control = list(tokenize = Token4))

## Remove variables to clear memory space
rm(sampleTextcorpus)
rm(Token1)
rm(Token2)
rm(Token3)
rm(Token4)

## Calculate word frequencies for Unigrams, Bigrams, Trigrams, Tetragrams
gramN_1FR <- sort(colSums(as.matrix(gramN_1)),decreasing = TRUE)
gramN_1FRdata <- data.frame(word = names(gramN_1FR), frequency = gramN_1FR)
save(gramN_1FRdata,file="gramN_1.Rds")

## Remove variables to clear memory space
rm(gramN_1)
rm(gramN_1FR)
rm(gramN_1FRdata)

gramN_2FR <- sort(colSums(as.matrix(gramN_2)),decreasing = TRUE)
gramN_2FRdata <- data.frame(word = names(gramN_2FR), frequency = gramN_2FR)
save(gramN_2FRdata,file="gramN_2.Rds")

## Remove variables to clear memory space
rm(gramN_2)
rm(gramN_2FR)
rm(gramN_2FRdata)

gramN_3FR <- sort(colSums(as.matrix(gramN_3)),decreasing = TRUE)
gramN_3FRdata <- data.frame(word = names(gramN_3FR), frequency = gramN_3FR)
save(gramN_3FRdata,file="gramN_3.Rds")

## Remove variables to clear memory space
rm(gramN_3)
rm(gramN_3FR)
rm(gramN_3FRdata)

gramN_4FR <- sort(colSums(as.matrix(gramN_4)),decreasing = TRUE)
gramN_4FRdata <- data.frame(word = names(gramN_4FR), frequency = gramN_4FR)
save(gramN_4FRdata,file="gramN_4.Rds")

## Remove variables to clear memory space
rm(gramN_4)
rm(gramN_4FR)
rm(gramN_4FRdata)
