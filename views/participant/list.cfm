<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
	<div class="container-header">
		<ul id="participant_list">
		 <cfif isDefined("selectedParticipants")>
		  <cfloop query = selectedParticipants.results >
			
			<cfscript>cssClassName=ListContains(ENDURANCE,randomGroupCode) ? "endurance-class" : "resistance-class";</cfscript>

			<cfif Len( "#firstname# #lastname#" ) gt 23>
				<cfset firstname="#Left(firstname,1)#.">
			</cfif>

			<cfif IsDefined("url.id") and #url.id# eq #participantGUID#>
				<a class="selected" href="#link( "check-in.cfm?id=#participantGUID#" )#">
					<li class="selected #cssClassName#-container">#firstname# #lastname#<br />( #pid# )</span></li>
				</a>
			<cfelse>	
				<a class="" href="#link( "check-in.cfm?id=#participantGUID#" )#">
					<li class="#cssClassName#-container">#firstname# #lastname#<br />( #pid# )</li>
				</a>
			</cfif>	
				
		  </cfloop>
				<a class=""> 
					<li class="control-class-container">Add New Participant<br />( + )</li>
				</a>
		 </cfif>
		</ul>
	</div> <!-- class="container-header" -->
</cfoutput>
