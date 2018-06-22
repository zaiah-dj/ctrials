<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "startSession" ) {
	try {
		//Check for the existence of the following fields in the FORM scope
		exist = val.validate( form, {
			transact_id = { req = true }
		 ,staffer_id  = { req = true }
		 ,list        = { req = true }
		});

		if ( !exist.status ) {
			req.sendAsJson( status = 0, message = "#exist.message#" );
		}

		//Save each participantGUID to its own row
		for ( pid in ListToArray( form.list )) {	
			stmt = ezdb.exec(
				string = "INSERT INTO #data.data.sessionMembers# 
					VALUES ( :mid, :dom, :day, 0, :pid )"
			 ,bindArgs = {
					mid = form.transact_id
			   ,dom = DateTimeFormat( Now(), "d" ) 
			   ,day = sess.current.day
				 ,pid = pid 
				}
			);

			if ( !stmt.status ) {
				req.sendAsJson( status=0, message="Failed to add members to new session - #stmt.message#" );
			}
		}
	}
	catch (any e) {
		req.sendAsJson( 
			status = 0, 
			message= "Failed to add members to new session - #e.message# - #data.source# - #e.detail#"
		);
	}

	req.sendAsJson( 
		status = 1, 
		message = "Successfully began new participant session "
					  & "with datasource: #data.source#." 
	);
	abort;
}
</cfscript>
