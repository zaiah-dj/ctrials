<!---<cfoutput><meta http-equiv="refresh" content="2; URL='#link( "input.cfm?id=#form.ps_pid#" )#'"></cfoutput>--->
<cfscript>location( url=link( "input.cfm?id=#form.ps_pid#" ), addtoken="no" )</cfscript>
<h2>Check in is complete</h2>
<cfif data.debug eq 1>
<cfoutput>#message#</cfoutput>
</cfif>
