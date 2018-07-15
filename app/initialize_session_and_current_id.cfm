<cfscript>
//Include all CFCs first hereq
ajax  = CreateObject( "component", "components.writeback" );
ezdb  = CreateObject( "component", "components.quella" );
rl    = CreateObject( "component", "components.requestLogger" );
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
val   = CreateObject( "component", "components.validate" );
endobj= CreateObject( "component", "components.endurance" ).init();
resobj= CreateObject( "component", "components.resistance").init();


//Set a datasource for all things
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


try {
//Current date

//Make a date object first and just use that...

if ( isDefined( "url.date" ) && StructKeyExists(url, "date") ) {
	try
		{ usedDate = DateTimeFormat( url.date, "YYYY-MM-DD HH:nn:ss" ); }
	catch (any e) {
		usedDate = Now(); //DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
	}
}
else {
	usedDate = Now(); //DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
}


currentDayOfWeek = DayOfWeek( usedDate );
currentDayOfWeekName = DateTimeFormat( usedDate, "EEE" );
currentDayOfMonth = DateTimeFormat( usedDate, "d" );
currentMonth = DateTimeFormat( usedDate, "m" );
currentYear = DateTimeFormat( usedDate, "YYYY" );
currentWeek = DateTimeFormat( usedDate, "w" );
}
catch (any ee) {
	writedump( ee );
	abort;
}
/*
writedump( "currentDayOfWeek: " & currentDayOfWeek );
writedump( "currentDayOfMonth: " & currentDayOfMonth );
writedump( "currentMonth: " & currentMonth );
writedump( "currentYear: " & currentYear );
writedump( "currentDayName: " & currentDayName );
writedump( "currentWeek: " & currentWeek );
writedump( usedDate );
abort;
*/


//Set a site ID from here
staffId = 0;
if ( StructKeyExists( form, "setstaffid" ) ) {
	staffId = form.setstaffid;
	session.userguid = staffId;
}
else if ( StructKeyExists( url, "staffid" ) ) {
	staffId = url.staffid;
	session.userguid = staffId;
}
else {
	if ( !isDefined( "session.userguid" ) ) {
		//if (data.loaded eq "input"){writeoutput( "<h2>session.userguid is not defined</h2>" );abort;}
		session.userguid = "CLWWBZGS";
		staffId = session.userguid;
		//No default will be set if no guid exists, just redirect and get credentials again
	}
	else {
		//if (data.loaded eq "input"){writeoutput( "<h2>session.userguid defined and is '#session.userguid#'</h2>" );abort;}
		staffId = session.userguid;
	}
}


//Logic to get the most current ID.
currentId = 0;
if ( StructKeyExists( form, "pid" ) )
	currentId = form.pid;	
else if ( StructKeyExists( url, "id" ) )
	currentId = url.id;
else {
}


//Logic to get the most current ID.
siteId = 0;
if ( StructKeyExists( url, "siteid" ) )
	siteId = url.siteid;
