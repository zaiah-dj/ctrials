<cfset url.id=2>

<cfset aa = CreateObject("component", "components.requestLogger" )
	.init(table = "ac_mtr_serverlog", ds="#data.source#").append()>
