

## Sources
- OU Software Carpentry Workshop
  - [Main Tutorial](https://oulib-swc.github.io/2019-05-15-ou-swc/)
  - [R Tutorial](https://datacarpentry.org/R-ecology-lesson/index.html)
  - [Ehterpad](https://pad.carpentries.org/2019-05-15-ou-swc)
  - [Google Doc](https://docs.google.com/document/d/1aJq_X1uhaNkUj7qdZEzOcpc2Pky7eZPy76yqs0UkfrQ/edit)

## General

- Creating a project instead of a file comes with the advantage of saving the workspace settings
- ```Ctrl+Enter``` to run the line of code

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

## Data Structure

- vector: hold single type of data
- list
- data frame: table where columns represent vectors
- factor
```
str(x)		# give the structure type of x
length(x)	# length of structure
```

## Basics

Assignment
```
x <- 3		# assing 3 to x
(x <- 3)	# assing 3 to x & print the result to console
```

Getting Help
```
args(round)		# bring the interface
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

## Files & Plots

Loading file from repository and saving it locally on disk.  It is always a good idea to structure your workspace.  See [Best Practices for Scientific Computing](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745) paper for more information.
```
download.file(url = “https://ndownloader.figshare.com/files/2292169”, destfile = “data/portal_data_joined.csv”)
```

Load file to R as data frame
```
surveys <- read.csv("data/portal_data_joined.csv")
```

Getting to know our data frame
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
surveys$sex		# column by name

```