else {
	siteId = 999;	
	/*
	if ( StructKeyExists( session, "siteid" ) )
		siteId = session.siteid;
	else {
		//Why would this not be set?
		session.siteid;
	}
	*/
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
if ( StructKeyExists( session, "ivId" ) ) 
	sess.key = session.ivId;
else {
	session.ivId = randstr( 5 ) & randnum( 10 ) & randstr( 5 );
	sess.key = session.ivId; 
}

sess.status = 2;
//writedump( session );abort;

//Look for a matching key of some sort.
csQuery = ezdb.exec(
	datasource = "#data.source#"
 ,string = "
		SELECT 
			sm_sessdayid as sid 
		 ,sm_datetimestarted as sdate 
		FROM 
			#data.data.sessiondappl# 
		WHERE 
			sm_dayofweek = :dayofwk
		AND
			sm_siteid    = :siteid	
	"
 ,bindArgs = { 
		siteid  = siteId
	 ,dayofwk = currentDayOfWeek
	}
);


csDate = csQuery.results.sdate;
csSid = csQuery.results.sid;

//if there is no record of a current session, time to write it in
if ( csDate eq "" || csSid eq "" ) { 
	csQuery = ezdb.exec(
	  string = "
			INSERT INTO #data.data.sessiondappl# 
				( sm_siteid, sm_dayofweek, sm_dayofmonth, sm_month, sm_year )
			VALUES
				( :site_id , :dayofwk    , :dayofmonth  , :month  , :year   )
		"  
	 ,bindArgs = { 
		  site_id = siteId 
		 ,dayofwk = currentDayOfWeek
		 ,dayofmonth = currentDayOfMonth
		 ,month = currentMonth
		 ,year = currentYear
		}
	);

	//re-run query and get the data I want
	csQuery = ezdb.exec(
		datasource = "#data.source#"
	 ,string = "
			SELECT 
				sm_sessdayid as SID 
			 ,sm_datetimestarted as sdate 
			FROM 
				#data.data.sessiondappl# 
			WHERE 
				sm_dayofweek = :dayofwk
			AND
				sm_siteid    = :siteid	
		"
	 ,bindArgs = { 
			siteid  = siteId
		 ,dayofwk = currentDayOfWeek
		 ,dayofmonth = currentDayOfMonth
		 ,month = currentMonth
		 ,year = currentYear
		}
	);

	csDate = csQuery.results.sdate;
	csSid = csQuery.results.sid;
}
else { 
	unixTime = DateDiff( "s", CreateDate(1970,1,1), CreateODBCDateTime(Now()));
	updateTime = DateDiff( "s", CreateDate(1970,1,1), csQuery.results.sdate );
	timePassed = unixTime - updateTime;
	/*
	//DateDiff

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

	//after 2 hours (or whatever expireTime is), the session needs to completely expire
	if ( superExpire neq -1 && timePassed >= expireTime ) {
		//writeoutput( "#expireTime# seconds have passed.  Kill the session..." );abort;
		if ( StructKeyExists( session, "ivId" ) ) {
			//really doesn't matter if this fails.
			ezdb.exec( 
			  string="DELETE FROM #data.data.sessiondappl# WHERE p_transaction_id = :sid" 
			 ,bindArgs={sid=session.ivId}
			);
			StructDelete( session, "ivId" );
		}

		//This staff member needs to run checkin again
		location( url="#link( '' )#", addtoken="no" );
	}
	*/
	if ( 0 ) {
		;
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
		/*
		ds = ezdb.exec( 
			string = "
			UPDATE 
				#data.data.sessiondappl#
			SET 
				p_lastUpdateTime = :dut
			WHERE 
				p_transaction_id = :sid",
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
		*/
	}
}



//Check if the staff member has been logged in as well
stf = ezdb.exec( 
	string = "
		SELECT 
			ss_id,
			ss_sessdayid,
			ss_staffid,
			ss_staffsessionid,
			ss_participantrecordkey,
			ss_datelastaccessed
		FROM 
			#data.data.sessiondstaff# 
		WHERE
			ss_sessdayid = :sid
		AND
			ss_staffsessionid = :staff_ssid
		AND
			ss_staffid = :staff_id
	"
 ,bindArgs = { 
		sid = csSid 
	 ,staff_id = staffId
	 ,staff_ssid = session.ivId
	}
);


stfPrk = stf.results.ss_participantrecordkey;


//Make a record
if ( stf.results.ss_staffid eq "" ) {
	stf = ezdb.exec( 
		string = "
			INSERT INTO #data.data.sessiondstaff# 
				( ss_sessdayid
				 ,ss_staffid
				 ,ss_staffsessionid )
			VALUES 
				( :sessdayid
				 ,:staff_id
				 ,:staff_ssid )
		"
	 ,bindArgs = { 
		  sessdayid = csSid 
		 ,staff_id = staffId
		 ,staff_ssid = session.ivId
		}
	);

	stf = ezdb.exec( 
		string = "
			SELECT 
				ss_id,
				ss_sessdayid,
				ss_staffid,
				ss_staffsessionid,
				ss_participantrecordkey,
				ss_datelastaccessed
			FROM 
				#data.data.sessiondstaff# 
			WHERE
				ss_sessdayid = :sid
			AND
				ss_staffsessionid = :staff_ssid
			AND
				ss_staffid = :staff_id
		"
	 ,bindArgs = { 
			sid = csSid 
		 ,staff_id = staffId
		 ,staff_ssid = session.ivId
		}
	);

	stfPrk = stf.results.ss_participantrecordkey;
}



//Get participant data 
currentParticipant = ezdb.exec( 
	string = "SELECT * FROM #data.data.participants# WHERE participantGUID = :pid"
 ,bindArgs = { pid = { value = currentId, type="cf_sql_varchar" }}
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
		( SELECT * FROM
				#data.data.sessiondpart#	
			WHERE 
				sp_participantrecordkey = :prk
			AND
				sp_sessdayid = :sid
		) AS AssociatedParts 
		LEFT JOIN
		( SELECT
				* 
			FROM 
				#data.data.participants#	
		) AS amp
		ON AssociatedParts.sp_participantGUID = amp.participantGUID;
		"
		,bindArgs = {
			prk = stfPrk 
		 ,sid = csSid 
		}	
	);

	unselectedParticipants = ezdb.exec( 
		string = "
		SELECT * FROM 
			#data.data.participants# 
		WHERE participantGUID NOT IN (
		  SELECT DISTINCT sp_participantGUID FROM 
				#data.data.sessiondpart#	
			WHERE 
				sp_sessdayid = :sid
		) ORDER BY lastname ASC"
	 ,bindArgs = {
			sid = csSid 
		}
	);
}

