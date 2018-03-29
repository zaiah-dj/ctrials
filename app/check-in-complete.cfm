<!--- save check-in data --->
<!---
<cfdump var = #session#>
<cfdump var = #form#>
	--->
<cfset sess_id = #session.iv_motrpac_transact_id#>


<!--- Check for invalid methods --->
<cfif !IsDefined("form") || !IsDefined("session") || !IsStruct( form )>
	<cfcontent type="application/json">
	<cfoutput>{ status: 403, message: "Bad request." }</cfoutput>
	</cfcontent>
	<cfabort>
<cfelse>

<!---
<cfcontent type="application/json">
<cfoutput>{ sess: #sess_id# }</cfoutput>
</cfcontent>
<cfabort>
	--->

<cfscript>
message = "";
if ( !StructKeyExists( form, "ps_pid" ) || StructFind( form, "ps_pid" ) eq "" ) 
	message = "PID is missing";
if ( !StructKeyExists( form, "ps_weight" ) || StructFind( form, "ps_weight" ) eq "" ) 
	message = "Weight is missing";
if ( !StructKeyExists( form, "ps_day" )  || StructFind( form, "ps_day" ) eq "" ) 
	message = "Day of participation is missing";
if ( !StructKeyExists( form, "ps_next_sched" ) || StructFind( form, "ps_next_sched" ) eq "" ) 
	message = "Next scheduled visit is missing";
</cfscript>


<cfif message eq "">
	<h2>#message#</h2>
<cfelse>
<cftry>
	<cfscript>
	ns = "2008-09-09";
	bp = 0;
	nt = "";

	if ( StructKeyExists( form, "ps_bp" ) )
		bp = form.ps_bp;

	if ( StructKeyExists( form, "ps_notes" ) )
		nt = form.ps_notes;
	</cfscript>

	<cfquery name="updateT" datasource=#data.source#>
	INSERT INTO 
		ac_mtr_checkinstatus
	VALUES (
		 <cfqueryparam value="#form.ps_pid#" cfsqltype='cf_sql_integer'>
		,<cfqueryparam value="#sess_id#" cfsqltype='cf_sql_integer'>
		,1
		,<cfqueryparam value="#form.ps_weight#" cfsqltype='cf_sql_integer'>
		,<cfqueryparam value="#form.ps_day#" cfsqltype='cf_sql_integer'>
		,<cfqueryparam value="#bp#" cfsqltype='cf_sql_integer'>
		,0	
		,<cfqueryparam value="#ns#" cfsqltype='cf_sql_datetime'>
		,<cfqueryparam value="#DateTimeFormat( Now(), "YYYY-MM-DD" )#" cfsqltype='cf_sql_datetime'>
		,<cfqueryparam value="#nt#" cfsqltype='cf_sql_varchar'>
	);
	</cfquery>

	<cfcatch> 
		<cfdump var = #cfcatch#>
		<cfabort>
	</cfcatch>

	</cftry>

	</cfif>
</cfif>
