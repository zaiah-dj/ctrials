<!--- -------------------------------------------------------------------------
custom.cfm
==========

Notes:
------
These comments are written in Markdown and can be converted to HTML by running
`make doc`.


Date Created:        
------------
2018-09-25


Author(s):   
------------
-

Description: 
------------
This file contains two functions that really shouldn't be functions.  If I do 
not get the time to come back and refactor this, let these comments serve as 
a pretty good example of what they do.

Summary:
--------
If SelectedParticipants is not defined, 
	most likely nothing has started, so return a blank table
If SelectedParticipants is defined, 
	then extract the GUIDs from the query
	create a table using participantSchema
	and match it as the value for the participant GUID
	you should have
	[ guid ] = ParticipantSchema


 ---- ------------------------------------------------------------------------->
<cfscript>
function buildRecordThreads( sess_t, q ) {
	if ( !StructKeyExists( sess_t, "participants" ) ) { 
		sess_t.participants = {};
	}

	//Check for the participant key in the partiicpants struct
	for ( p in q ) {	
		//Regenerate if this is not there.
		key = Trim( p.participantGUID );
		if ( !StructKeyExists( sess_t.participants, key) ) {
			//Create a key that can be referenced by the participant GUID
			cp = sess_t.participants[ key ] = {};
			cp.recordThread = Trim( dbExec( string = "SELECT UUID() as newGUID" ).results.newGUID );
			cp.checkInCompleted = 0 ;
			cp.exerciseParameter = 0 ;
			cp.recoveryCompleted = 0;
			cp.lastExerciseCompleted = 0;
			cp.randomizedType = ( ListContains( const.ENDURANCE, p.randomGroupCode ) ) ? 1 : 2;
			cp.randomizedTypeName = ( ListContains( const.ENDURANCE, p.randomGroupCode ) ) ? "Endurance" : "Resistance";
			cp.week = 0;
			cp.getNewBP = 0;	
			//This has to be initialized later...
			cp.BPDaysLeft = 0;
			cp.BPSystolic = 0;
			cp.BPDiastolic = 0;
			cp.targetHR = 0;
			cp.weight = 0;
			cp.exlist = 0;
		}
	}
}


//Display a message upon redirection
function errAndRedirect( Required String goto, Required String msg, parameters ) {
	//clearly, this is not a good way to handle this...
	if ( StructKeyExists( arguments, "parameters" ) && !IsStruct( StructFind( arguments, "parameters" ) ) ) {
		throw "Parameters argument is not a struct!";
	} 

	//Create an array for the link
	theLink = link( goto & ".cfm" ) & "?";
	theLink &= "err=" & EncodeForURL( msg ) & "";

	//Add the params
	if ( StructKeyExists( arguments, "parameters" ) ) {
		//Loop through?
		for ( Par in arguments.parameters ) {
			theLink &= "&#Par#=#arguments.parameters[ Par ]#";
		}
	}

	//Redirect
	location( 
		addtoken="no" 
	 ,url = theLink
	);
}
</cfscript>
