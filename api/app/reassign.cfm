<!--- reassign.cfm --->
<cfscript>
public = {
	staff = dbExec(
		string = "select * from #data.data.staff# where ts_siteid = :site"
	 ,bindArgs = { site = siteId }
	)
};
</cfscript>
