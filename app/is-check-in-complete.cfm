<!--- simply check and see if somebody has completed their check-in already --->
<cfset sess_id = #session.iv_motrpac_transact_id#>
<cfset pid = #url.id#>

<cfquery name = "ctci" datasource= #data.source#>
SELECT * FROM 
	ac_mtr_checkinstatus
WHERE
	ps_pid = <cfqueryparam value = "#pid#" cfsqltype="cf_sql_integer">
	ps_session_id = <cfqueryparam value = "#sess_id#" cfsqltype="cf_sql_integer">
</cfquery>


<cfscript>
if ( cfci.resultCount eq 0 ) {
	location ( url = link( "check-in.cfm?id=#url.id#" ), token = "no" );
}
</cfscript>
