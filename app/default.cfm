<!--- Allow staff to choose a list of participants for the day. --->
<cfscript>
writedump( ajax );
writedump( ezdb   );
writedump(  rl    );
writedump( bypass );
writedump(  cf    );
abort;
</cfscript>


<cfquery datasource="#data.source#" name="all_part_list">
	SELECT 
		* 
	FROM 
		#data.data.participants#	
	ORDER BY p_lname ASC 
</cfquery>


// Initialize client side AJAX code 
<cfset AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
	location = link( "update.cfm" )
 ,querySelector = [{
		dom = "##wash-id"
	 ,event = "submit"
	 ,noPreventDefault = true
	 ,send = ".listing-drop ul li span:nth-child(2)"
	}]
 ,additional = [ 
	{ name="this", value= "startSession" }
	]
)>
