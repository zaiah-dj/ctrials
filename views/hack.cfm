<!--- --->
<cfoutput>
<h2>This page does not really work...</h2>
<form action="#link('update.cfm')#" method="POST">
	<input type="hidden" name="this" value="macDebugStartSession">
	<input type="hidden" value="#sess.key#" name="transact_id">
	<input type="hidden" value="#randnum( 10 )#" name="staffer_id">
	<input type="hidden" value="1,2,3" name="list">

	<input type="submit" value="Submit!"> 
</form>
</cfoutput>
