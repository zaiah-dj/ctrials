<cfoutput>
<div class="nav head-nav">
	<ul class="nav">
		<a #iif( data.page eq 'default', DE('class="selected"'), '' )# href="#link( "" )#"><li>Home</li></a>
		<a #iif( data.page eq 'chosen', DE('class="selected"'), '' )# href="#link( "chosen.cfm" )#"><li>Chosen</li></a>
		<a #iif( data.page eq "gto", 'class="selected"', "" )# href="#link( "global-participant-list.cfm" )#">
			<li><span style="font-size:0.6em;">Participant List</span></li>
		</a>
	</ul>
</div>
</cfoutput>
