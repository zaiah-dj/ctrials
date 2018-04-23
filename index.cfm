<!---
Application.cfc

@author
	Antonio R. Collins II (ramar.collins@gmail.com)
@end

@copyright
	Copyright 2016-Present, "Deep909, LLC"
	Original Author Date: Tue Jul 26 07:26:29 2016 -0400
@end

@summary
 	ColdMVC's index file.  The single entry point for applications
	running on this framework. 
@end
  --->
<cffunction name="sendRequest">
	<cfargument name="status">
	<cfargument name="message">

	<cfset aa = CreateObject("component", "components.requestLogger" )
		.init(table = "ac_mtr_serverlog", ds="#data.source#")
		.append(message = "#arguments.message#")>

	<cfcontent type="application/json">
		<cfoutput>{ "status": #arguments.status#, "message": "#arguments.message#" }</cfoutput>  
	</cfcontent>
	<cfabort>
</cffunction>

<cfscript>
	coldmvc = createObject("component", "coldmvc").init({});
	coldmvc.make_index(coldmvc);
	if ( coldmvc.app.page neq "log" ) {
		log = CreateObject("component", "components.requestLogger" )
			.init(table = "ac_mtr_serverlog", ds="#coldmvc.app.source#").append();
	}
</cfscript>
