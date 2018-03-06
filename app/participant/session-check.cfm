<cfscript>
if ( 1 ) {
	//Pre-select an ID for this test run so that I don't have to put up with it....
	session.iv_sess_id = 24716702;
}
else {
	//right now, I'm passing the session id via Javascript
	//it's ugly and really could use a rework

	if ( 
		   !structKeyExists( url, "transact_id" ) 
		&& !structKeyExists( form, "transact_id" )
		&& !structKeyEXists( session, "iv_sess_id" )
		)
	{

		//redirect the user and get them to fill out stuff again.
		writeoutput( "<h2>Session</h2>" );
		writedump( session );

		writeoutput( "<h2>Form</h2>" );
		writedump( form );

		writeoutput( "<h2>URL</h2>" );
		writedump( url );

		//
		loc = '/home';
		writeoutput( "would have redirected user to: " & loc );
		abort;

	}


	if ( structKeyExists( session, "iv_sess_id" ) ) {
		writeoutput( "<div class='campy-hidden'>Using Session ID</div>" );
	}

	else if ( structKeyExists( url, "transact_id" ) ) {
		
		//If the session id doesn't already exist set it.
		writeoutput( "<div class='campy-hidden'>Using Session ID from URL</div>" );

	}

	else if ( structKeyExists( form, "transact_id" ) ) {

		//Check that this session ID has already been submitted at an earlier point in time.
		//SELECT * FROM ... WHERE sess_id = sess_id
		//If the session id doesn't already exist set it.
		if ( !structKeyExists( session, "iv_sess_id" ) ) {
			session.iv_sess_id = form.transact_id;
		}

		writeoutput( "<div class='campy-hidden'>Using Session ID from POST</div>" );
	}
}
</cfscript>
