<!--- reassign.cfm --->
<cfscript>
public = {
	staff = ezdb.exec(
		string = "select * from #data.data.staff# where ts_siteid = :site"
	 ,bindArgs = { site = siteId }
	)
};
</cfscript>