/*
A full session ought to look like:

{
	id = <for reference only: the random ID that is now session.ivId>
	needsRebuild [boolean]      - defines whether or not to rebuild record thread table
	interventionist [ varchar ] - the current interventionist logged in for this session
	footprints [ table ]        - queue of the last five locations, ids and dates of use of app
	status [ integer ]          - can be used for anything (like rebuild etc)
	selected [ varchar ]        - the ID of the currently selected participant
	participants [ table ]      - list of participants and accompanying data
		[ <participantGUID> ]     = {
			checkInCompleted[ bool ]  - Check if check-in is done
			recoveryCompleted[ bool ] - Check if recovery is done
			lastExerciseCompleted [ int ] - The last exercise completed...
			lastLocation[ varchar ]   - The last location of the interventionist when working with this guy
			bpdata [ integer ]        -
			param [ integer ]         -
			rType [ integer ]         -
			rTypeName [ varchar]      -
			week [ integer ]          -
			dayname [ integer ]       -
			day [ integer ]           -
			getNewBP [ boolean ]      -
			BPDaysLeft [ integer ]    - 
			BPSystolic [ integer ]    - 
			BPDiastolic [ integer ]   - 
			BPMinSystolic [ integer ] - 
			BPMaxSystolic [ integer ] - 
			BPMinDiastolic [ integer ]- 
			BPMaxDiastolic [ integer ]- 
			targetHR [ integer ]      - 
			weight [ integer ]        - 
			exlist [ table ]          - List of exercises 	
		}
}
 */


