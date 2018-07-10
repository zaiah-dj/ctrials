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

ezdb.exec( 
	string = "DELETE FROM #data.data.sessiondpart# WHERE sp_sessdayid = :sdid"
 ,bindArgs = { sdid = csSid }
);
	

//Destroy staff record (so that the participants are free?) 
ezdb.exec( 
	string = "DELETE FROM #data.data.sessiondstaff#	WHERE ss_sessdayid = :sdid"
 ,bindArgs = { sdid = csSid }
);
</cfscript>
