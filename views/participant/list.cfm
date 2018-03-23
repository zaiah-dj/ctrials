<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
	<div class="container-header">
		<ul id="participant_list">
		 <cfif isDefined("part_list")>
		  <cfloop query="part_list" >

			<cfif IsDefined("url.id") and #url.id# eq #participant_id#>
				<a class="selected" href="#link( "check-in.cfm?id=#participant_id#" )#">
					<li class="selected">#participant_fname# <br/>#participant_lname#</li>
				</a>
			<cfelse>	
				<a class="" href="#link( "check-in.cfm?id=#participant_id#" )#">
					<li>#participant_fname# <br/>#participant_lname#</li>
				</a>
			</cfif>	
				
		  </cfloop>
		 </cfif>
		</ul>
	</div> <!-- class="container-header" -->
</cfoutput>
