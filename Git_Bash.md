## Table of Content
- [Sources](#souces)
- [General Information](#general-info)
- [Commands Summary](#commands)

<a name="souces" />

## Sources
- OU Software Carpentry Workshop
  - [Main Tutorial](https://oulib-swc.github.io/2019-05-15-ou-swc/)
  - [Git Tutorial](https://swcarpentry.github.io/git-novice/)
  - [Etherpad](https://pad.carpentries.org/2019-05-15-ou-swc)
  - [Google Doc](https://docs.google.com/document/d/1aJq_X1uhaNkUj7qdZEzOcpc2Pky7eZPy76yqs0UkfrQ/edit)

<a name="general-info" />

## General Information

- Can create alias for the commoands
- [pandoc.org](https://pandoc.org/) ... convert markdown files into different formats
- **Git Bach** on Windows ... give the standard Unix IEEE commands 
- **Ubuntu Terminal** ... install on Windows to give unix environment
- **doulbe dashes** if the flag is more than on character

<a name="commands" />

## Commands Summary

Basics
```
history
clear
```
Listing
```
ls -l		# -1 is called a switch or flag
ls --help	# to go to the manual 
```

Moving around
```
cd		# go to home
cd - 		# get back to where I were
```

Removing & Renaming
```
mv <file> <dir>		# move or rename
mv <name 1> <name 2>	# renaming

rm <file>		# remove files forever!!!
rmdir <dir>		# remove empty directory
```
Dangrous Command - Wipe Whole Drive
```
rm -rf */	# remove -[r]ecursive -[f]orce (don't ask me)
```

Copying
```
cp
```

Display Content & Information
```
cat <file>		# concatenate the whole file to the screen
less <file>		# pagnation, q to quite

wc <file>		# file content info
wc <file> -l		# number of lines

wc <file> -1 > <fileL>		# store to file
sort <fileL>			# alphanumeric
sort -n <fileL>			# numerically

head -n 1 <file>		# 1st line
tail -n 2 <file>		# last 2 lines
```

Piping
```
| 	# pipe command
sort -n <fileL> | head -n 1	# don't hand me the output, send it to head command
```

Wildcard
```
ls *[AB].txt		# any file ending with A or B
ls *[!AB].txt		# anyh file not ending with A or B
```

Loops
```
for thing in list_of_things
do 
	operation_using $thing		# notice $thing
done
```

Bash Script
```
# Select lines from the middle of a file
# Usage: bash middle.sh filename end_line num_line
head -n "$2" "$1" | tail -n "$3"
```

Echoing
```
echo					# print on screen

echo "bla bla bla" > file.txt		# print to file, if content exist earse
echo "bla 2" >> file.txt		# append to file
```

Running Scipts
```
$ bash file.sh
```

Edit Files using Editor called Nano
```
nano file.txt
```

Create new empty file
```
touch file.txt
```

Script to save list of Excel files in the current directory along with their sizes (in bytes) and modification dates.  Copy and paste the code into a text file and name it ```ListAllExcelFiles.sh```.  When ready to run the file, lauch the Git Bash Terminal and type ```Bash ListAllExcelFiles.sh```
```
#!/usr/bin/env bash

echo "" > out.txt
printf "Processing"
for file in *.xlsm;
do
	printf "$file\t" >> out.txt
	stat --printf="%s\t" "$file" >> out.txt
	stat --printf="%y\n" "$file" | cut -d ' ' -f1 >> out.txt
	printf "."
done;
```
