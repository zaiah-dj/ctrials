<!---
api.cfm
-------
A better way to handle all the API updates needed by CF.
Still ugly though, because it's CF ;)
  --->
<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "startSession" )
	include "api/start_session.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "control" )
	include "api/update_control_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "endurance" ) 
	include "api/update_endurance_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "resistance" ) {
	include "api/update_resistance_table.cfm";
}

//Get completed days
if ( data.loaded eq "completed-days-results" ) 
	include "api/get_completed_days.cfm";
else if ( data.loaded eq "modal-results" ) 
	include "api/display_previous.cfm";
else if ( data.loaded eq "update-note" ) 
	include "api/update_participant_note.cfm";

</cfscript>
