<cfoutput query="part" >
<div class="participant-info">
	<h2>#part.participant_fname# #part.participant_lname#</h2>

	<ul class="participant-info-nav">
		<!---
		<a href="#link( "participant-input.cfm?id=13" )#"><li><h3>Test Controls</h3></li></a>
		<a href="#link( "participant-control.cfm" )#"><li><h3>Enter Control Data</h3></li></a>
			--->
	<cfif not StructKeyExists( url, "id" )>
		<a href="#link( "input.cfm" )#"><li><h3>Enter Today's Exercise Data</h3></li></a>
		<a href="#link( "compare.cfm" )#"><li><h3>Compare Previous Data</h3></li></a>
		<a href="#link( "info.cfm" )#"><li><h3>Participant Info</h3></li></a>
	<cfelse>
		<a href="#link( "input.cfm?id=#url.id#" )#"><li><h3>Enter Today's Exercise Data</h3></li></a>
		<a href="#link( "compare.cfm?id=#url.id#" )#"><li><h3>Compare Previous Data</h3></li></a>
		<a href="#link( "info.cfm?id=#url.id#" )#"><li><h3>Participant Info</h3></li></a>
	</cfif>
	</ul>
	
</div>
</cfoutput>
