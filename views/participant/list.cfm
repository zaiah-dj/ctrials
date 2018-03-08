<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
<div class="part-div">
<ul class="participants" id="participant_list">
	<cfloop query="part_list" >
	<a class="" href="#link( "check-in.cfm?id=#participant_id#" )#">
		<li>#participant_fname# <br />#participant_lname#</li>
	</a>
	</cfloop>
</ul>
</div>
</cfoutput>
