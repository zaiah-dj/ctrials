<!--- display previous week's results in ajax --->
<cfscript>
prev = 0;
week = (!StructKeyExists( url, "week" )) ? (!isDefined("week") ? 1 : week) : url.week;
day = (!StructKeyExists( url, "day" )) ? (!isDefined("day") ? 1 : day) : url.day;
currentParticipant = ezdb.exec(
	string = "SELECT * FROM 
		#data.data.participants# 
	WHERE 
		participantGUID = :pid" 
 ,bindArgs = { pid = ( isDefined("url.id") ) ? url.id : (( isDefined("cid") ) ? cid : 0) }
);

if ( !isDefined( "currentParticipant" ) ) {
	writeoutput( "no id exists for participant" );
	abort;
}

//if count is zero?
if ( !isDefined( "currentParticipant" ) ) {
	writeoutput( "no id exists for participant" );
	abort;
}

if ( isDefined( "currentParticipant" ) && ListContains(ENDURANCE, currentParticipant.results.randomGroupCode) ) {
	times = [
	/*	 { index=0,  text="Warm-Up" }
		,*/{ index=5,  text='<5m'  }
		,{ index=10, text='<10m' }
		,{ index=15, text='<15m' }
		,{ index=20, text='<20m' }
		,{ index=25, text='<25m' }
		,{ index=30, text='<30m' }
		,{ index=35, text='<35m' }
		,{ index=40, text='<40m' }
		,{ index=45, text='<45m' }
	/*	,{ index=50, text='<50m' }
		,{ index=55, text='Recovery' } */
	];
	ee = ezdb.exec(
		string = "SELECT * FROM 
			#data.data.endurance# 
		WHERE 
			participantGUID = :pid
		AND
			dayofwk = :day 
		AND
			stdywk = :week
		" 
	 ,bindArgs = { pid = sess.current.participantId, week = week, day = day }
	);
}
else if ( isDefined( "currentParticipant" ) && ListContains(RESISTANCE, currentParticipant.results.randomGroupCode) ) 
{
	reExList=ezdb.exec( string="SELECT * FROM #data.data.exerciseList#" );
	rr = ezdb.exec(
		string = "SELECT * FROM 
			#data.data.resistance# 
		WHERE 
			participantGUID = :pid
		AND
			dayofwk = :day 
		AND
			stdywk = :week
		" 
	 ,bindArgs = { pid = sess.current.participantId, week = week, day = day }
	);
}
</cfscript>
