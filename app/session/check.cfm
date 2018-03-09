<cfscript>
//StructDelete( session, "iv_motrpac_transact_id" );
//Global stuff...
sessionDidntExist = 0;
sessionElapsed = 0;
staffId = 0;  //Just made up right now
expiry = 2 /*hours*/ * 60 /*min*/ * 60 /*secs*/; // 120 min 
expirySecs = 2 /*hours*/ * 60 /*min*/ * 60 /*secs*/; // 120 min 
mySession = "";
sessionStatus = 0;
sessionMessage = 0;

//if no session whatsoever, check if we're on the homepage, if not always redirect
if ( 
		 !structKeyExists( url, "transact_id" ) 
	&& !structKeyExists( form, "transact_id" )
	&& !structKeyEXists( session, "iv_motrpac_transact_id" )
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
		sessionStatus = 1;
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
	 ,<cfqueryparam value="1" cfsqltype="CF_SQL_INT">
	 ,<cfqueryparam value="#DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" )#" cfsqltype="CF_SQL_DATETIME">
	 ,<cfqueryparam value="#DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" )#" cfsqltype="CF_SQL_DATETIME">
	);
</cfquery>

<cfelse>
	<cfscript>
	checkSessionVar = "";

	//Always choose session first, because this is most likely a real user...
	if ( structKeyExists( session, "iv_motrpac_transact_id" ) ) {
		sessionStatus = 2;
		sessionMessage = "Session previously generated.  So it's safe to use.";
		checkSessionVar = session.iv_motrpac_transact_id; 
	}

	else if ( structKeyExists( url, "transact_id" ) ) {
		sessionStatus = 3;
		sessionMessage = "Session auth came from URL scope.  Check against db.";
		checkSessionVar = url.transact_id; 
	}

	else if ( structKeyExists( form, "transact_id" ) ) {
		sessionStatus = 4;
		sessionMessage = "Session auth came from POST submittal.  Check against db.";
		checkSessionVar = form.transact_id; 
	}
	</cfscript>

	<cfif sessionStatus eq 0>
		<!--- This is a failure.  Either someone is trying to hijack the session or something else --->
		sessionMessage = "Session failed to authenticate."
	<cfelse>
		<!--- Check for an unexpired key. --->
		<cfquery name="checkForSession" datasource=#data.source#>
			SELECT * FROM 
				ac_mtr_participant_transaction_set 
			WHERE
				p_transaction_id = <cfqueryparam value="#checkSessionVar#" cfsqltype="CF_SQL_INT">
		</cfquery>

		<!--- Check that a result was returned. --->
		<cfscript>
		if ( checkForSession.recordCount eq 0 || checkForSession.recordCount gt 1 )
			sessionMessage = "No session found.";
		else { 
			unix_now = DateDiff("s", CreateDate(1970,1,1), CreateODBCDateTime(Now()));
			unix_lastModified = DateDiff("s", CreateDate(1970,1,1), checkForSession.p_lastUpdateTime );
			/*
			//Check that the key is not $expiry after last modified date.
			writeoutput( "session expiry" );
			writeoutput( expirySecs );
			//writeoutput( checkForSession.p_expire_time );
			writeoutput( "<br />" );
			writeoutput( "session inception" );
			writeoutput( checkForSession.p_currentDateTime );
			writeoutput( "<br />" );
			writeoutput( "session last modified" );
			writeoutput( checkForSession.p_lastUpdateTime );
			writeoutput( "<br />" );
			writeoutput( "session l/m - current time" );
			writeoutput( unix_now - unix_lastModified ); 
			writeoutput( "<br />" );
			writeoutput( "now" );
			writeoutput( Now() );
			writeoutput( "<br />" );
			*/

			//Sux...
			if ( unix_now - unix_lastModified < expirySecs ) 
				mySession = checkSessionVar;
			else {
				//Invalidate the session key if we're a user browsing
				if ( 0 ) {
					include "kill.cfm";	
					//The user would simply have to login again at this point, is there a way to say that?
					sessionStatus = 0;
					sessionMessage = "Looks like this session key is invalid.";
				}
				//Send back an invalid key code if this is an API call
				else {
					sessionStatus = 0;
					sessionMessage = "Looks like this session key is invalid.";
				}
			}
		
			//The user would technically need to login again or something...	
			//session.iv_motrpac_transact_id = randnum( 8 );
			//mySession = session.iv_motrpac_transact_id;
			//sessionDidntExist = 1;
			//sessionStatus = 1;
		}
		</cfscript>

	</cfif>

</cfif>
