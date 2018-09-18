# Vars
PREFIX=
SQLCMD=sqlcmd
SED=sed
TAR=sed
#DBUSER="SA"
#DBPASSWORD="GKbAt68!"
DBUSER="arcollinUser"
DBPASSWORD="9mKZpaL9B3"
DBSERVER="SQLDEV.PHS.WFUBMC.EDU"
DATABASE=zProgrammer_AntonioCollins
CONFIG=
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


# I want at least 6 weeks, 3 from before today and 3 from after
# Additionally, this program cannot populate Sunday or Saturday 
# ------------------------------------------
# Mon, Tue, Thurs
# Mon, Tue, Wed
# Mon, Tue
# Tue, Thurs, Fri
# -
# Tue

#    Stuff i never used...
#    @grep '^[a-z].*:$$' Makefile | sed 's/^/\t/'

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
	@sed '{ s/DATABASE_NAME/$(DATABASE)/; }' setup/schema.sql > setup/schema.sql.tmp
	@sed "{ \
		s/DATABASE_NAME/$(DATABASE)/; \
		s/DATE_0/$$(date --date='-3 weeks 1 day' +%F)/; \
		s/DATE_1/$$(date --date='-2 weeks 1 day' +%F)/; \
		s/DATE_2/$$(date --date='-2 weeks 4 day' +%F)/; \
		s/DATE_3/$$(date --date='-1 week 3 day' +%F)/; \
		s/DATE_4/$$(date --date='4 days ago' +%F)/; \
		s/DATE_5/$$(date --date='2 days ago' +%F)/; \
		s/DATE_6/$$(date --date='1 day ago' +%F)/; \
		s/DATE_7/$$(date --date='0' +%F)/; \
		s/DATE_8/$$(date --date='2 weeks 1 day' +%F)/; \
		s/DATE_9/$$(date --date='2 weeks 1 day' +%F)/; \
		s/DAYOFWK_0/$$(date --date='-3 weeks 1 day' +%w)/g; \
		s/DAYOFWK_1/$$(date --date='-2 weeks 1 day' +%w)/g; \
		s/DAYOFWK_2/$$(date --date='-2 weeks 4 day' +%w)/g; \
		s/DAYOFWK_3/$$(date --date='-1 week 3 day' +%w)/g; \
		s/DAYOFWK_4/$$(date --date='4 days ago' +%w)/g; \
		s/DAYOFWK_5/$$(date --date='2 days ago' +%w)/g; \
		s/DAYOFWK_6/$$(date --date='1 day ago' +%w)/g; \
		s/DAYOFWK_7/$$(date --date='0' +%w)/g; \
		s/DAYOFWK_8/$$(date --date='2 weeks 1 day' +%w)/g; \
		s/DAYOFWK_9/$$(date --date='2 weeks 1 day' +%w)/g; \
	}" setup/populate.sql > setup/populate.sql.tmp



# dbload - Load up the database
dbload:	dbprep
dbload:	
	sqlcmd -S $(DBSERVER) -i setup/schema.sql.tmp -U $(DBUSER) -P $(DBPASSWORD)
	sqlcmd -S $(DBSERVER) -i setup/populate.sql.tmp -U $(DBUSER) -P $(DBPASSWORD)


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
	

