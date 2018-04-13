<cfscript>
qu = createObject( "component", "components.quella" );
expireTime = 60 /*secs*/ * 60 /*minutes*/ * 2 /*hours*/;
refreshTime = 60 /*secs*/ * 15 /*minutes*/; 
refreshTime = 20;
superExpire = -1;
sess = {
	 key = 0
	,exists = 1
	,needsRefresh = 0
	,status = 0
	,elapsed = 0
	,message = 0
	,staffId = 0
	,expiresAfterInactive = 2 * 60 * 60
};

//Here are some controls that might help me test
if ( data.debug eq 1 ) {
	refreshTime = (StructKeyExists( url, "refreshTime" )) ? url.refreshTime : refreshTime;
	expireTime = (StructKeyExists( url, "expireTime" )) ? url.expireTime : expireTime;
}

//Check if the user is in a staff database...

//Get the last session key in the browser or make a new one.
if ( StructKeyExists( session, "iv_motrpac_transact_id" ) ) 
	sess.key = session.iv_motrpac_transact_id;
else {
	session.iv_motrpac_transact_id = randstr( 5 ) & randnum( 10 ) & randstr( 5 );
	sess.key = session.iv_motrpac_transact_id; 
}

sess.status = 2;

//get the data from the session
cs = qu.exec(
	datasource = "#data.source#"
 ,string = "SELECT * FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :sid"
 ,bindArgs = { sid = sess.key }
);

//if there is no record of a current session, time to write it in
if ( !cs.prefix.recordCount ) {
	ds = qu.exec(
		datasource = "#data.source#"
	 ,string = "INSERT INTO ac_mtr_participant_transaction_set VALUES ( :sid, :cdt, :lut, 0, NULL )"
	 ,bindArgs = { 
			sid = sess.key 
		 ,cdt = { value=DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" ),type="cf_sql_datetime"}
		 ,lut = { value=DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" ),type="cf_sql_datetime"}
		}
	);
}
else {
	writeoutput("session = " & session.iv_motrpac_transact_id); 
	writeoutput("check dot cfm, user said yes, we should be here...");
	/*
	abort;
	*/

	//DateDiff
	unixTime = DateDiff( "s", CreateDate(1970,1,1), CreateODBCDateTime(Now()));
	updateTime = DateDiff( "s", CreateDate(1970,1,1), cs.results.p_lastUpdateTime);
	timePassed = unixTime - updateTime;

	//This is all here in case you forget how to do math.
	writeoutput( 'Unix Time: ' & unixTime );
	writeoutput( "<br />" );
	writeoutput( 'Update Time: ' & updateTime );
	writeoutput( "<br />" );
	writeoutput( 'Time Passed: ' & timePassed );
	writeoutput( "<br />" );
	writeoutput( 'Time Passed in Seconds: ' & timePassed & " secs" );
	writeoutput( "<br />" );
	writeoutput( 'Time Passed (minutes): ' & ( timePassed / 60 ) & " minutes" );
	writeoutput( "<br />" );
	writeoutput( 'Time passed (hours): ' & (( timePassed / 60 ) / 60 ) & " hours" );
	if ( data.debug eq 3 ) abort;

	//after 2 hours (or whatever expireTime is), the session needs to completely expire
	if ( superExpire neq -1 && timePassed >= expireTime ) {
		//writeoutput( "#expireTime# seconds have passed.  Kill the session..." );abort;
		if ( StructKeyExists( session, "iv_motrpac_transact_id" ) ) {
			//really doesn't matter if this fails.
			qu.exec( 
				datasource="#data.source#"
			 ,string="DELETE FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :sid" 
			 ,bindArgs={sid=session.iv_motrpac_transact_id}
			);
			StructDelete( session, "iv_motrpac_transact_id" );
		}

		writeoutput( "Did I get here?" );
		abort;

		//This staff member needs to run checkin again
		location( url="#link( '' )#", addtoken="no" );
	}

	//after 15 min, THIS page needs to trigger a desire for credentials. 
	else if ( refreshTime neq -1 && timePassed >= refreshTime ) {
		//writeoutput( "#refreshTime# seconds have passed.  Refresh the session..." );abort;
		sess.needsRefresh = 1;
		//
		//location( url="#link( 'stale.cfm' )#", addtoken="no" );
	}

	//if neither of these has happened, then update the lastMod field in transaction_set
	else {
		ds = qu.exec( 
			string = "UPDATE ac_mtr_participant_transaction_set
				SET p_lastUpdateTime = 
				WHERE p_transaction_id = :sid",
			bindArgs = {
				sid = sess.key 
			 ,dut = { 
				 type  = "cf_sql_datetime"
			 	,value = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" ) 
				}
			}
		);

		//If this fails, it's kind of a problem...
		if ( !ds.status ) {
			0;
			throw "DEATH TO ALL!";
		}
	}
}
</cfscript>
