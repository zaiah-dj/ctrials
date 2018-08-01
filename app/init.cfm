<cfscript>
//writedump( session );abort;
//Include all CFCs first hereq
ajax  = CreateObject( "component", "components.writeback" );
ezdb  = CreateObject( "component", "components.quella" );
rl    = CreateObject( "component", "components.requestLogger" );
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
val   = CreateObject( "component", "components.validate" );


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


//writedump( session ); abort;

//On production, the date will always be the current date... I think...
if ( data.debug eq 0 )
	userDateObject = Now(); 
else { 
	//Current date
	if ( isDefined( "url.date" ) && StructKeyExists(url, "date") ) {
		try {
			userDateObject = LSParseDateTime( url.date );
		}
		catch (any e) {
			userDateObject = Now();
		}
	}
	else {
		//usedDate = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
		userDateObject = Now(); 
	}
}

//Calculate all of these date variables
currentDayOfWeek = DayOfWeek( userDateObject );
currentDayOfWeekName = DateTimeFormat( userDateObject, "EEE" );
currentDayOfMonth = DateTimeFormat( userDateObject, "d" );
currentMonth = DateTimeFormat( userDateObject, "m" );
currentYear = DateTimeFormat( userDateObject, "YYYY" );
currentWeek = DateTimeFormat( userDateObject, "w" );
userDate = DateTimeFormat( userDateObject, "YYYY-MM-DD HH:nn:ss" );

//Check for session.userguid
if ( !StructKeyExists( session, "userguid" ) ) {
	//Redirect if I am not on an approved server
	if ( !ListContains( ArrayToList( data.localdev ), cgi.http_host ) ) {
		/*writeoutput( "this is redirecting? " );
		writeoutput( data.localdev );
		writeoutput( cgi.http_host );
		abort;*/
		location( addtoken = "no", url = data.redirectForLogin );
	}
	else {
		//Generate at least a cfid, so that this works
		//session.cfid = ezdb.exec( "SELECT newid() as id" ).results.id;

		//Also requires a userGUID
		session.userguid = dbExec( string="SELECT TOP(1) ts_staffguid as id FROM #data.data.staff#" ).results.id;
	}	
}


//If isDateSet is not set, that means that there is no date in the session 
if ( !StructKeyExists( session, "isAppDateSet" ) ) {
	session.isAppDateSet = 1;
	session.currentDayOfWeek = currentDayOfWeek;
	session.currentDayOfWeekName = currentDayOfWeekName;
	session.currentDayOfMonth = currentDayOfMonth;
	session.currentMonth = currentMonth;
	session.currentYear = currentYear;
	session.currentWeek = currentWeek;
	session.userDate = userDate;
}
//If it is there, then I've already set something, however, I only need to do this on the default page, and if we're in debug mode
else { 
	if (( data.loaded eq "default" ) && ( data.debug eq 1 ) ) {
		//Only change date if on default.cfm - writeoutput( "change date" );abort;
		session.isAppDateSet = 1;
		session.currentDayOfWeek = currentDayOfWeek;
		session.currentDayOfWeekName = currentDayOfWeekName;
		session.currentDayOfMonth = currentDayOfMonth;
		session.currentMonth = currentMonth;
		session.currentYear = currentYear;
		session.currentWeek = currentWeek;
		session.userDate = userDate;
	}
}


