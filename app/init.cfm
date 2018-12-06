<!--- -------------------------------------------------------------------------
init.cfm
========

Notes:
------
These comments are written in Markdown and can be converted to HTML by running
`make doc`.


Date Created:        
------------
2018-09-25


Author(s)
------------
-


Description: 
------------

This file handles a number of tasks central
to getting the MIV app running correctly.

These include:
- checking for properly authenticated users
- setting up user information, 
- initializing the current participant
- initializing the list of selected participants
- initializing the list of unselected participants
- tracking details pertinent to the current date	


Summary
--------
This file starts by including a few components, then moves on to authenticating
a user for access to the application.  

Only users who have the following access permission can use the app:
	'Intervention Tracking Entry'

Additionally, users must also be part of a staff group containing group code
'ADU'.  Other participant studies may use different codes that line up with the
type of participant being interacted with.  (Such as 'ANI' for animal or 'PED'
for chirren. :) ) 


Scopes Used
-----------
While ColdFusion has some support for scope, it's nothing like what you would
find in Java or C programs.  The best we can do is use object notation and
keep things together that way.  

The scopes initialized here are:

type        | description
----------- | -------------------	
usr         | For all user data
udo         | For anything pertaining to the current date
access      | For access control
cp          | The current participant
sc          | Current session's variables
cs          | MIV session's variables

These scopes are in ColdFusion's built-in 'variables' scope and can be used 
anywhere throughout the app (provided that 'init.cfm' is always called first).

 ---- ------------------------------------------------------------------------->
<cfscript>
//Include all dependencies here
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
udo   = CreateObject( "component", "components.calcUserDate" )
	.init( StructKeyExists( data, "date" ) ? LSParseDateTime( data.date ) : Now() );

include "constants.cfm";
include "custom.cfm";


//If session.userguid is not there, the user probably is either not logged in or has a stale session.
if ( !StructKeyExists( session, "userguid" ) ) {
	//Redirect if I am not on an approved server
	if ( !ListContains( ArrayToList( data.localdev ), cgi.http_host ) )
		;//location( addtoken = "no", url = data.redirectForLogin );
	/*
	else {
		//Also requires a userGUID
		//session.userguid = 1049;
		//session.userguid = dbExec( string="SELECT TOP(1) ts_staffguid as id FROM #data.data.staff#" ).results.id;
	}
	*/
}

//If application name is ever not set, the user is
//probably not accessing from where they should be.
if ( !StructKeyExists( application, "applicationname" ) ) {
	application.applicationname = "motrpac";
}

