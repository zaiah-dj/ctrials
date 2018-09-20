<!--- staff.cfm --->
<cfscript>
associatedParticipants = dbExec(
	filename = "staff_assignedToOthers.sql"
, bindArgs = { ssid = csSid, self = usr.userguid, site_id = usr.siteid }
);
</cfscript>
