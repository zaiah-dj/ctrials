<cfoutput>
<div class="nav head-nav">
	<ul class="nav">
		<a #iif( data.page eq 'default', DE('class="selected"'), '' )# href="#link( "" )#"><li>Home</li></a>
		<a #iif( data.page eq 'chosen', DE('class="selected"'), '' )# href="#link( "chosen.cfm" )#"><li>Chosen</li></a>
		<a href="#link( "logout.cfm" )#"><li>Logout</li></a>
	</ul>
</div>
</cfoutput>
