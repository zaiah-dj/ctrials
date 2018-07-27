<cfoutput>
<cfif selectedParticipants.prefix.recordCount gt 0>
	<p style="text-align: left; color: black;">
		Please choose a participant from the top to get started.
	</p>
<cfelse>
	<p style="text-align: left; color: black;">
		Uh oh!  It looks like you haven't selected any participants yet. 
	</p>

	<p style="text-align: left; color: black;">
		Please start off by selecting a few via the 
		<a href="#link( 'default.cfm' )#">Participant List</a> page.
	</p>
</cfif>
</cfoutput>
