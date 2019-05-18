## Table of Content
- [Sources](#souces)
- [General Information](#general-info)
- [Data Types](#dt)
- [Data Structure](#ds)
- [Basics](#bsics)
- [Files, Data Frames, & Plots](#data-frame)
- [Data Manipulation using ```dplyr``` and ```tidyr```](#data-man)
- [Visualization Using ```ggplot2```](#viz)

<a name="souces" />

## Sources
- OU Software Carpentry Workshop
  - [Main Tutorial](https://oulib-swc.github.io/2019-05-15-ou-swc/)
  - [R Tutorial](https://datacarpentry.org/R-ecology-lesson/index.html)
  - [Ehterpad](https://pad.carpentries.org/2019-05-15-ou-swc)
  - [Google Doc](https://docs.google.com/document/d/1aJq_X1uhaNkUj7qdZEzOcpc2Pky7eZPy76yqs0UkfrQ/edit)

<a name="general-info" />

## General Information

- Creating a project instead of a file comes with the advantage of saving the workspace settings
- ```Ctrl+Enter``` to run the line of code

<a name="dt" />

## Data Types

- character
- numeric
- logical
- raw
- imaginary numbers
```
class(x)	# give the data type of x
```

### Mixing Data Types

- character + numeric = character
- numeric + logical = numeric
- numeric + character + logical = character

<a name="ds" />

## Data Structure

- vector: hold single type of data
- list
- data frame: table where columns represent vectors
- factor
```
str(x)		# give the structure type of x
length(x)	# length of structure
```

<a name="basics" />

## Basics

Assignment
```
x <- 3		# assing 3 to x
(x <- 3)	# assing 3 to x & print the result to console
```

Getting Help
```
args(round)	# bring the interface
?round		# bring the help file
```

Dealing with Structure
```
# concatenate set of values to create vector
weight_g <- c(50, 60, 3, 9)

# utalizing logical values to pull specific values
weight_g[weight_g < 10 & weight_g > 60 | weight_g == 50]

# pull dog & cat records
animals[animals %in% c("dog", "cat")]
animals[animals == "dog" | animals == "cat"]
```

Statistics
```
# signaling missing daa using NA
heights <- c(2, 3, NA, 4)

# get mean while ignoring missing data
mean(heights, na.rm = TRUE)

# how to use mean
?mean
```

<a name="data-frame" />

## Files, Data Frames, & Plots

Loading file from repository and saving it locally on disk.  It is always a good idea to structure your workspace.  See [Best Practices for Scientific Computing](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745) paper for more information.
```
download.file(url = “https://ndownloader.figshare.com/files/2292169”, 
	destfile = “data/portal_data_joined.csv”)
```

Load file to R as data frame
```
surveys <- read.csv("data/portal_data_joined.csv")
```

Inspecting data frame
```
class(surveys)	# data type
str(surveys)	# structure
dim(surveys)	# dimension
nrow(surveys)
ncol(surveys)
summary(surveys)
```

Show first/last few objects/records/rows
```
head(surveys)
tail(surveys)
```

Retreive specific element/row/column
```
surveys[1,1]	# element[1,1]
surveys[1, ]	# row 1
surveys[ ,1]	# column 1
surveys$sex	# column by name

```

Dealing with factor (categorical) columns.  R convert columns that contain characters to factors by default.  Factors are treated as integer vectors.  By default, R sorts levels in alphabetical order.
```
levels(surveys$sex)
nlevels(surveys$sex)

# reorder factors (to get better plots)
surveys$sex_ordered <- factor(surveys$sex, level=c("F", "M", ""))
str(surveys$sex_ordered)
levels(surveys$sex_ordered)
nlevels(surveys$sex_ordered)
```

Ploting Histogram
```
plot(surveys$sex)
plos(surveys$sex_ordered)

# enhance the plot
levels(surveys$sex_ordered)[1] <- "Female"
levels(surveys$sex_ordered)[2] <- "Male"
plos(surveys$sex_ordered)
```

<a name="data-man" />

## Data Manipulation using ```dplyr``` and ```tidyr```

- ```tdlyr```
  - makes manipulation of data easier
  - built to work with data frames directly
  - can direclty work with data stored in an external database which give the advantage of onlying brining what we need to the memoery to work on without having to bring the whole DB
- ```tidyr```
  - allows to swiftly convert b/w different data formats for plotting & analysis in order to accomodate the different requirements by different functions
    - sometime we want one row per measurement
    - othertimes we want the data aggregated like when ploting

Before using ```tdlyr``` and ```tidyr```:

- Install ```tidyverse``` package: umberella-package that install several packages (tidyr, dplyr, ggplot2 tibble, magrittr, etc.)
- Load the package each session 

Load the package
```
library("tidyverse")
```

Load & inspect data
```
# notice the '-' instead of '.' of basic R
surveys <- read_csv("data/portal_data_joined.csv")

str(surveys)	# structure: tbl_df (tibble)
view(surveys)	# preview

# select columns
select(surveys, plot_id, species_id, weight)

# select all columns except ...
select(surveys, -sex)

# choose rows based on criteria
filter(surveys, year == 1995)
```

Piping: Sending the results of one function to another
```
# in multiple steps
survey_less5 <- filter(surveys, weigth < 5)
survey_sml <- select(survey_less5, species_id, sex, weight)

# in one long step
survey_sml <- select(filter(surveys, weigth < 5), species_id, sex, weight)

# using pipe %>% of magritter package.  Use Ctrl + Shift + M to add
survey_sml <- surveys %>%
	filter(weight < 5) %>%
	select(species_id, sex, weight)
```

Summary of groups of 1+ coluumn
```
# one factor
surveys %>%
	group_by(sex) %>%
	summarise(mean_weight = mean(weight, na.rm = TRUE))
	
# two factors
surveys %>%
	group_by(sex, species) %>%
	summarise(mean_weight = mean(weight, na.rm = TRUE))

surveys %>%
	group_by(species, sex) %>%
	summarise(mean_weight = mean(weight, na.rm = TRUE))

# to avoid using na.rm = FALSE each statistis
surveys %>%
	filter(!is.na(weight) %>%
	group_by(species, sex) %>%
	summarise(mean_weight = mean(weight), sd_weight = sd(weight), sd_count = n())

# arrange by mean weight
surveys %>%
	filter(!is.na(weight) %>%
	group_by(species, sex) %>%
	summarise(mean_weight = mean(weight), sd_weight = sd(weight), sd_count = n()) %>%
	arrange(mean_weight)

# in descending order
surveys %>%
	filter(!is.na(weight) %>%
	group_by(species, sex) %>%
	summarise(mean_weight = mean(weight), sd_weight = sd(weight), sd_count = n()) %>%
	arrange(desc(mean_weight))

# by count
	filter(!is.na(weight) %>%
	group_by(species, sex) %>%
	summarise(mean_weight = mean(weight), sd_weight = sd(weight), sd_count = n()) %>%
	arrange(count)
```

Count of a categorical column
```
surveys %>%
	count(sex)
```

Reshaping with gather & spreed
```
# prepare the needed data first
surveys_gw <- surveys %>%
	filter(!na.rm(weight)) %>%
	group_by(genus, plot_id) %>%
	summarize(mean_weight = mean(weight))

# creating a 2D table where each dimension represent a category
# the cell will represent a statistis
surveys_spread <- surveys_gw %>%
	spread(key = genus, value = mean_weight)
str(surveys_spread)
head(surveys_spread)

# bring spread back
surveys_gw <- surveys_spread %>%
	gather(key = genus, value = mean_weight, -plot_id)
str(surveys_gw)
head(surveys_gw)
```

Filtering
```
# Remove missing data
survey_complete <- surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length), !is.na(sex))

# Filter those that has sample greater than 50
species_counts <- survey_complete %>%
  count(species_id) %>%
  filter(n >= 50)

# filter only those in the indicated category
surveys_com <- surveys %>%
	filter(species_id %in% )
```

Saving to disk
```
write_cvs()
```

<a name="viz" />

## Visualization Using ```ggplot2```

- Help in making complex plots from data frames in simple steps
- ggplot graphhics are built step by step by adding new elements; this makes it flexible as well as customizable

Step 1: Bind the plot to specific data frame
```
surveys_plot <- ggplot(data = survey_complete, 
	mapping = aes(x = weight, y = hindfoot_length))

# Color for each group
surveys_plot <- ggplot(data = survey_complete, 
	mapping = aes(x = weight, y = hindfoot_length),
	color=species_id)
```

Step 2: Select the type of the plot

- scatter plot, dot plots, etc. > geom_point()
- boxplots > geom_boxplot()
- trend lines, time series, etc. > geom_line()

Scatter plot
```
surveys_plot + geom_point()

# add transparency
surveys_plot + geom_point(alpha = 0.1)

# color if not used in binding
surveys_plot + geom_point(alpah = 0.1, color = "black")

# add color if not used in binding
surveys_plot + geom_point(alpaa = 0.1, aes(color = species_id))

# make the color blend by introducing small ramdom variation in points locations
# used when having small datasets
surveys_plot + geom_jitter(alpah = 0.1)
```

Boxplot
```
surveys_plot <- ggplot(data = survey_complete, 
	mapping = aes(x = species_id, y = weight))

surveys_plot + geom_boxplot()

# show data
survey_plot + geom_boxplot(alpah = 0.5) + 
	geom_jitter(alpha = 0.1, color = "tomato")

# bring boxplot layer in front
survey_plot + geom_jitter(alpah = 0.1, color = "tomato")
	+ geom_boxplot(alpha = 0.7)
```

Time series data
```
# create appropriate dataset
yearly_count <- survey_complete %>%
	count(year, species_id)

surveys_plot <- ggplot(data = yearly_count, 
	mapping = aes(x = year, y = n))

survey_plot + geom_line()

# make it more meaningful by breaking it by category
survey_plot + geom_line(aes(group = species_id))

# make it more colorful
survey_plot + geom_line(aes(color = species_id))

# split into multiple plots
survey_plot + geom_line() + facet_wrap(~ species_id)

# split the line in each plot by sex
yearly_sex_counts <- survey_complete %>%
	count(year, species_id, sex)

surveys_plot <- ggplot(data = yearly_sex_counts, 
	mapping = aes(x = year, y = n))

surveys_plot + geom_line(aes(color = sex))
	+ facet_wrap(~ species_id)

# remove background
surveys_plot + geom_line(aes(color = sex))
	+ facet_wrap(~ species_id)
	+ theme_bw()
	+ theme(panel.grid = element_blank())
```