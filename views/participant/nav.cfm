<cfoutput query="part" >
<div class="participant-info">
	<h2>#part.participant_fname# #part.participant_lname#</h2>

	<ul class="participant-info-nav">
		<!---
		<a href="#link( "participant-input.cfm?id=13" )#"><li><h3>Test Controls</h3></li></a>
		<a href="#link( "participant-control.cfm" )#"><li><h3>Enter Control Data</h3></li></a>
			--->
	<cfif not StructKeyExists( url, "id" )>
		<a href="#link( "check-in.cfm" )#"><li>Check-In</li></a>
		<a href="#link( "input.cfm" )#"><li> Exercise Data</li></a>
		<a href="#link( "compare.cfm" )#"><li>Compare Data</li></a>
		<a href="#link( "info.cfm" )#"><li>Participant Info</li></a>
	<cfelse>
		<a href="#link( "check-in.cfm?id=#url.id#" )#"><li>Check-In</li></a>
		<a href="#link( "input.cfm?id=#url.id#" )#"><li> Exercise Data</li></a>
		<a href="#link( "compare.cfm?id=#url.id#" )#"><li>Compare Data</li></a>
		<a href="#link( "info.cfm?id=#url.id#" )#"><li>Participant Info</li></a>
	</cfif>
	</ul>
	
</div>
</cfoutput>
