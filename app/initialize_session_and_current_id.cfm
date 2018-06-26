<cfscript>
//Include all CFCs first hereq
ajax  = CreateObject( "component", "components.writeback" );
ezdb  = CreateObject( "component", "components.quella" );
rl    = CreateObject( "component", "components.requestLogger" );
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
val   = CreateObject( "component", "components.validate" );
exe   = CreateObject( "component", "components.exercises" ).init();

//val.validate( {}, {} );
ezdb.setDs( datasource = "#data.source#" );


//Set labels from over here somewhere
ENDURANCE_CLASSIFIERS = "ADUEndur,ATHEndur,ADUEnddur";
RESISTANCE_CLASSIFIERS = "ADUResist,ATHResist";
CONTROL_CLASSIFIERS = "ADUControl";

ENDURANCE = "ADUEndur,ATHEndur,ADUEnddur";
RESISTANCE = "ADUResist,ATHResist";
CONTROL = "ADUControl";

E = 1;
R = 2;
C = 3;

//Always start new weeks on Sunday
startDate = ( isDefined( "url.startDate" ) && StructKeyExists( url, "startDate" ) ) 
	? url.startDate : DateTimeFormat( createDate( 2018, 5, 13 ), "YYYY-MM-DD" );

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


//Get participant data 
currentParticipant = ezdb.exec( 
	string = "SELECT * FROM #data.data.participants# WHERE participantGUID = :pid"
 ,bindArgs = { pid = currentId }
);


//If a current ID is initialized, figure out which group they belong to
randomCode = currentParticipant.results.randomGroupCode;


//If nothing is selected, these queries ought to be empty queries
if ( sess.status gt 1 ) {
	selectedParticipants = ezdb.exec( 
		string = "
		SELECT
			*
		FROM
		( SELECT 
				p_pid, p_participantGUID
			FROM 
				#data.data.sessionMembers#	
			WHERE 
				p_transaction_id = :sid	
		) AS CurrentTransactionIDList
		LEFT JOIN
		( SELECT
				* 
			FROM 
				#data.data.participants#	
		) AS amp
		ON CurrentTransactionIDList.p_participantGUID = amp.participantGUID;
		"
		,bindArgs = {
			sid = sess.key
		}	
	);

	unselectedParticipants = ezdb.exec( 
		string = "
		SELECT * FROM 
			#data.data.participants# 
		WHERE participantGUID NOT IN (
		  SELECT DISTINCT p_participantGUID FROM 
				#data.data.sessionMembers#	
			WHERE 
				p_transaction_id = :sid 
		) ORDER BY lastname ASC"
	 ,bindArgs = {
			sid = sess.key
		}
	);
}


//Select a week
week = 0;
if ( StructKeyExists( form, "ps_week" ) )
	week = form.ps_week;
else if ( StructKeyExists( url, "week" ) )
	week = url.week;
else if ( StructKeyExists( session, "#session.iv_motrpac_transact_id#" ) ) {
	if ( StructKeyExists( session[ "#session.iv_motrpac_transact_id#" ], "week" ) ) {
		week = session[ "#session.iv_motrpac_transact_id#" ][ "week" ];
	}
}

//Select an exercise type 
ep = 0;
//writedump( form.param );abort;
if ( StructKeyExists( form, "param" ) )
	ep = form.param;
else if ( StructKeyExists( url, "param" ) )
	ep = url.param;
else if ( StructKeyExists( session, "#session.iv_motrpac_transact_id#" ) ) {
	if ( StructKeyExists( session[ "#session.iv_motrpac_transact_id#" ], "exerciseParameter" ) ) {
		ep = session[ "#session.iv_motrpac_transact_id#" ][ "exerciseParameter" ];
	}
}


//Generate record threads here for writing and saving
//recordThread = ezdb.exec( string = "SELECT newID() as newGUID" ).results.newGUID;
/*
if ( StructKeyExists( form, "param" ) )
	ep = form.param;
else if ( StructKeyExists( url, "param" ) )
	ep = url.param;
else 
*/
if ( StructKeyExists( session, "#session.iv_motrpac_transact_id#" ) ) {
	sts =  session[ "#session.iv_motrpac_transact_id#" ];
	if ( StructKeyExists( sts, "recordThreads" ) && !StructIsEmpty( sts["recordThreads"]  ) ) {
		recordThreads = sts[ "recordThreads" ];
	}
	else {
		recordThreads = {};
		if ( isDefined("selectedParticipants") ) {
			for ( iid in ListToArray( ValueList(selectedParticipants.results.p_participantGUID, ", ") ) ) {
				recordThreads[ iid ] = ezdb.exec( string = "SELECT newID() as newGUID" ).results.newGUID;
			}
		}
	}
}


//Here is a way to calculate the exercise type from the beginning of the script, 
//(versus having to compare against ENDURANCE_CLASSIFIERS all over the application)
if ( ep gt 0 ) {
//	exerciseList = exe.getSpecificExercises( ep );	
	if ( ListContains( ENDURANCE_CLASSIFIERS, randomCode ) ) {
		//exerciseList = exe.getSpecificExercises( ep );	
	} 
}


