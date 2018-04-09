<!---<cfoutput><meta http-equiv="refresh" content="2; URL='#link( "input.cfm?id=#form.ps_pid#" )#'"></cfoutput>--->
<cfset l = location( url=link( "input.cfm?id=#form.ps_pid#" ), addtoken="no" )>
<h2>Check in is complete</h2>
<cfif data.debug eq 1>
<cfoutput>#message#</cfoutput>
</cfif>
