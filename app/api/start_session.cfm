<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "startSession" ) {
	try {
		//Check for the existence of the following fields in the FORM scope
		exist = val.validate( form, {
			transact_id = { req = true }  //???
		 ,staffer_id  = { req = true }  //The staff member's id
		 ,prk_id      = { req = true }  //Key used to get a staff member's current participants
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
			stmt = ezdb.exec(
				string = "
				SELECT
					sp_participantGUID as PID
				FROM 
					#data.data.sessiondpart# 
				WHERE
					sp_sessdayid = :sessdayid
				AND	
					sp_participantrecordkey = :prkid
				AND	
					sp_participantGUID = :guid
				"	
			 ,bindArgs = {
					sessdayid = fv.sessday_id
			   ,prkid     = fv.prk_id
				 ,guid      = pid 
				}
			);

			//If not there, add it
			if ( stmt.results.pid eq "" ) {
				//Add the PID if it's not already there
				stmt = ezdb.exec(
					string = "
					INSERT INTO #data.data.sessiondpart# 
						( sp_sessdayid, 
							sp_participantrecordkey, 
							sp_participantGUID, 
							sp_participantrecordthread 
						)
					VALUES 
						( :sessdayid  , :prkid, :guid, '' )
					"
				 ,bindArgs = {
						sessdayid = fv.sessday_id
					 ,prkid     = fv.prk_id
					 ,guid      = pid 
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
					  & "transact_id = #fv.transact_id#\n"
					  & "staffer_id  = #fv.staffer_id #\n"
					  & "prk_id      = #fv.prk_id     #\n"
					  & "sessday_id  = #fv.sessday_id #\n"
					  & "list        = #fv.list       #\n"
					  & "using datasource: #data.source#." 
	);
	abort;
}
</cfscript>
