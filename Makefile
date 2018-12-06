# Vars
PREFIX=

# Common utilities act differently on different boxes
SED=gsed
TAR=tar
DATE=gdate

# Type your credentials for MySQL here 
SQLBIN=mysql
DBSERVER="localhost"
DBUSER="root"
DBPASSWORD="toor"

# Type your credentials for SQL Server here
#SQLBIN=sqlcmd
#DBSERVER="localhost"
#DBUSER="SA"
#DBPASSWORD="GKbAt68!"

# Things that should never change
CONFIG=
DATABASE=ctrial_db
DATES= \
	'-3 weeks 1 day' \
	'-2 weeks 1 day' \
	'-2 weeks 4 day' \
	'-1 week 3 day' \
	'4 days ago' \
	'2 days ago' \
	'1 day ago' \
	'0' \
	'1 week 1 day' \
	'1 week 3 day' \
	'2 weeks 1 day' \
	'2 weeks 1 day' \
	'3 weeks 1 day'


# check - Check for the right dependencies and show valid options
check:
	@printf "Checking for sh...\n"
	@which sh >/dev/null 2>/dev/null || printf "sh not in path...\n"
	@which sh > /dev/null
	@printf "Checking for sqlcmd...\n"
	@which sqlcmd >/dev/null 2>/dev/null || printf "sqlcmd not in path...\n"
	@which sqlcmd > /dev/null
	@printf "Checking for sed...\n"
	@which sed >/dev/null 2>/dev/null || printf "sed not in path...\n"
	@which sed > /dev/null
	@printf "Available options are\n"
	@grep '^# [a-z]' Makefile | sed 's/^# //'
	@echo $(ACTIVE_DATE)


# changelog - Create a changelog
changelog:
	@echo "Creating / updating CHANGELOG document..."
	@touch CHANGELOG


# change - Notate a change (Target should work on all *nix and BSD)
change:
	@test -f CHANGELOG || printf "No changelog exists.  Use 'make changelog' first.\n\n"
	@test -f CHANGELOG
	@echo "Press [Ctrl-D] to save this file."
	@cat > CHANGELOG.USER
	@date > CHANGELOG.ACTIVE
	@sed 's/^/\t - /' CHANGELOG.USER >> CHANGELOG.ACTIVE
	@printf "\n" >> CHANGELOG.ACTIVE
	@cat CHANGELOG.ACTIVE CHANGELOG > CHANGELOG.NEW
	@rm CHANGELOG.ACTIVE CHANGELOG.USER
	@mv CHANGELOG.NEW CHANGELOG


# pkg - Package
pkg:
	tar chzf ../iv.`date +%F-%H-%m-%s`.tgz --exclude=./Application.cfc ./*


# dbprep - Prepare the files to be loaded into database
dbprep:	
	@cp setup/schema.sql setup/schema.sql.tmp
	@sed "{ \
		s/DATE_0/$$($(DATE) --date='-3 weeks 1 day' +%F)/; \
		s/DATE_1/$$($(DATE) --date='-2 weeks 1 day' +%F)/; \
		s/DATE_2/$$($(DATE) --date='-2 weeks 4 day' +%F)/; \
		s/DATE_3/$$($(DATE) --date='-1 week 3 day' +%F)/; \
		s/DATE_4/$$($(DATE) --date='4 days ago' +%F)/; \
		s/DATE_5/$$($(DATE) --date='2 days ago' +%F)/; \
		s/DATE_6/$$($(DATE) --date='1 day ago' +%F)/; \
		s/DATE_7/$$($(DATE) --date='0' +%F)/; \
		s/DATE_8/$$($(DATE) --date='2 weeks 1 day' +%F)/; \
		s/DATE_9/$$($(DATE) --date='2 weeks 1 day' +%F)/; \
		s/DAYOFWK_0/$$($(DATE) --date='-3 weeks 1 day' +%w)/g; \
		s/DAYOFWK_1/$$($(DATE) --date='-2 weeks 1 day' +%w)/g; \
		s/DAYOFWK_2/$$($(DATE) --date='-2 weeks 4 day' +%w)/g; \
		s/DAYOFWK_3/$$($(DATE) --date='-1 week 3 day' +%w)/g; \
		s/DAYOFWK_4/$$($(DATE) --date='4 days ago' +%w)/g; \
		s/DAYOFWK_5/$$($(DATE) --date='2 days ago' +%w)/g; \
		s/DAYOFWK_6/$$($(DATE) --date='1 day ago' +%w)/g; \
		s/DAYOFWK_7/$$($(DATE) --date='0' +%w)/g; \
		s/DAYOFWK_8/$$($(DATE) --date='2 weeks 1 day' +%w)/g; \
		s/DAYOFWK_9/$$($(DATE) --date='2 weeks 1 day' +%w)/g; \
	}" setup/populate.sql > setup/populate.sql.tmp


# dbload - Load up the database
dbload_mssql:	dbprep
dbload_mssql:	
	$(SQLBIN) -S $(DBSERVER) -i setup/schema.sql.tmp -U $(DBUSER) -P $(DBPASSWORD)
	$(SQLBIN) -S $(DBSERVER) -i setup/populate.sql.tmp -U $(DBUSER) -P $(DBPASSWORD)


# MySQL database load commands
dbload_mysql:	dbprep
dbload_mysql:	
	$(SQLBIN) -u $(DBUSER) --password=$(DBPASSWORD) < setup/schema.sql.tmp
	$(SQLBIN) -u $(DBUSER) --password=$(DBPASSWORD) < setup/populate.sql.tmp


# A command to keep things consistent
dbload: dbprep
dbload: dbload_mysql
dbload:
	@printf '' > /dev/null 


# clean - Clean up any new files
clean: 
	rm setup/{schema,populate}.sql.tmp	


# gitlog - Generate a full changelog from the commit history
gitlog:
	@printf "# CHANGELOG\n\n"
	@printf "## STATS\n\n"
	@printf -- "- Commit count: "
	@git log --full-history --author=Antonio --oneline | wc -l
	@printf -- "- Project Inception "
	@git log --full-history --author=Antonio | grep Date: | tail -n 1
	@printf -- "- Last Commit "
	@git log -n 1 | grep Date:
	@printf -- "- Authors:\n"
	@git log --full-history --author=Antonio | grep Author: | sort | uniq | sed '{ s/Author: //; s/^/\t- /; }'
	@printf "\n"
	@printf "## HISTORY\n\n"
	@git log --full-history --author=Antonio | sed '{ s/^   /- /; }'
	@printf "\n<link rel=stylesheet href=changelog.css>\n"


# lucee - Test on Lucee
lucee:
	make gitlog > changelog.md
	-rsync -arvz --delete --exclude=Application.cfc --exclude=.git --exclude=.gitignore --exclude=.*.swp --exclude=*.tgz /cygdrive/c/ColdFusion2016/cfusion/wwwroot/motrpac/web/secure/dataentry/iv/ /cygdrive/c/lucee/tomcat/webapps/motrpac/web/secure/dataentry/iv/
	rm changelog.md
	

# pull from lucee
pulllucee:
	-rsync -arvz --delete --exclude=Application.cfc --exclude=.git --exclude=.gitignore --exclude=.*.swp --exclude=*.tgz /cygdrive/c/lucee/tomcat/webapps/motrpac/web/secure/dataentry/iv/ /cygdrive/c/ColdFusion2016/cfusion/wwwroot/motrpac/web/secure/dataentry/iv/
	

