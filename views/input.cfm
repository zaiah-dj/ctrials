	<!--- Keep this the simplest possible template in the universe --->
	<div class="container-body">
		<!--- Include control --->
		<cfif #part.p_exercise# eq "0">
			<cfinclude template="participant-stubs/control.cfm">

		<!--- Include endurance --->
		<cfelseif #part.p_exercise# eq "1">
			<cfinclude template="participant-stubs/endurance.cfm">

		<!--- Include resistance --->
		<cfelseif part.p_exercise eq "2">
			<cfinclude template="participant-stubs/resistance.cfm">
		</cfif>

	</div>
