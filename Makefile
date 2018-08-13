# Vars
PREFIX=
DBUSER="SA"
DBPASSWORD="GKbAt68!"

# Create a changelog
changelog:
	@echo "Creating / updating CHANGELOG document..."
	@touch CHANGELOG


# Notate a change (Target should work on all *nix and BSD)
change:
	@test -f CHANGELOG || printf "No changelog exists.  Use 'make changelog' first.\n\n"
	@test -f CHANGELOG
	@echo "Press [Ctrl-D] to save this file."
	@cat > CHANGELOG.USER
	@date > CHANGELOG.ACTIVE
	@sed 's/^/\t -/' CHANGELOG.USER >> CHANGELOG.ACTIVE
	@printf "\n" >> CHANGELOG.ACTIVE
	@cat CHANGELOG.ACTIVE CHANGELOG > CHANGELOG.NEW
	@rm CHANGELOG.ACTIVE CHANGELOG.USER
	@mv CHANGELOG.NEW CHANGELOG


# Package
pkg:
	tar chzf ../iv.`date +%F-%H-%m-%s`.tgz --exclude=./Application.cfc ./*


#rsync -arvz --delete /cygdrive/c/lucee/tomcat/webapps/motrpac/web/secure/dataentry/--exclude=./Application.cfc ./*
# Test on Lucee
lucee:
	rsync -arvz --delete --exclude=Application.cfc --exclude=.git --exclude=.gitignore --exclude=.*.swp --exclude=*.tgz /cygdrive/c/ColdFusion2016/cfusion/wwwroot/motrpac/web/secure/dataentry/iv/ /cygdrive/c/lucee/tomcat/webapps/motrpac/web/secure/dataentry/iv/
	

# Load up the database
dbload:	
	sqlcmd -i setup/schema.sql -U $(DBUSER) -P $(DBPASSWORD)
	sqlcmd -i setup/populate.sql -U $(DBUSER) -P $(DBPASSWORD)
