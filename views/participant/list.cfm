<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
	<div class="container-header">
		<ul id="participant_list">
		 <cfif isDefined("part_list")>
		  <cfloop query="part_list.results" >

			<cfif IsDefined("url.id") and #url.id# eq #participantGUID#>
				<a class="selected" href="#link( "check-in.cfm?id=#participantGUID#" )#">
					<li class="selected">#firstname# <br/>#lastname#</li>
				</a>
			<cfelse>	
				<a class="" href="#link( "check-in.cfm?id=#participantGUID#" )#">
					<li>#firstname# <br/>#lastname#</li>
				</a>
			</cfif>	
				
		  </cfloop>
		 </cfif>
		</ul>
	</div> <!-- class="container-header" -->
</cfoutput>
