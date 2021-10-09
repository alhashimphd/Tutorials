---
title: "Understanding Sherlock Holmes Short Stories"
author: "Amin G Alhashim"
date: "10/8/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(cache = TRUE, cache.lazy = TRUE, warning = FALSE,
                      message = FALSE, echo = TRUE, dpi = 180,
                      fig.width = 8, fig.height = 5)
```
# Introduction
This a practice of topic modeling based on Julia Silge's YouTube video [Topic modeling with R and tidy data principles](https://www.youtube.com/watch?v=evTuL-RcRpc&t=321s)


# Data Download & Prep
```{r}
library(gutenbergr)  # to download Sherlock Holmes stories
library(dplyr)
library(tidyr)
library(stringr)
library(tidytext)

# Download stories
sherlock_raw <- gutenbergr::gutenberg_download(1661)

# Remove first 28 rows
sherlock_raw <- sherlock_raw[-(1:28),]

# Determining start of each story
sherlock <- sherlock_raw %>% 
  # detect chapter start
  mutate(story = ifelse(str_detect(text, "^[MDCLXVI]+[.]"), text, NA)) %>%
  # remove lines without header
  filter(nchar(story) > 5 | is.na(story)) %>% 
  # fill down the chapter namem 
  fill(story) %>%
  # convert to factor
  mutate(story = factor(story, levels = unique(story)))

# Put in in tidytext dataframe
tidy_sherlock <- sherlock %>% 
  mutate(line = row_number()) %>% 
  # break the text column into tokens, create new column, and place the token into
  unnest_tokens(word, text) %>% 
  # remove stopwords
  anti_join(stop_words) %>% 
  # remove holmes that might affect our topic models
  filter(word != "holmes")

```


# Explore tf-idf
- To see which words are important in each story, i.e.,the words that appears many times in that story but few or none in the other stories.
- tf-idf is a great exploratory tool before starting with topic modeling
```{r}
library(ggplot2)

tidy_sherlock %>% 
  # count number of occurance of words in stories
  count(story, word, sort = TRUE) %>% 
  # compute and add tf, idf, and tf_idf values for words
  bind_tf_idf(word, story, n) %>% 
  # group by story
  group_by(story) %>% 
  # take top 10 words of each story with higest tf_idf (last column)
  top_n(10) %>% 
  # unpack
  ungroup() %>% 
  # turn words into factors and order them based on their tf_idf values
  # NOTE: This will not affect order the dataframe rows which is can be
  #   done via the arrange function
  # NOTE: Recording the word column this way is for ggplot to visualize them
  #   as desired from top tf_idf to lowest
  mutate(word = reorder(word, tf_idf)) %>% 
  ggplot(aes(word, tf_idf, fill = story)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~story, scales = "free", ncol = 3) +
  theme(strip.text.x = element_text(size = 5)) +
  coord_flip()
```


# Implement Topic Modeling
Training the model for the topics
```{r}
library(stm)        # for do topic modeling
library(quanteda)   # great text mining, will be used to structure the input
                    #   to stm

# Convert from tidy form to quanteda form (document x term matrix)
sherlock_stm <- tidy_sherlock %>% 
  count(story, word, sort = TRUE) %>% 
  cast_dfm(story, word, n)

# Train the model
topic_model <- stm(sherlock_stm, K = 6, init.type = "Spectral")
summary(topic_model)
```


# Contribution of Words in Topics
Looking at which words contribute the most in each topic.
```{r}
# Extracting betas and putting them in a tidy format
tm_beta <- tidy(topic_model)

# Visualizing the top words contributing to each topic
tm_beta %>% 
  group_by(topic) %>% 
  # top 10 word in each topic with higest beta (last column)
  top_n(10) %>% 
  ungroup() %>% 
  # turn words into factors and order them based on their tf_idf values
  # NOTE: This will not affect order the dataframe rows which is can be
  #   done via the arrange function
  # NOTE: Recording the word column this way is for ggplot to visualize them
  #   as desired from top tf_idf to lowest
  mutate(term = reorder(term, beta)) %>% 
  ggplot(aes(term, beta, fill = topic)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scales = "free", ncol = 3) +
  coord_flip()
```


# Distribution of Topics in Stories
Looking at how the stories are associated with each topic and how strong each association is.
```{r}
# Extracting gammas and putting them in a tidy format
tm_gamma <- tidy(topic_model, matrix = "gamma",
                 # use the names of the stories instead of the default numbers
                 document_names = rownames(sherlock_stm))


# Visualizing the number of stories belonging to each topics and the confidence
#   of the belonging
tm_gamma %>% 
  ggplot(aes(gamma, fill = as.factor(topic))) +
  geom_histogram(show.legend = FALSE) +
  facet_wrap(~topic, ncol = 3)


# Visualizing how much each topic appear in each story
tm_gamma %>% 
  ggplot(aes(topic, gamma, fill = document)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~document, scales = "free", ncol = 3) +
  theme(strip.text.x = element_text(size = 5))
```
The model did an excellent job strongly associating the stories into one or more topics.  This perfect association is rare in the world of topic modeling.  The reason behind this perfect association here could be due to the small number of documents that we have.
