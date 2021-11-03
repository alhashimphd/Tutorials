Understanding Sherlock Holmes Short Stories
================
Amin G Alhashim
10/8/2021

# Introduction

This a practice of topic modeling based on Julia Silge’s YouTube video
[Topic modeling with R and tidy data
principles](https://www.youtube.com/watch?v=evTuL-RcRpc&t=321s)

# Data Download & Prep

``` r
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

-   To see which words are important in each story, i.e.,the words that
    appears many times in that story but few or none in the other
    stories.
-   tf-idf is a great exploratory tool before starting with topic
    modeling

``` r
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

![](main_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

# Implement Topic Modeling

Training the model for the topics

``` r
library(stm)        # for do topic modeling
library(quanteda)   # great text mining, will be used to structure the input
                    #   to stm

# Convert from tidy form to quanteda form (document x term matrix)
sherlock_stm <- tidy_sherlock %>% 
  count(story, word, sort = TRUE) %>% 
  cast_dfm(story, word, n)

# Train the model
topic_model <- stm(sherlock_stm, K = 6, init.type = "Spectral")
```

    ## Beginning Spectral Initialization 
    ##   Calculating the gram matrix...
    ##   Finding anchor words...
    ##      ......
    ##   Recovering initialization...
    ##      ..........................................................................
    ## Initialization complete.
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 1 (approx. per word bound = -7.753) 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 2 (approx. per word bound = -7.535, relative change = 2.817e-02) 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 3 (approx. per word bound = -7.439, relative change = 1.274e-02) 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 4 (approx. per word bound = -7.415, relative change = 3.114e-03) 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 5 (approx. per word bound = -7.406, relative change = 1.256e-03) 
    ## Topic 1: st, simon, lord, day, lady 
    ##  Topic 2: red, hat, sir, goose, stone 
    ##  Topic 3: street, matter, hosmer, door, woman 
    ##  Topic 4: father, mccarthy, time, son, hand 
    ##  Topic 5: miss, door, night, rucastle, light 
    ##  Topic 6: door, house, time, night, matter 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 6 (approx. per word bound = -7.402, relative change = 5.850e-04) 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Completing Iteration 7 (approx. per word bound = -7.401, relative change = 9.915e-05) 
    ## ............
    ## Completed E-Step (0 seconds). 
    ## Completed M-Step. 
    ## Model Converged

``` r
summary(topic_model)
```

    ## A topic model with 6 topics, 12 documents and a 7496 word dictionary.

    ## Topic 1 Top Words:
    ##       Highest Prob: st, simon, lord, day, lady, found, matter 
    ##       FREX: simon, clair, neville, lascar, opium, doran, pa 
    ##       Lift: aloysius, ceremony, doran, millar, pennies, _morning, 2_s_ 
    ##       Score: simon, st, clair, neville, frank, _danseuse_, lestrade 
    ## Topic 2 Top Words:
    ##       Highest Prob: red, hat, sir, goose, stone, time, business 
    ##       FREX: goose, geese, horner, ryder, henry, peterson, wilson 
    ##       Lift: _disjecta, _echo_, _evening, _globe_, _our_, _pall, _st 
    ##       Score: goose, geese, wilson, horner, bird, _disjecta, league 
    ## Topic 3 Top Words:
    ##       Highest Prob: street, matter, hosmer, woman, photograph, door, angel 
    ##       FREX: hosmer, angel, windibank, majesty, briony, photograph, king 
    ##       Lift: godfrey, leadenhall, mask, _affaire, _bijou_, _chronicle_, _dénouement_ 
    ##       Score: hosmer, angel, windibank, photograph, majesty, _affaire, adler 
    ## Topic 4 Top Words:
    ##       Highest Prob: father, mccarthy, time, son, lestrade, hand, left 
    ##       FREX: mccarthy, pool, boscombe, openshaw, pips, horsham, turner 
    ##       Lift: dundee, horsham, pondicherry, savannah, sundial, _lone, 1869 
    ##       Score: mccarthy, pool, lestrade, boscombe, openshaw, _métier_, turner 
    ## Topic 5 Top Words:
    ##       Highest Prob: miss, door, night, rucastle, light, house, lady 
    ##       FREX: rucastle, hunter, stoner, toller, roylott, ventilator, beeches 
    ##       Lift: fowler, inhabited, slit, terrified, winchester, accept, armitage 
    ##       Score: rucastle, hunter, stoner, toller, _can_, roylott, ventilator 
    ## Topic 6 Top Words:
    ##       Highest Prob: door, house, time, night, matter, coronet, morning 
    ##       FREX: coronet, arthur, gems, snow, hydraulic, colonel, holder 
    ##       Lift: fee, hastened, hydraulic, _en, 16a, 200, 4000 
    ##       Score: coronet, arthur, gems, 200, snow, colonel, holder

# Contribution of Words in Topics

Looking at which words contribute the most in each topic.

``` r
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

![](main_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# Distribution of Topics in Stories

Looking at how the stories are associated with each topic and how strong
each association is.

``` r
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
```

![](main_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
# Visualizing how much each topic appear in each story
tm_gamma %>% 
  ggplot(aes(topic, gamma, fill = document)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~document, scales = "free", ncol = 3) +
  theme(strip.text.x = element_text(size = 5))
```

![](main_files/figure-gfm/unnamed-chunk-5-2.png)<!-- --> The model did
an excellent job strongly associating the stories into one or more
topics. This perfect association is rare in the world of topic modeling.
The reason behind this perfect association here could be due to the
small number of documents that we have.
