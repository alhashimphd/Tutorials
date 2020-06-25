# References ------------------------------------------------------------------
# > Read Excel files from R (http://www.milanor.net/blog/read-excel-files-from-r/)
# > Descriptive Statistics (https://www.statmethods.net/stats/descriptives.html)
# > htmlTable (https://cran.r-project.org/web/packages/htmlTable/vignettes/general.html)

library(xlsx)
library(tidyverse)
library(htmlTable)

# Read data -------------------------------------------------------------------
data <- xlsx::read.xlsx("data/PracticeSet-DrWu-v1.00.xlsx", 
                        sheetName = "PracticeSet")


# Study the data --------------------------------------------------------------
# class(data)
# typeof(data)
# dim(data)
# length(data)
# names(data)
# attributes(data)
# str(data)
# sapply(data, mode)
# sapply(data, class)
# summary(data)


# Clean/fix data --------------------------------------------------------------
# Code missing data in R format
data[data == '.'] <- NA
# sapply(data, mode)
# sapply(data, class)
# summary(data)

# Convert cancer to lowercase then to factor
data$cancer <- factor(tolower(data$cancer))
# sapply(data, mode)
# sapply(data, class)
# summary(data)

# Convert genders to lowercase then to factor
data$Gender <- factor(tolower(data$Gender))
# sapply(data, mode)
# sapply(data, class)
# summary(data)

# Convert size to numeric
data$Size <- as.numeric(as.character(data$Size))
# sapply(data, mode)
# sapply(data, class)
# summary(data)

# Descriptive statistics for size based onn cancer status ---------------------
exQ <- data %>% filter(data$cancer == "ex", !is.na(data$Size)) %>% 
  select(Size) %>% 
  pull(Size) %>% 
  quantile()

neverQ <- data %>% filter(data$cancer == "never", !is.na(data$Size)) %>% 
  select(Size) %>% 
  pull(Size) %>% 
  quantile()

q <- matrix(c(unname(exQ), unname(neverQ)), nrow = 2, ncol = length(exQ), byrow = TRUE)
rownames(q) <- c("ex", "never")
colnames(q) <- names(exQ)

spaces <- strrep("&nbsp;", 2)

htmlTable(txtRound(q, 2),
          header = paste(spaces, c(colnames(q)), spaces),
          
          rowlabel = paste("Level", spaces),
          rnames = rownames(q))

# Significance test -----------------------------------------------------------
t.test(data$Size[data$cancer == "ex"], data$Size[data$cancer == "never"])


# Visualize data --------------------------------------------------------------
plot <- data %>% filter(!is.na(data$cancer), !is.na(data$Size)) %>% 
  ggplot(aes(x=cancer, y=Size)) + 
  geom_boxplot()

plot + geom_boxplot()