//Pass in the current session ( session[ session.ivId ] )
/*
If SelectedParticipants is not defined, 
	most likely nothing has started, so return a blank table
If SelectedParticipants is defined, 
	then extract the GUIDs from the query
	create a table using participantSchema
	and match it as the value for the participant GUID
	you should have
	[ guid ] = ParticipantSchema
*/
//Build all record threads
function buildRecordThreads( t ) {
	if ( !StructKeyExists( t, "participants" ) ) { 
		t.participants = {};
		if ( isDefined( "selectedParticipants" ) ) {
			for ( p in selectedParticipants.results ) {
				//Create a key that can be referenced by the participant GUID
				cp = t.participants[ Trim( p.participantGUID ) ] = {};
				cp.recordThread = Trim( ezdb.exec( string = "SELECT newID() as newGUID" ).results.newGUID );
				cp.checkInCompleted = 0 ;
				cp.exerciseParameter = 0 ;
				cp.recoveryCompleted = 0;
				cp.lastExerciseCompleted = 0;
				cp.randomizedType = ( ListContains( ENDURANCE, p.randomGroupCode ) ) ? E : R;
				cp.randomizedTypeName = ( ListContains( ENDURANCE, p.randomGroupCode ) ) ? "Endurance" : "Resistance";
				cp.week = 0;
				cp.getNewBP = 0;	
				//This has to be initialized later...
				cp.BPDaysLeft = 0;
				cp.BPSystolic = 0;
				cp.BPDiastolic = 0;
				cp.targetHR = 0;
				cp.weight = 0;
				cp.exlist = 0;
			}
		}
	}

	else {
		//Check for the participant key in the partiicpants struct
		for ( p in selectedParticipants.results ) {	
			//Regenerate if this is not there.
			if ( !StructKeyExists( t.participants, p.participantGUID ) ) {
				//Create a key that can be referenced by the participant GUID
				cp = t.participants[ Trim( p.participantGUID ) ] = {};
				cp.recordThread = Trim( ezdb.exec( string = "SELECT newID() as newGUID" ).results.newGUID );
				cp.checkInCompleted = 0 ;
				cp.exerciseParameter = 0 ;
				cp.recoveryCompleted = 0;
				cp.lastExerciseCompleted = 0;
				cp.randomizedType = ( ListContains( ENDURANCE, p.randomGroupCode ) ) ? E : R;
				cp.randomizedTypeName = ( ListContains( ENDURANCE, p.randomGroupCode ) ) ? "Endurance" : "Resistance";
				cp.week = 0;
				cp.getNewBP = 0;	
				//This has to be initialized later...
				cp.BPDaysLeft = 0;
				cp.BPSystolic = 0;
				cp.BPDiastolic = 0;
				cp.targetHR = 0;
				cp.weight = 0;
				cp.exlist = 0;
			}
		}
	}
}


//Redefine this to make life easy
if ( !StructKeyExists( session, session.ivId ) ) 
	cs = session[ session.ivId ] = {};
else {
	cs = session[ session.ivId ]; 
}

//Build a session
cs.id = session.ivId ;
cs.date = usedDate;
cs.day = currentDayOfWeek;
cs.dayName = currentDayOfWeekName; //DateTimeFormat( Now(), "EEE" );
cs.needsRebuild = 0;
cs.selected = 0;
cs.siteid = siteId ;
cs.staffId = staffId;
cs.participantId = currentId ;
cs.participantList = (isDefined("selectedParticipants")) ? ValueList(selectedParticipants.results.participantGUID, ", ") : "";
cs.staff = {
	 email     =  (isDefined( 'session.email' )) ? session.email : ""
	,guid      = 	staffId 
	,userid    =  (isDefined( 'session.userid' )) ? session.userid : ""
	,firstname =  (isDefined( 'session.firstname' )) ? session.firstname : ""
	,lastname  =  (isDefined( 'session.lastname' )) ? session.lastname : ""
};

//Add a location queue
footprint = {
	location = "#cgi.script_name##iif( cgi.query_string eq "", DE("?" & cgi.query_string), DE(""))#"
 ,time = Now()
 ,partiicpantGUID = cs.participantId
};

if ( !StructKeyExists( cs, "footprints" ) ) { 
	cs.footprints = [ footprint, {},{},{},{} ]; 
}
else {
	if ( !FindNoCase( "sessdata.cfm", cgi.script_name ) ) {
		cs.footprints[ 5 ] = cs.footprints[ 4 ];
		cs.footprints[ 4 ] = cs.footprints[ 3 ];
		cs.footprints[ 3 ] = cs.footprints[ 2 ];
		cs.footprints[ 2 ] = cs.footprints[ 1 ];
		cs.footprints[ 1 ] = footprint;
	}
}

