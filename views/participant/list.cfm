<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
	<div class="part-list">
		<ul class="participants" id="participant_list">

		<cfif isDefined("part_list")>
		<cfloop query="part_list" >
			<a class="" href="#link( "check-in.cfm?id=#participant_id#" )#">
				<li>#participant_fname# <br/>#participant_lname#</li>
			</a>
		</cfloop>
		</cfif>

			<a class="" href="#link( "" )#">
				<li>+<br/><span style="color:black;">+</span></li>
			</a>

		</ul>
	</div>
</cfoutput>