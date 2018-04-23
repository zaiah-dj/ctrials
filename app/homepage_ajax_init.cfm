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
