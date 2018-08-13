<cfscript>
try {
	//Check for the existence of the following fields in the FORM scope
	exist = val.validate( form, {
		interventionist_id  = { req = true }  //The staff member's id
	 ,sessday_id  = { req = true }  //Key used to track the current day's session
	 ,list        = { req = true }  //List of participants for a particular staff member
	});

	if ( !exist.status ) {
		req.sendAsJson( status = 0, message = "#exist.message#" );
	}

	//Save to a different struct to reference each var
	fv = exist.results;

	//Save each participantGUID to its own row
	for ( pid in ListToArray( fv.list ) ) {
		//Check for the PID
		stmt = dbExec(
			string = "
			SELECT
				csd_participant_guid as pGUID 
			FROM 
				#data.data.sia# 
			WHERE
				csd_daily_session_id = :sessdayid
			AND	
				csd_participant_guid = :guid
			"	
		 ,bindArgs = {
				sessdayid = fv.sessday_id
			 ,guid      = pid 
			}
		);

		//If not there, add it
		if ( stmt.results.pGUID eq "" ) {
			//Add the PID if it's not already there
			stmt = dbExec(
				string = "
				INSERT INTO #data.data.sia# 
					( 
						csd_daily_session_id, 
						csd_interventionist_guid, 
						csd_participant_guid
					)
				VALUES 
					( :sessdayid, 
						:iguid, 
						:pguid 
					)
				"
			 ,bindArgs = {
					sessdayid = fv.sessday_id
				 ,iguid     = fv.interventionist_id
				 ,pguid     = pid 
				}
			);
		}

		if ( !stmt.status ) {
			req.sendAsJson( status=0, message="Failed to add members to new session - #stmt.message#" );
		}
	}
}
catch (any ff) {
	req.sendAsJson( 
		status = 0, 
		message= "Failed to add members to new session - #ff# - #data.source#"
	);
}


//Send a response
req.sendAsJson( 
	status = 1, 
	message = "Successfully began new Intervention Tracking session with: "
					& "interventionist_id  = #fv.interventionist_id #\n"
					& "sessday_id  = #fv.sessday_id #\n"
					& "list        = #fv.list       #\n"
					& "using datasource: #data.source#." 
);
</cfscript>
