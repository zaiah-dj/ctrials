<cfscript>
/* ---------------------------------------- *
This session handling module checks for the 
existence of a valid session for both actual
users and API bots

	exists = 1 
		Does an active session exist or not?

	status = 0       
		0 - nothing was there, and something went wrong
		1 - nothing was there, CF created a new one
		2 - something is available, and the session is in CF's session scope
		3 - something is available, and the session key is coming from GET 
		4 - something is available, and the session key is coming from POST

	elapsed = 0
		How many seconds have elapsed since session was started

	staffId = 0
		Remove this...

	expiresAfterInactive = n
		How long should this session last?

	key     = ""

	message = ""	

 * ---------------------------------------- */
sess = {
	 key = 0
	,exists = 1
	,status = 0
	,elapsed = 0
	,message = 0
	,staffId = 0
	,expiresAfterInactive = 2 * 60 * 60
};



//if no session whatsoever, check if we're on the homepage, if not always redirect
if ( !structKeyExists( session, "iv_motrpac_transact_id" ) && !structKeyExists( url, "transact_id" ) && !structKeyExists( form, "transact_id" )  ) {
	//If on anything but the homepage, redirect the user to the homepage and select some options
	if ( data.page neq "default" )
		location( link( "expired.cfm?reasonCode=1" ) );
	else {
		//Create a new session key and write it to the session database as well.
		sess.key    = randnum( 8 ); 
		sess.status = 1;
		sess.exists = 0;
		session.iv_motrpac_transact_id = sess.key; 

		//Write the new session key to database
		today = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
		stmt = "INSERT INTO ac_mtr_participant_transaction_set VALUES ( :sv, :exp, :ctime, :utime )";
		qq = new Query( dataSource = "#data.source#", name = "writeToSession" );
		qq.addParam( name="sv", value="#sess.key#", cfsqltype="cf_sql_int" );
		qq.addParam( name="exp", value="1", cfsqltype="cf_sql_int");
		qq.addParam( name="ctime", value=today, cfsqltype="cf_sql_datetime");
		qq.addParam( name="utime", value=today, cfsqltype="CF_SQL_DATETIME");
		qq.execute( sql = stmt );
	}
}

if ( structKeyExists( session, "iv_motrpac_transact_id" ) ) 
	{ sess.status = 2; sess.message = "Session auth came from session scope."; sess.key = session.iv_motrpac_transact_id; }
else if ( structKeyExists( url, "transact_id" ) )
	{ sess.status = 3; sess.message = "Session auth came from URL scope."; sess.key = url.transact_id; session.iv_motrpac_transact_id = sess.key; }
else if ( structKeyExists( form, "transact_id" ) ) { 
	sess.status = 4; 
	sess.message = "Session auth came from FORM scope."; 
	sess.key = form.transact_id; 
	session.iv_motrpac_transact_id = sess.key;
}

//if ( !sess.status ) { //redirect the user, cuz there is nothing //we should never get here...  location( link( "/" ) ); } //Get the session key and status
stmt = "SELECT * FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :ptid";
qq = new Query( dataSource = "#data.source#", name = "checkForSession" );
qq.addParam( name="ptid", value="#sess.key#", cfsqltype="cf_sql_int" );
qr = qq.execute( sql = stmt );
sess.usersmatched = qr.getPrefix( ).recordCount;
sess.query = qr.getResult( );
writeoutput( sess.query.p_currentdatetime );

if ( sess.usersmatched == 0 ) {
	//redirect because most likely someone is sending bogus data.
	sess.status = 0;
	sess.message = "This session looks completely invalid.";
	location( link( "expired.cfm?reasonCode=2" ) );
}

if ( sess.usersmatched > 1 )  {
	//I really should invalidate all the keys in this case
	sess.status = 0;
	sess.message = "This session looks completely invalid.";
	location( link( "expired.cfm?reasonCode=3" ) );
}

unix_now = DateDiff( "s", CreateDate( 1970, 1, 1 ), CreateODBCDatetime( Now() ) );
unix_lastModified = DateDiff( "s", CreateDate( 1970, 1, 1 ), sess.query.p_lastUpdateTime ); 

//retire the session if too much time has passed...
if ((unix_now - unix_lastModified) >= sess.expiresAfterInactive ) {
	if ( 1 ) {
		sess.status = 0;
		sess.message = "This session key is now completely invalid.";
		stmt = "DELETE FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :ptid";
		sq = new Query( dataSource="#data.source#", name="killSession" );
		sq.addParam( name="ptid", value="#sess.key#", cfsqltype="cf_sql_int" );
		sq.execute( sql = stmt ); 
		if ( StructKeyExists( session, "iv_motrpac_transact_id" ) ) {
			StructDelete( session, "iv_motrpac_transact_id" );
		}
		//redirect the user and let them know that credentials are done
		location( link( "expired.cfm?reasonCode=4" ) );
	}
	else {
		0;  //This should also be able to handle API calls.  Unsure of how to handle that yet...
	} 
}
</cfscript>
