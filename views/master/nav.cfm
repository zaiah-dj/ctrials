<cfoutput>
<div class="header">
	<input type="checkbox" class="checkity">
	<div class="side-menu">
		<div class="menu-div">
			NAV
		</div>
		<div class="nav">
			<ul class="nav">
				<a #iif( data.page eq 'default', DE('class="selected"'), '' )# href="#link( "" )#"><li>Home</li></a>
				<a #iif( data.page eq 'chosen', DE('class="selected"'), '' )# href="#link( "chosen.cfm" )#"><li>Chosen</li></a>
				<a href="#link( "logout.cfm" )#"><li>Logout</li></a>
			</ul>
		</div> <!--- div class=nav --->
		
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
	</div> 
</div> 

</cfoutput>
