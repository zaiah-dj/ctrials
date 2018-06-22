<!---

api.cfm

A better way to handle all the API updates needed by CF.

Still ugly though, because it's CF ;)


  --->
<cfscript>
/*
req.sendAsJson( status=0, message="Hi" &
"ajax = #serializeJSON(ajax)##Chr(10)#" &
"req = #serializeJSON(req)##Chr(10)#" &
"val = #serializeJSON(val)##Chr(10)#" &
"exe = #serializeJSON(exe)##Chr(10)#" &
"ezdb = #serializeJSON(ezdb)##Chr(10)#"  
);
*/

if ( StructKeyExists( form, "this" ) && form.this eq "startSession" )
	include "api/start_session.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "control" )
	include "api/update_control_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "endurance" ) 
	include "api/update_endurance_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "resistance" ) {
	include "api/update_resistance_table.cfm";
}

</cfscript>
