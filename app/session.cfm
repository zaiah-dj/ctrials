<!--- start combining session stuff --->
<cfscript>
//Session st 
if ( isDefined('url.id') ) {
	session.ps_day = StructKeyExists( form,  "ps_day") ? form.ps_day : session.ps_day ;
	session.ps_week = StructKeyExists( form,  "ps_week") ? form.ps_week : session.ps_week ;
	session.ps_next_sched = StructKeyExists( form,  "ps_next_sched") ? form.ps_next_sched : session.ps_next_sched ;
	session.staffer_id = StructKeyExists( form,  "ps_day") ? form.ps_day : session.ps_day ;
	session.id = StructKeyExists( url, "id") ? url.id : session.id ;
	session.extype = StructKeyExists( url, "extype") ? url.extype : session.extype ;
	session.time = StructKeyExists( url,  "time") ? url.time : session.time ;
	session.location = "#cgi.script_name#?#cgi.query_string#";
}
</cfscript>