//Check if this an API call or not
access = { isApi = 0 };
if ( application.applicationname == "motrpac-local" ) {
	usr  = { 
		firstname = 'Antonio' 
	 ,lastname  = 'Collins'
	 ,siteid    = 999
	 ,userguid  = 1049
	 ,userid    = 1049
	 ,email     = 'arcollin@wakehealth.edu'
	 ,logindts  = Now()
	 ,username  = 'arcollin'
	};
}
else {
	if ( StructKeyExists( form, "this" ) ) {
		access.isApi = 1; 

		//All user data will be referenced from this struct 
		usr  = { 
			firstname = session.firstname	
		 ,lastname  = session.lastname	
		 ,siteid    = session.siteid
		 ,userguid  = session.userguid	
		 ,userid    = session.userid	
		 ,email     = session.email
		 ,logindts  = session.logindts
		 ,username  = session.username
		};
	}

	//Otherwise, initialize the current user
	else if ( StructKeyExists( session, 'mivlogin') ) {
		//All user data will be referenced from this struct 
		usr  = { 
			firstname = session.firstname	
		 ,lastname  = session.lastname	
		 ,siteid    = session.siteid
		 ,userguid  = session.userguid	
		 ,userid    = session.userid	
		 ,email     = session.email
		 ,logindts  = session.logindts
		 ,username  = session.username
		};
	}

	else {
		//admin users should be evaluated first, right now a default site can be assigned?
		access.isAdmin = session.isDMAQCPM 
			|| session.isProgrammer 
			|| session.isSUPERAdmin 
			|| session.isWebAdmin 
			|| session.isDMAQCStat 
			|| session.isRepository;

		//Also set this
		access.userSiteId = 0;

		//For debugging only
		//access.isAdmin = 0;

		//Get the most relevant site id
		//
		//dom => The Domain Code ( 'ADU' for adults, 'PED' for kids and 'ANI' for animals )
		//list => The sites that the user belongs to
		access.siteInfo = dbExec(
			filename = "init_siteinfo.sql"
		, bindargs = { 
				dom = "ADU"
			 ,list = { value=session.sitelist,type="cf_sql_varchar",list=1 } 
			}
		);

		//The query failed - log it and handle it 
		if ( !access.siteInfo.status ) {
			//redirect with an error message
		}

		//It looks like the user is part of no groups
		if ( access.siteinfo.prefix.recordCount eq 0 ) {
			access.userAllowed = 0;
		}

		//The user is part of too many groups and will probably have to choose which one
		if ( access.siteinfo.prefix.recordCount gt 1 ) {
			//access.userAllowed = 0;
		}

		//Get user's access rights
		access.requestorInfo = dbExec(
			filename = "init_requestorinfo.sql"
		, bindargs = { 
				uuid = session.userguid 
			, siteguid = access.siteInfo.results.siteGUID
			, accessTypeName = 'Intervention Tracking Entry'
			}
		);	

		//The query failed - log it and handle it 
		if ( !access.requestorInfo.status ) {
			//redirect with an error message
		}

		//This user does not have the access I'm looking for, where to redirect?
		if ( access.requestorInfo.prefix.recordCount eq 0 ) {
			access.userAllowed = 0;
		}
		else {
			access.userAllowed = 1;
			access.userSiteId = access.siteinfo.results.siteid;
		}

		//Always allow admins to get in
		access.userAllowed = ( access.isAdmin ) ? 1 : 0; 
		
		//If the user is still not authorized by this point, try no more
		if ( !access.userAllowed ) {
			location( addtoken = "no", url = data.redirectHome );
		}

		//Finally, catch any unusual cases in which an admin may not be associated with any sites.
		if ( access.userAllowed && access.isAdmin && ( access.userSiteId eq "" || access.userSiteId == 0 ) ) {
			access.userSiteId = 999;
		}

		//Set the session.siteid here because it's needed so often
		session.siteid = access.userSiteId;

		//And go ahead and permanently log the user into this app 
		//for the length of the current session
		session.mivlogin = 1;

		//All user data will be referenced from this struct 
		usr  = { 
			firstname = session.firstname	
		 ,lastname  = session.lastname	
		 ,siteid    = access.userSiteId 
		 ,userguid  = session.userguid	
		 ,userid    = session.userid	
		 ,email     = session.email
		 ,logindts  = session.logindts
		 ,username  = session.username
		};
	}
}


//Set an easy to remember reference for the current date
cdate = udo.object.dateObject;

//Set a user date object session key...
(( data.loaded eq "default" ) && ( data.debug eq 1 )) ? udo.setSessionKeys() : 0;

//Calculate all of these date variables
( !StructKeyExists( session, "isAppDateSet" )) ? udo.setSessionKeys() : 0;


//Get the last session key in the browser or make a new one.
if ( !StructKeyExists( session, "ivId" ) ) 
	session.ivId = randstr( 5 ) & randnum( 10 ) & randstr( 5 );


//Logic to get the most current ID.
currentId = 0;
if ( StructKeyExists( form, "pid" ) )
	currentId = form.pid;	
else if ( StructKeyExists( url, "id" ) )
	currentId = url.id;
else {
}


//Logic to get the "active" site ID.
siteId = 0;
if ( StructKeyExists( url, "siteid" ) )
	usr.siteid = siteId = url.siteid;
/*
else {
	if ( !StructKeyExists( session, "siteid" ) )
		session.siteid = siteId = 999;
	else {
		//Why would this not be set?
		siteId = session.siteid;
	}
}
*/


