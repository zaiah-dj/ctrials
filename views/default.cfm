<!--- Let's Try the simplest possible things in the world --->
<cfoutput>
<ul class="participants" id="participant_list">
	<cfloop query="itch">
	<li>
	<h2>#participant_fname# #participant_lname#</h2>
	</li>
	</cfloop>
</ul>
</cfoutput>
