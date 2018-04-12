<cfoutput>
	<div class="container-body">
		Would you like to continue the current session?
		<form method="POST" action="#link( 'refresh.cfm' )#">
			<input type="submit" name="userSaysNo" style="margin-left: 30px" value="No"></input>
			<input type="submit" name="userSaysYes" value="Yes"></input>
		</form>
	</div>
</div> <!--- end of container from header --->
</cfoutput>
