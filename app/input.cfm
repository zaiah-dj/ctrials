<cfscript>
/* input.cfm - Controls the appearance of pages that need data. */

//If no one is selected, do nothing
if ( currentParticipant.prefix.recordCount eq 0 ) 
	0;

//Get the participant types first to figure out if there is any reason to move further.
isEnd = ListContains(ENDURANCE, currentParticipant.results.randomGroupCode );
isRes = ListContains(RESISTANCE, currentParticipant.results.randomGroupCode );

//If moving forward, then start calculations
if ( isEnd || isRes ) {
	//Define these for the purposes of this model
	private = {};
	public = {};

	//Define static data here for easy editing
	private.labels = [ "Cycle", "Treadmill", "Other", "Chest, Shoulders...", "Hips/Thighs" ];

	//Figure out The text name will do a lot
	partClass = ( isEnd ) ? "endurance" : "resistance";	

	//Set variables based on selection type
	obj = CreateObject( "component", "components.#partClass#" ).init();	
	private.dbName = ( isEnd ) ? "#data.data.endurance#" : "#data.data.resistance#";
	private.mpName = (isEnd) ? "time" : "extype";
	private.hiddenVarName= (isEnd) ? "timeblock" : "extype";
	private.rp = (isRes) ? ((sess.csp.exerciseParameter eq 4) ? 1 : 3 ) : 0;
	private.magic = (StructKeyExists(url, private.mpName )) ? url[ private.mpName ] : private.rp;
	private.magicName = (isEnd) ? "" : obj.getExerciseName( private.magic ).pname;
	private.exSetType = sess.csp.exerciseParameter;
	private.exSetTypeLabel = private.labels[ sess.csp.exerciseParameter ];
	private.modNames = (isEnd) ? obj.getModifiers() : obj.getSpecificModifiers( private.exSetType );
	private.dbPrefix = (isEnd) ? obj.getTimeInfo( private.magic ).prefix : obj.getExerciseName( private.magic ).prefix ;
	private.cssPrefix = partClass;
	private.formValues = obj.getLabelsFor( sess.csp.exerciseParameter, private.magic ); 

	//Check check-in completed first (the tab should have at least been visited)
	//sess.csp.checkInCompleted = 1;

	//Select the last two days for this user.
	private.lastdays = dbExec(
		string = "
			SELECT TOP(2) dayofwk, stdywk FROM #private.dbName# 
			WHERE 
				participantGUID = :pid 
			AND 
				stdywk <= :stdywk
			ORDER BY stdywk, dayofwk DESC"
	 ,bindArgs = { 
			pid = sess.current.participantId 
		 ,stdywk = sess.csp.week
		}
	);

	//Calculate the previous day according to what is already here
	pl = private.lastDays;
	//No days yet, so skip any kind of calculation, 0 should always return nothing
	if ( pl.prefix.recordCount eq 0 )
		private.previous = { day=0, week=0 };
	//If there is just one result, then I need to figure out what's going on
	else if ( pl.prefix.recordCount eq 1 ) {
		//Check that this isn't just a recent result
		if (( pl.results.dayofwk eq session.currentDayOfWeek ) && (pl.results.stdywk eq sess.csp.week))
			private.previous = { day=0, week=0 };
		//Let it be zero otherwise
		else {
			private.previous = { day=pl.results.dayofwk, week=pl.results.stdywk };
		}
	}
	else {
		//If currentweek and pl.results.stdywk are different, then the first result is what I want 
		//Likewise if currentWeek eq previous week, but day is different, then go with this one	
		if ((sess.csp.week gt pl.results.stdywk) || (( sess.csp.week eq pl.results.stdywk ) && (session.currentDayOfWeek gt pl.results.dayofwk)))
			private.previous = { day=pl.results.dayofwk, week=pl.results.stdywk };
	
		//If currentWeek and pl.results.stdywk are the same, then I want the one the one before it (because hte day is different)
		else if (( sess.csp.week eq pl.results.stdywk ) && (session.currentDayOfWeek eq pl.results.dayofwk)) {
			iic = new query();
			iic.setDBType( "query" );	
			iic.setAttributes( srcQuery = private.lastDays.results ); 
			iic.addParam( name = "dow", value = session.currentDayOfWeek, cfsqltype = "cf_sql_numeric"  );
			iicd = iic.execute(	sql="SELECT * FROM srcQuery WHERE dayofwk < :dow" );
			iicd = iicd.getResult();
			//writedump( iicd ); abort;
			private.previous = { day=iicd.dayofwk, week=iicd.stdywk };
		}
		else {
			private.previous = { day=pl.results.dayofwk, week=pl.results.stdywk };
		}
	}

	//Define the query string ahead of time, since I'm just recycling it
	private.queryString = "
		SELECT * FROM #private.dbName# WHERE participantGUID = :pid 
			AND stdywk = :stdywk AND dayofwk = :dayofwk AND insertedby != '0'";
	
	//Select the most recent and current set of results
	private.etc = dbExec(
		//string = private.queryString, bindArgs = {
		filename = "input#iif(isEnd,DE('EE'),DE('RE'))#PastCurrent.sql", bindArgs = {
			pid = sess.current.participantId 
		 ,stdywk = sess.csp.week
		 ,dayofwk = session.currentDayOfWeek
		 ,pstdywk = private.previous.week
		 ,pdayofwk = private.previous.day
		}
	);

	//Then create the SQL needed to get the data I want for easy looping
	private.gcValues = [];
	for ( n in private.formValues ) {
		ArrayAppend( private.gcValues, "p_#private.dbPrefix##n.formName#" );
		ArrayAppend( private.gcValues, "c_#private.dbPrefix##n.formName#" );
	}

	//Now get the result
	private.getCombinedResults = new query();
	private.getCombinedResults.setDBType( "query" );	
	private.getCombinedResults.setAttributes( srcQuery = private.etc.results ); 
	private.combinedResults = private.getCombinedResults.execute(	sql="SELECT #ArrayToList(private.gcValues)# FROM srcQuery" );
	private.combinedResults = private.combinedResults.getResult();

	//If this is an RE participant, pull equipment log 
	//and get the exercise name that has been selected.
	//private.allSettingsPerExercise = {}; 
	if (ListContains(RESISTANCE, currentParticipant.results.randomGroupCode)) {
		/*
		private.eqLogX = dbExec(
			string = "SELECT * FROM #data.data.etex#"
		);
		writedump(private.eqLogX );
		abort;
		*/
		0;
	}

	//More Debugging Items 
	//writedump( session );	
	/*
	writeoutput( "<h2>LAST DAYS</h2>" ); writedump( private.lastDays );		
	writeoutput( "<h2>PREVIOUS</h2>" ); writedump( private.previousResult );		
	writeoutput( "<h2>CURRENT</h2>" ); writedump( private.currentResult );		
	abort;
	*/

	//Finally, initialize some backend AJAX magic to handle sending updates to server.
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" ) 
	 /*,showDebug = true*/
	 ,showDebug = true
	 ,additional = [ 
			{ name = "this", value = private.cssPrefix }
		 ,{ name = "sess_id", value = "#sess.key#" }
		 ,{ name = "exparam", value= "#sess.csp.exerciseParameter#" }
		 ,{ name = "recordThread", value= "#sess.csp.recordthread#" }
		 ,{ name = "pid", value = "#sess.current.participantId#" }
		 ,{ name = "dayofwk", value= "#sess.current.day#" }
		 ,{ name = "stdywk", value= "#sess.csp.week#" }
		 ,{ name = "#private.hiddenVarName#", value = "#private.magic#" }
		 ,{ name = "insBy", value = "#sgid#" }
		]
	 ,querySelector = {
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li, ##sendPageVals"
		 ,event = "click"
		 ,noPreventDefault = true
		 ,send = ".slider, .toggler-input"
		}
	);
}
</cfscript>
