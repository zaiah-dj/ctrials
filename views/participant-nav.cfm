<cfoutput query="part" >
<div class="participant-info">
	<h2>#part.participant_fname# #part.participant_lname#</h2>

	<ul class="participant-info-nav">
	<cfif not StructKeyExists( url, "id" )>
		<a href="#link( "participant.cfm" )#"><li><h3>Patient Data</h3></li></a>
		<a href="#link( "participant-input.cfm" )#"><li><h3>Enter Data</h3></li></a>
		<a href="#link( "participant-compare.cfm" )#"><li><h3>Compare Data</h3></li></a>
	<cfelse>
		<a href="#link( "participant.cfm?id=#url.id#" )#"><li><h3>Patient Data</h3></li></a>
		<a href="#link( "participant-input.cfm?id=#url.id#" )#"><li><h3>Enter Data</h3></li></a>
		<a href="#link( "participant-compare.cfm?id=#url.id#" )#"><li><h3>Compare Data</h3></li></a>
	</cfif>
	</ul>
	
</div>
</cfoutput>
