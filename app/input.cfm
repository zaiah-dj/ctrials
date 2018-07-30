<cfscript>
/* input.cfm - Controls the appearance of pages that need data. */

//If no one is selected, do nothing
if ( currentParticipant.prefix.recordCount eq 0 ) 
	0;

//Get the participant types first to figure out if there is any reason to move further.
isEnd = ListContains(ENDURANCE, currentParticipant.results.randomGroupCode );
isRes = ListContains(RESISTANCE, currentParticipant.results.randomGroupCode );

//If moving forward, then start calculations
if ( !isEnd && !isRes ) 
	0;
else {
	//Define these for the purposes of this model
	private = {};
	public = {};

	//Define static data here for easy editing
	private.labels = [ "Cycle", "Treadmill", "Other", "Hips/Thighs", "Chest" ];

	//Figure out The text name will do a lot
	partClass = ( isEnd ) ? "endurance" : "resistance";	

	//Set variables based on selection type
	obj = CreateObject( "component", "components.#partClass#" ).init();	
	private.dbName = ( isEnd ) ? "#data.data.endurance#" : "#data.data.resistance#";
	private.mpName = (isEnd) ? "time" : "extype";
	private.hiddenVarName= (isEnd) ? "timeblock" : "extype";
	private.rp = (isRes) ? ((sess.csp.exerciseParameter eq 4) ? 1 : 3 ) : 0;
	private.magic = (StructKeyExists(url, private.mpName )) ? url[ private.mpName ] : private.rp;
	private.magicName = "SELECTED EXERCISE";
	private.exSetType = sess.csp.exerciseParameter;
	private.exSetTypeLabel = private.labels[ sess.csp.exerciseParameter ];
	private.modNames = (isEnd) ? obj.getModifiers() : obj.getSpecificModifiers( private.exSetType );
	//private.dbPrefix = (private.magic eq 50) ? "m5_rec" : obj.getTimeInfo(private.magic).label;
	private.dbPrefix = (isEnd) ? obj.getTimeInfo( private.magic ).prefix : obj.getExerciseName( private.magic ).prefix ;
	private.cssPrefix = partClass;
	private.formValues = (isEnd) ? obj.getLabelsFor( sess.csp.exerciseParameter, private.magic ) : obj.getLabels();


	//Check check-in completed first (the tab should have at least been visited)
	//sess.csp.checkInCompleted = 1;

	//Select the last two days for this user.
	private.lastdays = dbExec(
		string = "SELECT dayofwk, stdywk FROM #private.dbName# 
			WHERE participantGUID = :pid AND stdywk <= :stdywk"
	 ,bindArgs = { 
			pid = sess.current.participantId 
		 ,stdywk = session.currentWeek
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
		//2 or more are there, make sure you choose correctly
		private.previous= { day=0, week=0 };
	}
	
	//Define the query string ahead of time, since I'm just recycling it
	private.queryString = "
		SELECT * FROM #private.dbName# WHERE participantGUID = :pid 
			AND stdywk = :stdywk AND dayofwk = :dayofwk";
	
	//Select the most recent set of results
	private.previousResult = dbExec(
		string = private.queryString, bindArgs = {
			pid = sess.current.participantId 
		 ,stdywk = private.previous.week
		 ,dayofwk = private.previous.day
		}
	);

	//Now, select the most recent result
	private.currentResult = dbExec(
		string = private.queryString, bindArgs = {
			pid = sess.current.participantId 
		 ,stdywk = sess.csp.week
		 ,dayofwk = session.currentDayOfWeek 
		}
	); 

	//To make it easy to use this data within a template, combine these two queries
	//the form values, prevResult and currentResult all should come together,
	//super-wide columns, but this is far better than other stuff

	//Loop through each query
	private.queryCreator = { names = [], types = [], values = {} }; 
	for ( n in ListToArray( private.previousResult.prefix.columnList )) {
		ArrayAppend( private.queryCreator.names, "p_#n#");
		ArrayAppend( private.queryCreator.types, "Varchar");
		private.queryCreator.values[ "p_#n#" ] = private.previousResult.results[ n ]; 
		ArrayAppend( private.queryCreator.names, "c_#n#");
		ArrayAppend( private.queryCreator.types, "Varchar");
		private.queryCreator.values[ "c_#n#" ] = private.currentResult.results[ n ]; 
	}

	//Create a query object
	private.combinerQuery = queryNew(
		ArrayToList(private.queryCreator.names),
		ArrayToList(private.queryCreator.types),
		private.queryCreator.values );

	//Then create the SQL needed to get the data I want for easy looping
	private.gcValues = [];
	for ( n in private.formValues ) {
		ArrayAppend( private.gcValues, "p_#private.dbPrefix##n.formName#" );
		ArrayAppend( private.gcValues, "c_#private.dbPrefix##n.formName#" );
	}

	//Now get the result
	private.getCombinedResults = new query();
	private.getCombinedResults.setDBType( "query" );	
	private.getCombinedResults.setAttributes( srcQuery = private.combinerQuery ); 
	private.combinedResults = private.getCombinedResults.execute(	sql="SELECT #ArrayToList( private.gcValues)# FROM srcQuery" );
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
	//writedump( private );	

	//Finally, initialize some backend AJAX magic to handle sending updates to server.
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" ) 
	 /*,showDebug = true*/
	 ,showDebug = true
	 ,additional = [ 
			{ name = "this", value = private.cssPrefix }
		 ,{ name = "sess_id", value = "#sess.key#" }
		 ,{ name="exParam", value= "#sess.csp.exerciseParameter#" }
		 ,{ name = "recordThread", value= "#sess.csp.recordthread#" }
		 ,{ name = "pid", value = "#sess.current.participantId#" }
		 ,{ name = "dayofwk", value= "#sess.current.day#" }
		 ,{ name = "stdywk", value= "#sess.csp.week#" }
		 ,{ name = "extype", value = "#private.magic#" }
		 ,{ name = "insBy", value = "#sgid#" }
		]
	 ,querySelector = {
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li, ##sendPageVals"
		 ,event = "click"
		 ,noPreventDefault = true
		 ,send = ".slider"
		}
	);
}
</cfscript>
