## Table of Content
- [Sources](#souces)
- [General Information](#general-info)
- [Essintial Commands - Local Version Control](#local)
- [Essintial Commands - Collaboration](#collaboration)


<a name="souces" />

## Sources
- OU Software Carpentry Workshop
  - [Main Tutorial](https://oulib-swc.github.io/2019-05-15-ou-swc/)
  - [Git Bash Tutorial](http://swcarpentry.github.io/shell-novice/reference/)
  - [Etherpad](https://pad.carpentries.org/2019-05-15-ou-swc)
  - [Google Doc](https://docs.google.com/document/d/1aJq_X1uhaNkUj7qdZEzOcpc2Pky7eZPy76yqs0UkfrQ/edit)

<a name="general-info" />

## General Information
- Git Hub is a good tool to issue releases (versions of our code) when doing  reseach so people can have access a specific version of the code that was used at the time of wirting the paper.  This is done via what is called DOI (Digital Object Identifier) which is a unique number given to a piece of code, document, etc.
- GitHub is for collaboration.  Others: GitBucket, GitLab
- Books: Pro Git

<a name="local" />

## Essintial Commands - Local Version Control
Configuring git for first time
```
git config --global user.name "Amin G. Alhashim"
git config --global user.email "<email used for GitHub>"
```

To avoid flaging changes that are raised from using different OSs
```
git config --global core.autocrlf true
```

To see list of configration settings
```
git config --list
```

Give nano a writing permession
```
git config --global core.editor "nano -w"
```

To get help
```
git config --help
```

Initializing git to start tracking directory
```
git init
```

To check if git created neccessary file.  We should set a hidden folder called git
```
ls -a
```

Asking git about our current repository.  it is like saying whatsup!
```
git status
```

Git will keep track of files in the master directory ==> we don't need to init git in each sub directory.  **However**, git will not keep track of empty folders

Start tracking a file.  It is useful when working on multiple files and want only to track one of them
```
git add <file name>
```

Create a version (commit in git language) with a message
```
git commit -m "write a nice message to remember what this version is all about"
```

To see information about all the versions (committs)
```
git log
```

To see what is the difference b/w the current status of my files and the last commit nothing will be shown if a commit just has been issued
```
git diff
```

And if the file staged we need the option to see the difference b/w the staged files and the last commit
```
git diff --staged
```

Compare to latest commit/version
```
git diff HEAD <file name>
```

Compare to 2 commit back
```
git diff HEAD~2 <file name>
```

Compare staged to 1 commit back
```
git diff --staged HEAD~1 <file name>
```

Show specific commit.  Use q to quite after seeing the commit
```
git show HEAD~1 <file name>
```

Remove file from stage if you discover that you are not ready to commit the file
```
git reset <file name>
```

Restore a commit after discovering that the edits that you did is not good but commits will not be lost.  Only the live version of the file will be overritten
```
git checkout <HEAD | HEAD~2 | commit_num> <file name>
```

To ignore some of the files that we don't git need to track into a file called .gitignore
```
git .gitignore
```

To add an ignored file to the stage
```
git add -f a.data
```

To get information about the files that has been ignored
```
git status --ignored
```

<a name="collaboration" />

## Essintial Commands - Collaboration

Link an online repositoy to our local reposity
```
git remote add origin <url>
```

Show me what is the remote repository
```
git remote -v
```

Push to origin the master
```
git push origin master
```

Pull from origion to master
```
git pull origin master
```

Creat a copy of a repository from GitHub (use SSH instead of HTTPS b/c it does not work form me.  See https://help.github.com/en/articles/testing-your-ssh-connection)
```
git clone <url>
```

Push from local to GitHub cloud
```
git push origin master
```

After pushing, go to GitHub and ask for a pull from the creator if you think that your code is enhancing some features of the program

Removing & renaming files can be done withing git to avoid the staging step
```
git rm <file name>
git mv <old file name> <nenw file name>
git mv <file> <different directory>
```