//Prepare the session last. TODO: Need a way to tell where the user is coming from... session won't set but could crash during an XHR...
session[ "#session.iv_motrpac_transact_id#" ] = {
	//The day that the session is currently modifying
  day = DayOfWeek( Now() )

	//The proper name of the day that the session is currently modifiying
 ,dayName = DateTimeFormat( Now(), "EEE" )

	//The week that the session is currently modifying
 ,week = week 

	//Where was the user last located?
 ,location = "#cgi.script_name#?#cgi.query_string#"

	//Randomized type
  //,randomizedType = ( randomCode eq "" ) ? 0 : (ListContains( ENDURANCE_CLASSIFIERS, randomCode ) ? E : R)
 ,randomizedType = (!isDefined("currentParticipant")) ? 0 : ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) ? E : R

	//Randomized type
 ,randomizedTypeName = (!isDefined("currentParticipant")) ? 0 : ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) ? "Endurance" : "Resistance" 
 //,randomizedTypeName = (randomCode eq "") ? 0 : ( ListContains( ENDURANCE_CLASSIFIERS, randomCode ) ) ? "Endurance" : "Resistance"

	//What exercise has been selected last?
 ,exerciseParameter = ep

	//The ID of the session identifier
 ,sessId = session.iv_motrpac_transact_id

	//Show the exercises selected
 //,exerciseListName = (isDefined("exerciseList")) ? ValueList(selectedParticipants.results.p_participantGUID, ", ") : ""

	//Who is logged in and doing work?
 ,staffId = 0

	//What members are currently part of this session?
 ,participantList = (isDefined("selectedParticipants")) ? ValueList(selectedParticipants.results.p_participantGUID, ", ") : ""

	//Participant ID
 ,participantId = currentId

	//List of record threads in use
 ,recordThreads = (isDefined("recordThreads")) ? recordThreads : {}
};


//sess.current
sess.current = session[ "#session.iv_motrpac_transact_id#" ];

//There will realistically only be one at a time...
sess.current.recordThread = 
	( StructKeyExists( sess.current.recordThreads, sess.current.participantId ) ) ?
	StructFind( sess.current.recordThreads, sess.current.participantId ) : 0 ;

//Now, get specific and initialize other things
if ( data.loaded eq "check-in" ) {
	//select days from this week with results (including today?)
	tbName = ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) 
		? "#data.data.endurance#" : "#data.data.resistance#";

	//Get the last blood pressure
	privateBPQ = ezdb.exec( 
		string="SELECT * FROM #data.data.bloodpressure# WHERE bp_pid = :pid", 
		bindArgs = { pid = "#sess.current.participantId#" } 
	).results;

	//Blood pressure calculations
	privateBPDaysLimit = 30;
	privateBPDaysElapsed = ( privateBPQ.bp_daterecorded eq "" ) ? 0 : DateDiff( "d", privateBPQ.bp_daterecorded, Now() ); 
	privateReBP = ( privateBPQ.bp_daterecorded eq "" || privateBPDaysElapsed gt privateBPDaysLimit ); 

	//Get the last recorded weight
	weight = ezdb.exec( 
	  string="
			SELECT weight FROM #tbName# 
			WHERE 
				recordthread = :thr
			AND
				participantGUID = :pid 
		"
	 ,bindArgs = { 
			pid = { type = "varchar", value = sess.current.participantId },
			thr = { type = "varchar", value = sess.current.recordThread  }
		}
	).results.weight;

	if ( !ListContains(ENDURANCE, currentParticipant.results.randomGroupCode) )
		targetHR = 0;
	else {
		//Get the last recorded weight
		targetHR = ezdb.exec( 
			string="SELECT trgthr1 FROM #tbName# 
				WHERE recordthread = :thr AND participantGUID = :pid "
		 ,bindArgs = { 
				pid = { type = "varchar", value = sess.current.participantId },
				thr = { type = "varchar", value = sess.current.recordThread  }
			}
		).results.trgthr1;
	}

	//Check in
	checkIn = {
		//Blood pressure
		//Do I need a new blood pressure?
		 getNewBP = privateReBP
		,BPDaysLeft = privateBPDaysLimit - privateBPDaysElapsed
		,BPSystolic = (privateReBP) ? 40 : privateBPQ.bp_systolic
		,BPDiastolic = (privateReBP) ? 40 : privateBPQ.bp_diastolic
		,BPMinSystolic = 40  
		,BPMaxSystolic = 160
		,BPMinDiastolic = 40
		,BPMaxDiastolic = 90

		//Target Heart Rate
		,targetHR = ( targetHR eq "" || targetHR eq 0 ) ? 0 : targetHR

		//Weight
		,weight = ( weight eq "" || weight eq 0 ) ? 0 : weight

		//Completed days array
		,cdays = [0,0,0,0,0,0]

		//Query completed days
		,qCompletedDays = ezdb.exec(
			string="SELECT dayofwk FROM #tbName# 
				WHERE participantGUID = :pid AND stdywk = :wk"
		 ,bindArgs={ pid=sess.current.participantId, wk=sess.current.week }
		)

		//Exercise list
		,elist = CreateObject( "component", "components.exercises" ).init()
	};

	//...
	for ( n in ListToArray( ValueList( checkIn.qCompletedDays.results.dayofwk, "," ) ) ) {
		checkIn.cdays[ n ] = n; 
	}

	//...
	pNotes = ezdb.exec(
		string = "
			SELECT
				note_datetime_added	
			 ,note_text	
			FROM 
				#data.data.notes#	
			WHERE 
				note_participant_match_id = :pid
			ORDER BY note_datetime_added DESC
			"
	 ,datasource = "#data.source#" 
	 ,bindArgs = {
			pid = sess.current.participantId 
		});

	if ( !pNotes.status ) {
		writedump( pNotes.message );
		abort;	
	}	
}
</cfscript>