//Look for a matching key of some sort.
csQuery = dbExec(
  filename = 'csQuery.sql'
 ,bindArgs = { 
		siteid = usr.siteid 
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
		  site_id = usr.siteid 
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
			siteid = usr.siteid 
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


//Calculate site ID here if not already done...
csSiteId = usr.siteid;


//Get participant data 
currentParticipant = dbExec( 
	string = "SELECT * FROM v_ADUSessionTickler WHERE participantGUID = :pid AND siteID = :site_id"
 ,bindArgs = { pid = { value = currentId, type="cf_sql_varchar" }, site_id = csSiteId }
);


//If a current ID is initialized, figure out which group they belong to
randomCode = currentParticipant.results.randomGroupCode;


//If nothing is selected, these queries ought to be empty queries
selectedParticipants = dbExec( 
	filename = "selectedParticipants.sql"
 ,bindArgs = {
		guid = usr.userguid 
	 ,sid = csSid 
	 ,site_id = csSiteId
   ,today = { value=cdate, type="cf_sql_date" }
	}	
);


//Unselected participants
unselectedParticipants = dbExec( 
	filename = "unselectedParticipants.sql"
 ,bindArgs = {
		sid = csSid 
	 ,site_id = csSiteId
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
cs.siteid = usr.siteid;
cs.participantId = currentId ;
cs.participantList = (isDefined("selectedParticipants")) ? ValueList(selectedParticipants.results.participantGUID, ", ") : "";
cs.staff = {
	 email     =  (isDefined( 'session.email' )) ? session.email : ""
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

		cp = {
			//get blood pressure and weight
			details = dbExec( 
				filename = "init_#prefix#_pdetails.sql"
			 ,bindArgs = { 
					pid = { type = "varchar", value = cs.participantId }
				 ,visit = { type = "date", value = cdate }
				}
			)

			//Get all the completed days for the week
		 ,completedDays = dbExec(
				string="SELECT dayofwk FROM frm_#prefix#
					WHERE participantGUID = :pid AND stdywk = :wk"
			 ,bindArgs={ 
					pid = cs.participantId 
				 ,wk  = sc.week
				}
			)

			//Get all the notes
		 ,notes = dbExec(
				filename = "init_all_notes.sql"
			 ,bindArgs = {
					pid = cs.participantId
				 ,dateLimit = { value = DateAdd("d", -14, cdate), type = "cf_sql_date" } 
				}
			)
		};

		//Get 
		sc.exerciseParameter = cp.details.results.exerciseType;

		//Calculate remaining blood pressure calculation days
		sc.bpDaysElapsed = (cp.details.results.bp_daterecorded eq "") ? 0 : DateDiff("d",cp.details.results.bp_daterecorded,Now());

		//Boolean to tell if we need a new blood pressure or not
		sc.getNewBP = (cp.details.results.bp_daterecorded eq "" || sc.BPDaysElapsed gt const.bpDaysLimit); 

		//Calculate time until we need to take a new blood pressure
		sc.bpDaysLeft = const.bpDaysLimit - sc.bpDaysElapsed;
		
		//sc.bpSystolic = (sc.getNewBP) ? const.bpMinSystolic : cp.details.results.bp_systolic;
		sc.bpSystolic = cp.details.results.mthlybpsys;

		//sc.bpDiastolic = (sc.getNewBP) ? const.bpMinDiastolic : cp.details.results.bp_diastolic;
		sc.bpDiastolic = cp.details.results.MthlyBPDia;

		sc.HRWorking = (cp.details.results.HRWorking eq "" || cp.details.results.HRWorking eq 0 ) ? 0 : cp.details.results.HRWorking;
		
		sc.weight = (cp.details.results.weight eq "" || cp.details.results.weight eq 0 ) ? 0 : cp.details.results.weight;

		sc.week = cp.details.results.stdywk;

		sc.day = cp.details.results.dayofwk;

		sc.hr1 = cp.details.results.hr1;

		sc.hr2 = cp.details.results.hr2;

		//Day names
		dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
		sc.dayName = dayNames[cp.details.results.dayofwk];
	}
}


</cfscript>
