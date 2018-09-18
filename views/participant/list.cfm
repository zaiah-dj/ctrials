<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
	<div class="container-header">
		<ul id="participant_list">
		 <cfif isDefined("selectedParticipants")>
		  <cfloop query = selectedParticipants.results >
			
			<cfif ListContains( const.ENDURANCE, randomGroupCode )>
				<cfset listClassPrefix="endurance">
			<cfelseif ListContains( const.RESISTANCE, randomGroupCode )>
				<cfset listClassPrefix="resistance">
			<cfelse>
				<cfset listClassPrefix="control">
			</cfif>

			<cfif Len( "#firstname# #lastname#" ) gt 23>
				<cfset firstname="#Left(firstname,1)#.">
			</cfif>

			<cfif IsDefined("url.id") and #url.id# eq #participantGUID#>
				<a class="selected" href="#link( "check-in.cfm?id=#participantGUID#" )#">
					<li class="#listClassPrefix#-selected #listClassPrefix#-class-container">#firstname# #lastname#<br />( #pid# )</span></li>
				</a>
			<cfelse>	
				<a class="" href="#link( "check-in.cfm?id=#participantGUID#" )#">
					<li class="#listClassPrefix#-class-container">#firstname# #lastname#<br />( #pid# )</li>
				</a>
			</cfif>	
				
		  </cfloop>
		 </cfif>
		</ul>
	</div> <!-- class="container-header" -->
</cfoutput>
