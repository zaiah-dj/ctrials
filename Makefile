# Vars
PREFIX=

# Common utilities act differently on different boxes
#SED=gsed
#TAR=tar
#DATE=gdate
SED=sed
TAR=tar
DATE=date

# Type your credentials for MySQL here 
#DBUSER="root"
#DBPASSWORD=""
DBUSER="SA"
DBPASSWORD="GKbAt68!"

# Things that should never change
DBSERVER="localhost"
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


# Extract just the targets so that I know what everything does
main:
	@printf "Available options are:\n"
	@grep '^# [a-z]' Makefile | sed 's/^# //'


# mssql - Load and prepare database tables for a client running SQL Server 2016+ 
mssql: SQLBIN=sqlcmd
mssql: SCHEMA=setup/schema.mssql.sql
mssql: RECORDS=setup/populate.mssql.sql 
mssql: dbprep
mssql:
	$(SQLBIN) -S $(DBSERVER) -i setup/schema.sql.tmp -U $(DBUSER) -P $(DBPASSWORD)
	$(SQLBIN) -S $(DBSERVER) -i setup/populate.sql.tmp -U $(DBUSER) -P $(DBPASSWORD)


# mysql - Load and prepare database tables for a client running MySQL
mysql: SQLBIN=mysql
mysql: SCHEMA=setup/schema.mysql.sql
mysql: RECORDS=setup/populate.mysql.sql
mysql: dbprep
mysql:	
	$(SQLBIN) -u $(DBUSER) --password=$(DBPASSWORD) < setup/schema.sql.tmp
	$(SQLBIN) -u $(DBUSER) --password=$(DBPASSWORD) < setup/populate.sql.tmp


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


# verify - Use to verify commands before finalizing them.
verify:	
	echo $(SCHEMA)
	echo $(RECORDS)
	echo $(SQLBIN)


# dbprep - Prepare the files to be loaded into database
dbprep:	
	test ! -z $(SCHEMA)
	@cp $(SCHEMA) setup/schema.sql.tmp
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
	}" $(RECORDS) > setup/populate.sql.tmp


# clean - Clean up any new files
clean: 
	rm setup/{schema,populate}.sql.tmp	


