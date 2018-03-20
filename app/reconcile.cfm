<!--- reconcile 'part_list' vs 'all_part_list' --->
<cfif sessionStatus eq 2>
<cfset notList = "( '#ValueList( part_list.participant_lname, "', '" )#' )">
<cfoutput>#notList#</cfoutput>
<cfsavecontent variable="gig">
	SELECT 
		* 
	FROM
		ac_mtr_participants
	WHERE
		participant_lname IN ( :in_lim )
	ORDER BY participant_lname ASC
</cfsavecontent>

<!---
<cfscript>
a = new Query();
a.setDatasource( data.source );
a.setName( "rec_list" );
a.addParam( name = "in_lim", value = "#notList#", cfsqltype = "varchar" );
nn = a.execute( sql = "#gig#" );
aa = nn.getPrefix();
writedump( aa );
</cfscript>
<cfabort>
<cfquery datasource = "#data.source#" name = "rec_list">
	SELECT 
		* 
	FROM
		ac_mtr_participants
	WHERE
		participant_lname IN <cfoutput>#notList#</cfoutput>
	ORDER BY participant_lname ASC
</cfquery>

<cfset all_part_list = "#rec_list#">
--->
</cfif>
