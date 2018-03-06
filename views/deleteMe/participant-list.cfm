<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
<div class="part-div">
<ul class="participants" id="participant_list">



	<cfloop query="part_list" >
	<li class="selected">
		<a class="selected" href="#link( "input.cfm?id=#participant_id#" )#">
			<div class="participant-selector">
				#participant_fname# #participant_lname#
			</div>
		</a>
	</li>
	</cfloop>
</ul>
</div>
</cfoutput>
