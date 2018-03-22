<!--- participant list can go off to the side -->
	<div class="menu-div">
		PARTICIPANTS	
	</div>

	<div class="mid-cent">
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
	</div> <!--- div class=mid-cent --->
