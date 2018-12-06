ctrials 
=======

This project is a stripped down, open-source implementation of an app I wrote to handle clinical trials.


Table of Contents
-----------------

- Setup
	- Running Locally
	- Linux
	- OSX
	- Windows
- General Usage
	- Workflow
- Support / Help / Inquiries


Setup 
-----

### Running Locally

(Right now) you will need:

- SQL Server (Runs on Linux, OSX and Windows)
- Git Bash (or some other Unix-compatible shell)
- GNU Make


#### Linux

Running most any Linux, both SQL server and ColdFusion (or Lucee) are available for download.

- Download [Lucee](http://lucee.org) 
- Download [Microsoft SQL Server 2017](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) or [MySQL](https://www.mysql.com)

<i>Note: Ubuntu, CentOS, Fedora, and RHEL are among the few distros that ship
with an actual package to help install SQL server.  Arch Linux and other more
exotic distributions will need some work.   See this document on how to get SQL
Server running on Arch Linux.</i>

0. After installing and configuring Lucee, and a database backend, fire up a
command-line prompt.

0. Clone this repository into Lucee's webapps directory, and go into the 
directory titled 'ctrials'.  Running `make` by itself will yield a ton of 
different options as far as deploying the demo on your system.
	<pre>
	# My Lucee applications are located at /opt/lucee/tomcat/webapps
	$ cd /opt/lucee/tomcat/webapps
	$ git clone https://github.com/zaiah-dj/ctrials.git
	$ cd ctrials
	$ make
	</pre>

0. Now run the command `make` from your command-line, supplying your database's
username and password via environment variables by using make's -e flag.  Notice
that you must supply either 'mssql' or 'mysql' to initialize the demo with a
specific database backend.
	<pre>
	$ make -e DBUSER=yoosername DBPASSWORD=p4ssw0rd <db-backend>
	</pre>
	<i>Note: It should go without saying that you should NOT do this on any
	production machine.  The above commands should ONLY be run on your local 
	development box.  If you must run this demo on an internet-accessible
	machine, please edit the file titled 'auth.mk' to supply database
	credentials.</i>

0. Now, fire up a web browser and visit <a
href="http://localhost:8888/ctrials">http://localhost:8888/ctrials</a>.  Keep in
mind, that if you changed Lucee's default port for serving, you'll have to visit
that port instead.


#### Mac OSX

Unfortunately for Mac OSX users, SQL server does not yet have a package.  To make matters worse, the scripts that ship for setting up SQL server on Linux aren't quite fully compatible with OSX, due to a number of small differences.  Using a Docker container will probably be your simplest solution.

In a future version, this app will be running on MySQL to further isolate closed-source dependencies.


#### Windows

The only real way to get this app running on Windows is via Cygwin.  I have not had the time to make those changes yet. 



General Usage
-------------

### Workflow

0. To get started, just drag a patient name from the left to the right.  

0. After you've selected who you want for the day, hit 'Done!'.

0. Open a new patient by clicking on their name.

0. The original intention was to have nurses check patient data on the first
screen.

0. Next, by clicking on the middle tab titled either 'Endurance Data' or
'Resistance Data', they could put in their patient's data for the day's
exercises.



Support / Help / Inquiries
--------------------------
For help or questions concerning other work of mine, please contact me at one of
the following addresses:
- <a href="mailto:ramar.collins@gmail.com">ramar.collins@gmail.com</a>
- <a href="mailto:rc@tubularmodular.com">rc@tubularmodular.com</a>