//...
sess.current = cs;

//Only build a new participant database after initial submission
if ( ( data.loaded eq "input" ) && ( cgi.query_string eq "" ) ) {
	buildRecordThreads( session[ session.ivId ] );
}

//Short name again
if ( StructKeyExists( sess.current, "participants" ) ) {
	if ( StructKeyExists( sess.current.participants, sess.current.participantId ) ) {
		sess.csp = sess.current.participants[ sess.current.participantId ];

		if ( StructKeyExists( url, "staffid" ) )
			sess.current.staff.userid = url.staffid;
		if ( StructKeyExists( url, "staffguid" ) )
			sess.current.staff.guid = url.staffguid;
		if ( StructKeyExists( url, "siteid" ) )
			sess.current.staff.guid = url.siteid;
		if ( StructKeyExists( url, "day" ) )
			sess.current.day = currentDayOfWeek; //url.day;
			//sess.current.day = url.day; 
		if ( StructKeyExists( url, "week" ) ) {
			sess.csp.week = currentWeek; //url.week;
			//sess.csp.week = url.week;
		}
		/*
		if ( StructKeyExists( url, "timeblock" ) )
			sess.current.staff.guid = url.time;
		if ( StructKeyExists( url, "param" ) )
			sess.csp.exerciseParameter = url.param;
		*/
	}
}


//Now, get specific and initialize other things
if ( data.loaded eq "input" && cgi.query_string neq "" ) {
	if ( StructKeyExists( url, "param" ) )
		sess.csp.exerciseParameter = url.param;

	//Select a week
	if ( StructKeyExists( url, "week" ) )
		sess.csp.week = url.week;
}
else if ( data.loaded eq "check-in" ) {
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
				thr = { type = "varchar", value = sess.csp.recordthread  }
			}
		).results.weight;

	//...
	if ( !ListContains(ENDURANCE, currentParticipant.results.randomGroupCode) )
		targetHR = 0;
	else {
		//Get the last recorded weight
		targetHR = ezdb.exec( 
			string="SELECT trgthr1 FROM #tbName# 
				WHERE recordthread = :thr AND participantGUID = :pid "
		 ,bindArgs = { 
				pid = { type = "varchar", value = sess.current.participantId },
				thr = { type = "varchar", value = sess.csp.recordthread  }
			}
		).results.trgthr1;
	}

	//Blood pressure
	sess.csp.getNewBP = privateReBP;
	sess.csp.BPDaysLeft = privateBPDaysLimit - privateBPDaysElapsed;
	sess.csp.BPSystolic = (privateReBP) ? 40 : privateBPQ.bp_systolic;
	sess.csp.BPDiastolic = (privateReBP) ? 40 : privateBPQ.bp_diastolic;
	BPMinSystolic = 40 ;
	BPMaxSystolic = 160;
	BPMinDiastolic = 40;
	BPMaxDiastolic = 90;

	//Target Heart Rate
	sess.csp.targetHR = ( targetHR eq "" || targetHR eq 0 ) ? 0 : targetHR;

	//Weight
	sess.csp.weight = ( weight eq "" || weight eq 0 ) ? 0 : weight;

	//Completed days array
	sess.csp.cdays = [0,0,0,0,0,0];

	//Query completed days
	qCompletedDays = ezdb.exec(
		string="SELECT dayofwk FROM #tbName# 
			WHERE participantGUID = :pid AND stdywk = :wk"
	 ,bindArgs={ 
			pid = sess.current.participantId 
		 ,wk  = sess.csp.week
		}
	);

	//...
	for ( n in ListToArray( ValueList( qCompletedDays.results.dayofwk, "," ) ) ) {
		sess.csp.cdays[ n ] = n; 
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
