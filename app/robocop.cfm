<cfscript>
//don't need a return status...  just log what came
aa=	CreateObject("component", "components.requestLogger" )
		.init(table = "ac_mtr_serverlog", ds="#coldmvc.app.source#")
		.append(message=form.message);
</cfscript>
