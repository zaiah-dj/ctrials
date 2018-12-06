# ctrials 

This project is a stripped down, open-source implementation of an app I wrote to handle clinical trials.


## Table of Contents

- Setup
	- Running Locally
	- Linux
	- OSX
	- Windows
- General Usage
	- 
- Developer Usage
	- 

## Setup 

### Running Locally

(Right now) you will need:

- SQL Server (Runs on Linux, OSX and Windows)
- Git Bash (or some other Unix-compatible shell)
- GNU Make


#### Linux

Running most any Linux, both SQL server and ColdFusion (or Lucee) are available for download.

Download [Lucee](http://lucee.org) 
Download [Microsoft SQL Server 2017](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)

Note: Ubuntu, CentOS, Fedora, and RHEL are among the few distros that ship with an actual package to help install SQL server.  Arch Linux and other more exotic distributions will need some work.   See this document on how to get SQL Server running on Arch Linux.



#### Mac OSX

Unfortunately for Mac OSX users, SQL server does not yet have a package.  To make matters worse, the scripts that ship for setting up SQL server on Linux aren't quite fully compatible with OSX, due to a number of small differences.  Using a Docker container will probably be your simplest solution.

In a future version, this app will be running on MySQL to further isolate closed-source dependencies.


#### Windows

The only real way to get this app running on Windows is via Cygwin.  I have not had the time to make those changes yet. 