//Set a site ID from here
staffId = 0;
if ( data.debug eq 1 ) {
	if ( StructKeyExists( form, "setstaffid" ) )
		session.userguid = sgid = form.setstaffid;
	else if ( data.loaded eq "default" && StructKeyExists( url, "staffid" ) )
		session.userguid = sgid = url.staffid;
	//This condition could break API updates... so if there are any exceptions look here first...
	else if ( !StructKeyExists( session, "userguid" ) )
		location( addtoken = "no", url = data.redirectForLogin );
	else {
		sgid = session.userguid;
	}
}
else {
	//api updates may break...
	if ( !StructKeyExists( session, "userguid" ) || !isDefined( "session.userguid" ) ) {
		//if (data.loaded eq "input"){writeoutput( "<h2>session.userguid is not defined</h2>" );abort;}
		//No default will be set if no guid exists, just redirect and get credentials again
		location( addtoken = "no", url = data.redirectForLogin );
	}
	else {
		//if (data.loaded eq "input"){writeoutput( "<h2>session.userguid defined and is '#session.userguid#'</h2>" );abort;}
		//staffId = session.userguid;
		sgid = session.userguid;
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
	session.siteid = siteId = url.siteid;
else {
	//siteId = 999;	
	if ( !StructKeyExists( session, "siteid" ) )
		session.siteid = siteId = 999;
	else {
		//Why would this not be set?
		siteId = session.siteid;
	}
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
/*
//....
//writedump( session );abort;
sess.currentDayOfWeek = currentDayOfWeek;
sess.currentDayOfWeekName = currentDayOfWeekName;
sess.currentDayOfMonth = currentDayOfMonth;
sess.currentMonth = currentMonth;
sess.currentYear = currentYear;
sess.currentWeek = currentWeek;
sess.userDate = userDate;
*/

//Look for a matching key of some sort.
csQuery = ezdb.exec(
	datasource = "#data.source#"
 ,string = "
		SELECT 
			sm_sessdayid as sid 
		 ,sm_datetimestarted as sdate 
		FROM 
			#data.data.sessiondappl# 
		WHERE sm_dayofweek = :dow
		AND sm_dayofmonth  = :dom
		AND sm_month = :mon
		AND sm_year = :year
		AND sm_siteid = :siteid	
	"
 ,bindArgs = { 
		siteid = session.siteid 
	 ,dow    = session.currentDayOfWeek
	 ,dom    = session.currentDayOfMonth
	 ,mon    = session.currentMonth
	 ,year   = session.currentYear
	}
);


//if there is no record of a current session, time to write it in
if ( csQuery.prefix.recordCount gt 0 ) {
	csDate = csQuery.results.sdate;
	csSid = csQuery.results.sid;
}
else {
	csQuery = dbExec(
	  string = "
			INSERT INTO #data.data.sessiondappl# 
				( sm_siteid, sm_datetimestarted, sm_dayofweek, sm_dayofmonth, sm_month, sm_year )
			VALUES
				( :site_id , :dtstarted, :dayofwk, :dayofmonth, :month, :year )
		"  
	 ,bindArgs = { 
		  site_id = session.siteid 
		 ,dtstarted = { value = userDateObject, type = "cf_sql_date" }
		 ,dayofwk = session.currentDayOfWeek
		 ,dayofmonth = session.currentDayOfMonth
		 ,month = session.currentMonth
		 ,year = session.currentYear
		}
	);

	//We really SHOULDN'T move forward if I can't identify who is supposed to be here...
	if ( !csQuery.status ) {
		writeoutput( "Fatal Exception at app/init.cfm. " & 
			"Database failed to generate new day ID." &
			"#csQuery.message#" );

		abort;
	}

	//re-run query and get the data I want
	csQuery = dbExec(
		datasource = "#data.source#"
	 ,string = "
			SELECT 
				sm_sessdayid as sid 
			 ,sm_datetimestarted as sdate 
			FROM 
				#data.data.sessiondappl# 
			WHERE sm_dayofweek = :dow
			AND sm_dayofmonth  = :dom
			AND sm_month = :mon
			AND sm_year = :year
			AND sm_siteid = :siteid	
		"
	 ,bindArgs = { 
			siteid = session.siteid 
		 ,dow    = session.currentDayOfWeek
		 ,dom    = session.currentDayOfMonth
		 ,mon    = session.currentMonth
		 ,year   = session.currentYear
		}
	);

	csDate = csQuery.results.sdate;
	csSid = csQuery.results.sid;
}



//Check if the staff member has been logged in as well
stf = ezdb.exec( 
	string = "
		SELECT 
			ss_id,
			ss_sessdayid,
			ss_staffguid,
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
			ss_staffguid = :staff_id
	"
 ,bindArgs = { 
		sid = csSid 
	 ,staff_id = staffId
	 ,staff_ssid = session.ivId
	}
);


stfPrk = stf.results.ss_participantrecordkey;


//Make a record
if ( stf.results.ss_staffguid eq "" ) {
	stf = ezdb.exec( 
		string = "
			INSERT INTO #data.data.sessiondstaff# 
				( ss_sessdayid
				 ,ss_staffguid
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
				ss_staffguid,
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
				ss_staffguid = :staff_id
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

		//If not logged in, this might not be the first time we did anything
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
cs.date = session.userDate;
cs.day = session.currentDayOfWeek;
cs.dayName = session.currentDayOfWeekName;
cs.needsRebuild = 0;
cs.selected = 0;
cs.siteid = session.siteid;
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


//Track the last location
if ( !StructKeyExists( cs, "footprints" ) )
	cs.footprints = [ footprint, {},{},{},{} ]; 
else {
	//if ( !FindNoCase( "sessdata.cfm", cgi.script_name ) ) { ; }
	cs.footprints[ 5 ] = cs.footprints[ 4 ];
	cs.footprints[ 4 ] = cs.footprints[ 3 ];
	cs.footprints[ 3 ] = cs.footprints[ 2 ];
	cs.footprints[ 2 ] = cs.footprints[ 1 ];
	cs.footprints[ 1 ] = footprint;
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
	//Select days from this week with results (including today?)
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
				noteDate
			 ,noteText	
			 ,insertedby
			FROM 
				#data.data.notes#	
			WHERE participantGUID = :pid
				AND	noteCategory = 3
			ORDER BY noteDate DESC
			"
	 ,datasource = "#data.source#" 
	 ,bindArgs = {pid = sess.current.participantId}
	);
	
	if ( !pNotes.status ) {
		writedump( pNotes.message );
		abort;	
	}	
}
</cfscript>
