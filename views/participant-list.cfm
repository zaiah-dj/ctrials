<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
<div class="part-div">
<ul class="participants" id="participant_list">
	<cfloop query="part_list" >
	<li>
		<a class="" href="#link( "participant.cfm?id=#participant_id#" )#">
			<div class="participant-selector">
				#participant_fname# #participant_lname#
			</div>
		</a>
	</li>
	</cfloop>
</ul>
</div>
</cfoutput>
