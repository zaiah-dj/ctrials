<!--- -------------------------------------------------------------------------
api.cfm
=======

Date Created
------------
2018-09-25


Author(s)
---------
-

Description
-----------
Each route that utilizes this page will return a JSON payload with the content-type
'application/json'.

Summary
-------
-

Scopes Used
-----------
No new scopes are introduced here.

 ---- ------------------------------------------------------------------------->
<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "startSession" )
	include "api_start_session.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "notes" )
	include "api_get_participant_notes.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "time" )
	include "api_update_time.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "checkin" )
	include "api_update_checkin_tables.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "control" )
	include "api_update_control_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "endurance" ) 
	include "api_update_endurance_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "resistance" )
	include "api_update_resistance_table.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "recovery" ) 
	include "api_update_recovery.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "addParticipant" ) 
	include "api_add_participant.cfm";
else if ( StructKeyExists( form, "this" ) && form.this eq "releaseParticipant" ) {
	include "api_release_participant.cfm";
}

//Get completed days
if ( data.loaded eq "completed-days-results" ) 
	include "api_get_completed_days.cfm";
else if ( data.loaded eq "modal-results" ) 
	include "api_display_previous.cfm";
else if ( data.loaded eq "update-note" ) 
	include "api_update_participant_note.cfm";

</cfscript>
