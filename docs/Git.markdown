# General Information*
- Git Hub is a good tool to issue releases (versions of our code) when doing 
  reseach so people can have access a specific version of the code that was 
  used at the time of wirting the paper.  This is done via what is called 
  DOI (Digital Object Identifier) which is a unique number given to a piece 
  of code, document, etc.

- GitHub is for collaboration.  Others: GitBucket, GitLab
- Books: Pro Git

# ==============================================================================
# Essintial Commands - Local Version Control
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

git config --global user.name "Amin G. Alhashim"
git config --global user.email "<email used for GitHub>"

# To avoid flaging changes that are raised from using different OSs
git config --global core.autocrlf true

# to see list of configration settings
git config --list

# give nano a writing permession
git config --global core.editor "nano -w"

# to get help
git config --help

# initializing git to start tracking directory
git init

# to check if git created neccessary file.  We should set a hidden folder
# called git
ls -a

# asking git about our current repository.  it is like saying whatsup!
git status

# git will keep track of files in the master directory ==> we don't need to 
# init git in each sub directory.
# However, git will not keep track of empty folders

# start tracking a file.  It is useful when working on multiple files and 
# want only to track one of them
git add <file name>

# create a version (commit in git language) with a message
git commit -m "write a nice message to remember what this version is all about"

# to see information about all the versions (committs)
git log

# to see what is the difference b/w the current status of my files and the 
# last commit
# nothing will be shown if a commit just has been issued
git diff

# and if the file staged we need the option to see the difference b/w the 
# staged files and the last commit
git diff --staged

# compare to latest commit/version
git diff HEAD <file name>

# compare to 2 commit back
git diff HEAD~2 <file name>

# compare staged to 1 commit back
git diff --staged HEAD~1 <file name>

# show specific commit.  Use q to quite after seeing the commit
git show HEAD~1 <file name>

# remove file from stage if you discover that you are not ready to commit 
# the file
git reset <file name>

# restore a commit after discovering that the edits that you did is not good 
# but commits will not be lost.  Only the live version of the file will be 
# overritten
git checkout <HEAD | HEAD~2 | commit_num> <file name>

# to ignore some of the files that we don't git need to track into a 
# file called .gitignore
git .gitignore

# to add an ignored file to the stage
git add -f a.data

# to get information about the files that has been ignored
git status --ignored



# ==============================================================================
# Essintial Commands - Collaboration
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# link an online repositoy to our local reposity
git remote add origin <url>

# show me what is the remote repository
git remote -v

# push to origin the master
git push origin master

# pull from origion to master
git pull origin master

# Creat a copy of a repository from GitHub (use SSH instead of HTTPS b/c it 
# does not work form me.  
# See https://help.github.com/en/articles/testing-your-ssh-connection)
git clone <url>

git push origin master

# After pushing, go to GitHub and ask for a pull from the creator if 
# you think that your code is enhancing some features of the program