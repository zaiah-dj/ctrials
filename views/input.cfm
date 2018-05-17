	<!--- Keep this the simplest possible template in the universe --->
	<div class="container-body">
		<cfif !isDefined("part")>
			<cfinclude template="participant-stubs/nothing.cfm">
		<cfelse>
			<!--- Include control --->
			<cfif #part.randomGroupCode# eq "0">
				<cfinclude template="participant-stubs/control.cfm">

			<!--- Include endurance --->
			<cfelseif #part.randomGroupCode# eq ENDURANCE>
				<cfinclude template="participant-stubs/endurance.cfm">

			<!--- Include resistance --->
			<cfelseif part.randomGroupCode eq RESISTANCE>
				<cfinclude template="participant-stubs/resistance.cfm">
		
			<!--- Include --->	
			</cfif>
		</cfif>
	</div>
