<cfscript>
if ( StructkeyExists( url, 'pid' ) ) 
	pid = url.pid;

if ( StructkeyExists( url, 'week' ) ) 
	week = url.week;

aIsDefined = 1;
if ( !isDefined("pid") || !isDefined("week") ) {
	aIsDefined = 0;	
}
else {
	DaysArr=[
		{ name="Mon",number=false } 
	 ,{ name="Tue",number=false } 
	 ,{ name="Wed",number=false } 
	 ,{ name="Thu",number=false } 
	 ,{ name="Fri",number=false } 
	 ,{ name="Sat",number=false } 
	];

	t = dbExec(	
		string = "SELECT randomGroupCode FROM #data.data.participants# WHERE participantGUID = :pid"
	 ,bindArgs = { pid = pid }
	);

	type = t.results.randomGroupCode;

	if ( ListContains( ENDURANCE, type ) ) 
		dbb = data.data.endurance;
	else if ( ListContains( RESISTANCE, type ) )
		dbb = data.data.resistance;
	else { 
		//send a failure, b/c i haven't written control logic and PIDs could be wrong...
		aIsDefined = 0;
	}

	if ( aisDefined ) {
		a = dbExec(
			string = "
			SELECT 
				dayofwk 
			, participantGUID
			, case
					when dayofwk = 1 then 'Mon' 
					when dayofwk = 2 then 'Tue' 
					when dayofwk = 3 then 'Wed' 
					when dayofwk = 4 then 'Thu' 
					when dayofwk = 5 then 'Fri' 
					when dayofwk = 6 then 'Sat' 
				end as dayName
			FROM
				#dbb#
			WHERE
				participantGUID = :pid
			AND
				stdywk = :week
				"	,

			bindArgs = {
				pid = pid
			 ,week= week
			}
		);

		if ( !a.status ) {
			writedump( a );abort;
			aIsDefined = 0;	
		}

		//Loop through the query and create an array of name-index of objects
	/*
	*/	
	}
}
	</cfscript>
