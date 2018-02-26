<cfoutput query="part" >
<div class="participant-info">
	<h2>#part.participant_fname# #part.participant_lname#</h2>

	<ul class="participant-info-nav">
		<a href="#link( "participant-input.cfm?id=13" )#"><li><h3>Test Controls</h3></li></a>
	<cfif not StructKeyExists( url, "id" )>
		<a href="#link( "participant.cfm" )#"><li><h3>Patient Data</h3></li></a>
		<a href="#link( "participant-control.cfm" )#"><li><h3>Enter Control Data</h3></li></a>
		<a href="#link( "participant-endurance.cfm" )#"><li><h3>Enter EE Data</h3></li></a>
		<a href="#link( "participant-resistance.cfm" )#"><li><h3>Enter RE Data</h3></li></a>
		<a href="#link( "participant-compare.cfm" )#"><li><h3>Compare Data</h3></li></a>
	<cfelse>
		<a href="#link( "participant.cfm?id=#url.id#" )#"><li><h3>Patient Data</h3></li></a>
		<a href="#link( "participant-control.cfm?id=#url.id#" )#"><li><h3>Enter Control Data</h3></li></a>
		<a href="#link( "participant-endurance.cfm?id=#url.id#" )#"><li><h3>Enter EE Data</h3></li></a>
		<a href="#link( "participant-resistance.cfm?id=#url.id#" )#"><li><h3>Enter RE Data</h3></li></a>
		<a href="#link( "participant-compare.cfm?id=#url.id#" )#"><li><h3>Compare Data</h3></li></a>
	</cfif>
	</ul>
	
</div>
</cfoutput>
