<cfscript>
//Include all CFCs first here
rl    = CreateObject( "component", "components.requestLogger" );
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
udo   = CreateObject( "component", "components.calcUserDate" ).init();
//wfb   = CreateObject( "component", "components.wfbutils" );
include "constants.cfm";
include "custom.cfm";

//Set a smaller reference for the cdate
cdate = udo.object.dateObject;

//Set a user date object session key...
(( data.loaded eq "default" ) && ( data.debug eq 1 )) ? udo.setSessionKeys() : 0;

//Calculate all of these date variables
( !StructKeyExists( session, "isAppDateSet" )) ? udo.setSessionKeys() : 0;

//Check for session.userguid
if ( !StructKeyExists( session, "userguid" ) ) {
	//Redirect if I am not on an approved server
	if ( !ListContains( ArrayToList( data.localdev ), cgi.http_host ) )
		location( addtoken = "no", url = data.redirectForLogin );
	else {
		//Also requires a userGUID
		session.userguid = dbExec( string="SELECT TOP(1) ts_staffguid as id FROM #data.data.staff#" ).results.id;
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
	if ( !StructKeyExists( session, "siteid" ) )
		session.siteid = siteId = 999;
	else {
		//Why would this not be set?
		siteId = session.siteid;
	}
}

//Get the last session key in the browser or make a new one.
if ( !StructKeyExists( session, "ivId" ) ) 
	session.ivId = randstr( 5 ) & randnum( 10 ) & randstr( 5 );

//Look for a matching key of some sort.
csQuery = dbExec(
  filename = 'csQuery.sql'
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
	  filename = "csInsert.sql"
	 ,bindArgs = { 
		  site_id = session.siteid 
		 ,dtstarted = { value = cdate, type = "cf_sql_date" }
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
		filename = "csQuery.sql"
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

	//Also clean up the data table
	delete = dbExec(
		datasource = "#data.source#"
	 ,string = "DELETE FROM ac_mtr_frm_progress WHERE fp_sessdayid NOT :sid"
 	 ,bindArgs = {
			sid = csSid
		}
	);
}


//Get participant data 
currentParticipant = dbExec( 
	string = "SELECT * FROM v_ADUSessionTickler WHERE participantGUID = :pid"
 ,bindArgs = { pid = { value = currentId, type="cf_sql_varchar" }}
);


//If a current ID is initialized, figure out which group they belong to
randomCode = currentParticipant.results.randomGroupCode;


//If nothing is selected, these queries ought to be empty queries
selectedParticipants = dbExec( 
	filename = "selectedParticipants.sql"
 ,bindArgs = {
		guid = session.userguid 
	 ,sid = csSid 
   ,today = { value=cdate, type="cf_sql_date" }
	}	
);


//...
unselectedParticipants = dbExec( 
	filename = "unselectedParticipants.sql"
 ,bindArgs = {
		sid = csSid 
   ,today = { value=cdate, type="cf_sql_date" }
	}
);


//Redefine this to make life easy
if ( !StructKeyExists( session, session.ivId ) ) 
	cs = session[ session.ivId ] = {};
else {
	cs = session[ session.ivId ]; 
}


//Record specific session data for this app only
cs.id = session.ivId ;
cs.date = session.userdate;
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
 ,participantGUID = cs.participantId
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

//Only build a new participant database after initial submission
if ( ( data.loaded eq "input" ) && ( cgi.query_string eq "" ) ) {
	if ( StructKeyExists( selectedParticipants, "results" ) && selectedParticipants.prefix.recordCount gt 0 ) {
		buildRecordThreads( session[ session.ivId ], selectedParticipants.results );
	}
}

//Now build session data for the "active" participant
if ( StructKeyExists( cs, "participants" ) ) {
	if ( StructKeyExists( cs.participants, cs.participantId ) ) {
		//???
		isEnd = (ListContains(const.ENDURANCE, currentParticipant.results.randomGroupCode)) ? 1 : 0;
		isRes = (ListContains(const.RESISTANCE, currentParticipant.results.randomGroupCode)) ? 1 : 0;

		//Short name for reference throughout the app
		sc = cs.participants[ cs.participantId ];

		//Define a prefix to choose between Endurance and Resistance participants
		prefix = (isEnd) ? "eetl" : "retl";

		//get blood pressure and weight
		cp = {
			details = dbExec( 
				filename = "init_#prefix#_pdetails.sql"
			 ,bindArgs = { 
					pid = { type = "varchar", value = cs.participantId }
				 ,visit = { type = "date", value = cdate }
				}
			).results

			//Get all the completed days for the week
		 ,completedDays = dbExec(
				string="SELECT dayofwk FROM frm_#prefix#
					WHERE participantGUID = :pid AND stdywk = :wk"
			 ,bindArgs={ 
					pid = cs.participantId 
				 ,wk  = sc.week
				}
			).results

			//Get all the notes
		 ,notes = dbExec(
				filename = "init_all_notes.sql"
			 ,bindArgs = {
					pid = cs.participantId
				 ,dateLimit = { value = DateAdd("d", -14, cdate), type = "cf_sql_date" } 
				}
			).results
		};

		//Get 
		sc.exerciseParameter = cp.details.exerciseType;

		//Calculate remaining blood pressure calculation days
		sc.bpDaysElapsed = (cp.details.bp_daterecorded eq "") ? 0 : DateDiff("d",cp.details.bp_daterecorded,Now());

		//Boolean to tell if we need a new blood pressure or not
		sc.getNewBP = (cp.details.bp_daterecorded eq "" || sc.BPDaysElapsed gt const.bpDaysLimit); 

		//Calculate time until we need to take a new blood pressure
		sc.bpDaysLeft = const.bpDaysLimit - sc.bpDaysElapsed;
		
		//sc.bpSystolic = (sc.getNewBP) ? const.bpMinSystolic : cp.details.bp_systolic;
		sc.bpSystolic = cp.details.mthlybpsys;

		//sc.bpDiastolic = (sc.getNewBP) ? const.bpMinDiastolic : cp.details.bp_diastolic;
		sc.bpDiastolic = cp.details.MthlyBPDia;

		sc.HRWorking = (cp.details.HRWorking eq "" || cp.details.HRWorking eq 0 ) ? 0 : cp.details.HRWorking;
		
		sc.weight = (cp.details.weight eq "" || cp.details.weight eq 0 ) ? 0 : cp.details.weight;

		sc.week = cp.details.stdywk;

		sc.day = cp.details.dayofwk;

		sc.hr1 = cp.details.hr1;

		sc.hr2 = cp.details.hr2;

		//Day names
		dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri"];
		sc.dayName = dayNames[cp.details.dayofwk];

		//Populate the finished days
		sc.cdays = [0,0,0,0,0,0];
		for ( n in ListToArray( ValueList( cp.completedDays.dayofwk, "," ) ) ) {
			sc.cdays[ n ] = n; 
		}
	}
}


</cfscript>
