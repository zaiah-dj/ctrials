<cfscript>
//Look for a matching key of some sort.
csQuery = dbExec(
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
		siteid  = session.siteid 
	 ,dayofwk = DayOfWeek( Now() )
	 ,dayofmonth = DateTimeFormat( Now(), "d" )
	 ,month = DateTimeFormat( Now(), "MM" )
	 ,year = DateTimeFormat( Now(), "YYYY" )
	}
);


//
csDate = csQuery.results.sdate;
csSid = csQuery.results.sid;


//
dbExec( 
	string = "DELETE FROM #data.data.sessiondpart# WHERE sp_sessdayid = :sdid"
 ,bindArgs = { sdid = csSid }
);
	

//Destroy staff record (so that the participants are free?) 
dbExec( 
	string = "DELETE FROM #data.data.sessiondstaff#	WHERE ss_sessdayid = :sdid"
 ,bindArgs = { sdid = csSid }
);
</cfscript>
