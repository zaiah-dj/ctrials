<cfscript>
//Include all CFCs first hereq
include "globals.cfm";
ajax  = CreateObject( "component", "components.writeback" );
ezdb  = CreateObject( "component", "components.quella" );
rl    = CreateObject( "component", "components.requestLogger" );
cf    = CreateObject( "component", "components.checkFields" );
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
val   = CreateObject( "component", "components.validate" );

//val.validate( {}, {} );
ezdb.setDs( datasource = "#data.source#" );

//Set labels from over here somewhere
ENDURANCE = "ADUEndur,ATHEndur,ADUEnddur";
RESISTANCE = "ADUResist,ATHResist";
CONTROL = "ADUControl";
//writedump( ListContains( ENDURANCE, "ADUEndur" ) );

//Always start new weeks on Sunday
if ( isDefined( "url.startDate" ) && StructKeyExists( url, "startDate" ) ) {
	startDate = url.startDate;
}
else {
	startDate = DateTimeFormat( createDate( 2018, 5, 13 ), "YYYY-MM-DD" );
}

//Current date
if ( isDefined( "url.date" ) && StructKeyExists(url, "date") ) {
	try {
		date = DateTimeFormat( url.date, "YYYY-MM-DD HH:nn:ss" );

		if ( DateDiff( "ww", startDate, date ) < 0 ) {
			date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
		}	
	}
	catch (any e) {
		date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
	}
}
else {
	date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
}

//Current Week should also be carried through the whole app.
currentWeek = DateDiff( "ww", startDate, date ) + 1;
currentDay = DayOfWeek( Now() ); 
currentDayName = DateTimeFormat( Now(), "EEE" ); 


//Session detection and initialization (if need be)
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

//Get the last session key in the browser or make a new one.
if ( StructKeyExists( session, "iv_motrpac_transact_id" ) ) 
	sess.key = session.iv_motrpac_transact_id;
else {
	session.iv_motrpac_transact_id = randstr( 5 ) & randnum( 10 ) & randstr( 5 );
	sess.key = session.iv_motrpac_transact_id; 
}

sess.status = 2;
//writedump( session );abort;

//get the data from the session
cs = ezdb.exec(
	datasource = "#data.source#"
 ,string = "SELECT * FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :sid"
 ,bindArgs = { sid = sess.key }
);

//if there is no record of a current session, time to write it in
if ( !cs.prefix.recordCount ) {
	ds = ezdb.exec(
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
	//DateDiff
	unixTime = DateDiff( "s", CreateDate(1970,1,1), CreateODBCDateTime(Now()));
	updateTime = DateDiff( "s", CreateDate(1970,1,1), cs.results.p_lastUpdateTime);
	timePassed = unixTime - updateTime;

	/*
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
	*/
	if ( data.debug eq 3 ) abort;

	//after 2 hours (or whatever expireTime is), the session needs to completely expire
	if ( superExpire neq -1 && timePassed >= expireTime ) {
		//writeoutput( "#expireTime# seconds have passed.  Kill the session..." );abort;
		if ( StructKeyExists( session, "iv_motrpac_transact_id" ) ) {
			//really doesn't matter if this fails.
			ezdb.exec( 
			  string="DELETE FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :sid" 
			 ,bindArgs={sid=session.iv_motrpac_transact_id}
			);
			StructDelete( session, "iv_motrpac_transact_id" );
		}

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
		ds = ezdb.exec( 
			string = "UPDATE ac_mtr_participant_transaction_set
				SET p_lastUpdateTime = :dut
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
			throw "DEATH AT SESSION UPDATE - #ds.message#";
		}
	}
}

//Logic to get the most current ID.
currentId = 0;

//If an ID is specified in the URL or in POST (POST getting preference), then it is the current one
if ( StructKeyExists( form, "pid" ) )
	currentId = form.pid;	
else if ( StructKeyExists( url, "id" ) )
	currentId = url.id;
else {
	//Get the newest one
	if ( !isDefined("sess.key" ) )
		currentId = 0;
	else { 
		currentId = ezdb.exec(
			string = "SELECT 
				TOP 1 active_pid 
			FROM 
				#data.data.sessionTable#
			WHERE
				session_id = :sid
			"
		 ,bindArgs = {
				sid = sess.key
			}
		).results.active_pid;
	}
}

//Recall the last valid session data
try {
	//Select from the progress table and use this to prefill fields that don't exist
	p = ezdb.exec( 
		string = 
		"SELECT * FROM
			#data.data.sessionTable#	
		 WHERE
			active_pid = :pid 
		 AND
			session_id = :sid"
	 ,bindArgs = {
			pid = currentId
		 ,sid = sess.key
		}
	);

	//There was an error
	if ( !p.status ) {
		writedump( p );
		abort;
	}

	old_ws = {};
	
	//Deserialize the old records
	if ( p.prefix.recordCount ) {
		old_ws = DeserializeJSON( p.results.misc );
	}
}
catch (any e) {
	req.sendAsJSON( status = 0, message = "#e.message#" );
	abort;
}
/*
//Initialize the session variables
session.ps_day = StructKeyExists( form, "ps_day") ? form.ps_day : session.ps_day ;
session.ps_week = StructKeyExists( form, "ps_week") ? form.ps_week : session.ps_week ;
session.ps_next_sched = StructKeyExists( form, "ps_next_sched") ? form.ps_next_sched : session.ps_next_sched ;
session.staffer_id = StructKeyExists( form, "ps_day") ? form.ps_day : session.ps_day ;
session.id = StructKeyExists( url, "id") ? url.id : session.id ;
session.extype = StructKeyExists( url, "extype") ? url.extype : session.extype ;
session.time = StructKeyExists( url,  "time") ? url.time : session.time ;
session.location = "#cgi.script_name#?#cgi.query_string#";
*/

session[ "#session.iv_motrpac_transact_id#" ] = {
	//
	date  = 0	
	//
 ,day   = 3
	//Current user start week
 ,sweek = 0
	//Current user current week
 ,cweek = 0
	//Where was the user last located?
 ,location = "#cgi.script_name#?#cgi.query_string#"
	//What exercise has been selected last?
 ,exerciseType = 0
	//Who is logged in and doing work?
 ,session_id = 0
	//When is the next scheduled sesssion (and why does this matter?)?
 ,ps_next_sched = 0
};
</cfscript>
