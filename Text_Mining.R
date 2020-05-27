# Author:  Sebastian Brinkmann
#          Institute of Geography
#          Friedrich-Alexander-Universitaet Erlangen-Nuernberg
#          Erlangen, Germany
#                               
# e-mail: bastibrinkmann94@gmail.com
# Date:   27.05.2020
#
#
# Note: In this script I performed a simple Corpus Analysis of 58 news articles about the Belval Campus, Luxembourg.
#       Make sure, that you have the same document structure, if you use a different corpus (see GitHub readme)!

#### Data Wrangling ####

# Load packages, if not installed use "install.packages("packagename")"
library(tidytext)
library(dplyr)
library(SemNetCleaner)
library(lubridate)

# Function to read file and unnest lines to words
processFile = function(filepath) {
  # Parameters
  current_title <- ""
  current_date <- dmy("1.1.1900")
  line_count <- 1
  
  # Output
  output <- tibble(title = as.character(), line = as.double(), text = as.character(), date = Date())
  
  # Connect to file
  con <- file(filepath, "r")
  
  # Loop through every line of the text file
  while ( TRUE ) {
    
    # 1. Read new line
    this_line = readLines(con, n = 1)
    if (length(this_line) == 0) {
      break
    }
    
    # 2. Check if line is new article
    if (startsWith(this_line, "Title:")) {
      # Set current_title
      current_title <- this_line %>% 
        gsub("Title: ", "", .)
      
      # Set curent_title as text for this_line
      this_line <- current_title
      
      # Get date from next line
      current_date = readLines(con, n = 1) %>% 
        gsub("DATE: ", "", .) %>% 
        dmy()
      
      # Fill output-tibble
      output[line_count, ] <- tibble(current_title, line_count, this_line, current_date)
    } else { 
      # 4. Fill output-tibble
      output[line_count, ] <- tibble(current_title, line_count, this_line, current_date)
      
      # 5. Increment line_count
      line_count <- line_count + 1 
    }
  }
  # Close connection
  close(con)
  
  # Unnest lines to words and return
  output %>%
    unnest_tokens(word, text) %>% 
    return()
}

# Process file from path and remove stop words ()
belval_corpus <- processFile(file.path("Data", "google_news_lines.txt")) %>% 
  filter(!(word %in% c("title", "belval", "esch", "escher", "luxembourg", "alzette", "â", "de"))) %>% 
  anti_join(stop_words)

# Singularize words (eg. students -> student)
pr = txtProgressBar(min = 0, max = nrow(belval_corpus), initial = 0, style = 3)
for (this_word in 1:nrow(belval_corpus)) {
  belval_corpus[this_word, 4] <- singularize(belval_corpus[this_word, 4])
  setTxtProgressBar(pr, this_word)
}
# I manually singularized this word after exploring the data
belval_corpus[belval_corpus$word=="furnaces",4] <- "furnace"

# Tidy the data
tidy_belval_corpus <- belval_corpus %>%
  # I have removed these words after exploring the data 
  filter(!(word %in% c("wa", "ha", "bu"))) %>% 
  mutate(title = factor(title, levels = unique(title))) %>%
  mutate(year = lubridate::year(date))

# Since 2014 had very few articels, these were combined with 2015
tidy_belval_corpus[tidy_belval_corpus$year == 2014,5] <- 2015


#### Wordcloud ####
# Load packages
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

# Count of each word accros the total corpus
belval_corpus_count <- tidy_belval_corpus %>% 
  count(word, sort = TRUE)

# Plot Wordcloud with counts of words  
wordcloud(words = belval_corpus_count$word, freq = belval_corpus_count$n, min.freq = 1,
          max.words=200, random.order=F, rot.per=0.35, scale=c(3.5,0.25),
          colors=brewer.pal(6, "Dark2"))


#### Explore process over time ###
# Load packages
library(ggplot2)
library(ggthemes)
library(forcats)

# Plot number of articles per year
tidy_belval_corpus %>% 
  select(year, title) %>% 
  unique() %>% 
  count(year, title) %>% 
  group_by(year) %>% 
  summarise(n = sum(n)) %>%
  ggplot(aes(year, n)) + 
  geom_col(fill = "#69b3a2") + 
  scale_x_continuous(breaks = seq(2015, 2020, 1)) + 
  ylab("Number of Articles") +  
  ggthemes::theme_calc() + 
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(size = 17),
        axis.text = element_text(size = 12))


# Plot TF/IDF for each year. 
# I used the word counts of the complete corpus (all 58 articles) and calculated the tf_idf on the level of each article.
tidy_belval_corpus %>% 
  count(year, title, word, sort = TRUE) %>%
  bind_tf_idf(word, title, n) %>% 
  group_by(year) %>% 
  top_n(15) %>% 
  ungroup() %>% 
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(word, y=tf_idf, fill = year)) +
  geom_col(show.legend = FALSE) +
  labs(y = "Term Frequency - Inverse Document Frequency (TF-IDF)") +
  facet_wrap(~year, scales = "free") +
  coord_flip() +
  theme_bw() +
  theme(axis.title.y = element_blank())
