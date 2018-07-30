<div class="container-body">
<cfoutput>
<!---
<!--- Keep this the simplest possible template in the universe --->
		<!--- Include control --->
		<cfif !isDefined("currentParticipant") or (currentParticipant.results.randomGroupCode eq "")>
			<cfinclude template="participant-stubs/nothing.cfm">
	
		<cfelseif ListContains(CONTROL, currentParticipant.results.randomGroupCode)>
			<cfinclude template="participant-stubs/control.cfm">

		<!--- Include endurance --->
		<cfelseif ListContains(ENDURANCE, currentParticipant.results.randomGroupCode)>
			<cfinclude template="participant-stubs/endurance.cfm">

		<!--- Include resistance --->
		<cfelseif ListContains(RESISTANCE, currentParticipant.results.randomGroupCode)>
			<cfinclude template="participant-stubs/resistance.cfm">

		<!--- Include --->	
		</cfif>
--->

	<!--- This is for CF AJAX --->
	<cfif data.debug eq 1>
		<cfset DebugClientCode = ajax.ClientDebug()>
	</cfif>

	<!--- Place the time or exercise type on the page so that JS can query it. --->
	<input type="hidden" value="#private.magic#" name="#private.hiddenVarName#">

	<!--- Generate the modifier list per each participant type --->
	<ul class="inner-selection">
	<cfloop query = "#private.modNames#">
		<a href="#link( 'input.cfm?id=#url.id#&#private.mpName#=#urlparam#' )#"><li class="#iif(private.magic eq urlparam, DE('selected'),DE(''))#">#pname#</li></a>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#' )#"><li class="bg-red stop-sess">Stop Session</li></a>
	</ul>

</cfoutput>
</div>
