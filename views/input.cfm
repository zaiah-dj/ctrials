	<!--- Keep this the simplest possible template in the universe --->
	<div class="part-div">

		<!--- Include control --->
		<cfif #part.participant_exercise# eq "0">
			<cfinclude template="participant-stubs/control.cfm">

		<!--- Include endurance --->
		<cfelseif #part.participant_exercise# eq "1">
			<cfinclude template="participant-stubs/endurance.cfm">

		<!--- Include resistance --->
		<cfelseif part.participant_exercise eq "2">
			<cfinclude template="participant-stubs/resistance.cfm">
		</cfif>
	</div>
