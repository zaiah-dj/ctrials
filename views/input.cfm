	<!--- Keep this the simplest possible template in the universe --->
	<div class="container-body">
		<cfif !isDefined("currentParticipant")>
			<cfinclude template="participant-stubs/nothing.cfm">
		<cfelse>
			<!--- Include control --->
			<cfif ListContains(CONTROL, currentParticipant.results.randomGroupCode)>
				<cfinclude template="participant-stubs/control.cfm">

			<!--- Include endurance --->
			<cfelseif ListContains(ENDURANCE, currentParticipant.results.randomGroupCode)>
				<cfinclude template="participant-stubs/endurance.cfm">

			<!--- Include resistance --->
			<cfelseif ListContains(RESISTANCE, currentParticipant.results.randomGroupCode)>
				<cfinclude template="participant-stubs/resistance.cfm">
		
			<!--- Include --->	
			</cfif>
		</cfif>
	</div>
