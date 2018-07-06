<cfscript>
//Bring in ezdb
ezdb  = CreateObject( "component", "components.quella" );

//
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
	 ,dayofwk = DayOfWeek( Now() )
	 ,dayofmonth = DateTimeFormat( Now(), "d" )
	 ,month = DateTimeFormat( Now(), "MM" )
	 ,year = DateTimeFormat( Now(), "YYYY" )
	}
);

csDate = csQuery.results.sdate;
csSid = csQuery.results.sid;

if ( StructKeyExists( url, "staffid" ) ) {
	//Get the participant record key
	prkey = ezdb.exec( 
		datasource="#data.source#"
	 ,string = "
		SELECT ss_participantrecordkey as prk FROM 
			#data.data.sessiondstaff#	
		WHERE 
			ss_staffid = :stfid
		AND 
			ss_sessdayid = :sdid
		"
	 ,bindArgs = { 
			sdid = csSid
		 ,stfid = url.staffid
		}
	).results.prk;

	//writedump(prkey);abort;
	//Destroy participant records ( or invalidate them somehow )
	ezdb.exec( 
		string = "DELETE FROM 
			#data.data.sessiondpart#	
		WHERE 
			sp_participantrecordkey = :prkid
		AND 
			sp_sessdayid = :sdid
		"
	 ,bindArgs = { 
			sdid = csSid
		 ,prkid = prkey 
		}
	);

	//Destroy staff record (so that the participants are free?) 
	ezdb.exec( 
		string = "DELETE FROM 
			#data.data.sessiondstaff#	
		WHERE 
			ss_sessdayid = :sdid
		AND ss_staffid = :stfid
		"
	 ,bindArgs = { 
			sdid = csSid
		 ,stfid = url.staffid
		}
	);
}


//Destroy session key in db
ezdb.exec( 
	string = "DELETE FROM 
		#data.data.sessiondappl#	
	WHERE 
		sm_siteid = :site_id
	AND
		sm_dayofweek = :dayofwk
	"
 ,bindArgs = { 
		site_id = 999 
	 ,dayofwk = DayOfWeek( Now() )
	}
);


//Get rid of the main identifier
if ( StructKeyExists( session, "ivId" ) ) { 
	StructDelete( session, "ivId" );
}


//Loop through and get rid of all other session data
for ( n in session ) {
	StructDelete( session, n );
}
</cfscript>
