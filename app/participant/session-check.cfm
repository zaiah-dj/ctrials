<cfscript>

//Get rid of all sessions...
StructDelete( session, "iv_motrpac_transact_id" );

//
sessionDidntExist = 0;
staffId = 0;  //Just made up right now
expiry = 2 * 60; // 120 min 
mySession = "";

//if no session whatsoever, check if we're on the homepage, if not always redirect
if ( 
		 !structKeyExists( url, "transact_id" ) 
	&& !structKeyExists( form, "transact_id" )
	&& !structKeyEXists( session, "iv_sess_id" )
	)
{

	//If anyhthing but the homepage, redirect the user to the homepage and select some options
	if ( data.page neq "default" ) {
		//Redirect home to start the process	
		location( link( "" ) );
	}
	
	else {	
		//Create a new session key and write it to the session database as well.
		session.iv_motrpac_transact_id = randnum( 8 );
		mySession = session.iv_motrpac_transact_id;
		sessionDidntExist = 1;
	}
}
</cfscript>

<cfif sessionDidntExist eq 1>
<cfquery name="writeToSession" datasource=#data.source#>
	INSERT INTO 
		ac_mtr_participant_transaction_set
	VALUES (
		<cfqueryparam value="#mySession#" cfsqltype="CF_SQL_INT">
	 ,<cfqueryparam value="#staffId#" cfsqltype="CF_SQL_INT">
	 ,<cfqueryparam value="#expiry#" cfsqltype="CF_SQL_INT">
	 ,<cfqueryparam value="#DateTimeFormat( Now(), "YYYY-MM-DD" )#" cfsqltype="CF_SQL_DATETIME">
	);
</cfquery>
</cfif>


<cfscript>
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

	//writeoutput( "<div class='campy-hidden'>Using Session ID from POST</div>" );
}
</cfscript>
