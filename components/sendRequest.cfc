<cfcomponent accessors="yes" name="bypass">
	<cfset this.datasource = "">

	<cffunction name="init" output="false"> 
		<cfargument name="dsn" type="string">
		<cfset this.datasource = arguments.dsn>
		<cfreturn this>
	</cffunction>

	<cffunction name="sendAsJson">
		<cfargument name="status">
		<cfargument name="message">

<!---
		<cfset aa = CreateObject("component", "components.requestLogger" )
			.init(table = "ac_mtr_serverlog", ds="#this.datasource#")
			.append(message = "#arguments.message#")>
--->
		<cfcontent type="application/json">
			<cfoutput>{ "status": #arguments.status#, "message": "#arguments.message#" }</cfoutput>  
		</cfcontent>
		<cfabort>

	</cffunction>
</cfcomponent>
