<cfscript>

//writedump( userDateObject ); abort;

/* input.cfm - Controls the appearance of pages that need data. */
if ( cgi.query_string neq "" ) {
	//What type of exercise has been requested
	if ( StructKeyExists( url, "param" ) ) {
		sess.csp.exerciseParameter = url.param;
	}

	//Select a week
	if ( StructKeyExists( url, "week" ) ) {
		sess.csp.week = url.week;
	}
}


//Get the participant types first to figure out if there is any reason to move further.
isEnd = ListContains(ENDURANCE, currentParticipant.results.randomGroupCode );
isRes = ListContains(RESISTANCE, currentParticipant.results.randomGroupCode );


//If moving forward, then start calculations
if ( isEnd || isRes ) {
	//Define these for the purposes of this model
	private = {};
	public = {};

	//Define static data here for easy editing
	private.labels = {
		endurance = [ "Cycle", "Treadmill", "Other" ] 
	,	resistance = [ "Hips/Thighs", "Chest/Shoulders..." ]
	};

	//Figure out The text name will do a lot
	partClass = ( isEnd ) ? "endurance" : "resistance";	

	//Set variables based on selection type
	obj = CreateObject( "component", "components.#partClass#" ).init();	
	private.dbName = (isEnd) ? "#data.data.endurance#" : "#data.data.resistance#";
	private.mpName = (isEnd) ? "time" : "extype";
	private.hiddenVarName= (isEnd) ? "timeblock" : "extype";
	private.cssPrefix = partClass;
	private.proceed = true;

	if ( sess.csp.exerciseParameter eq "" ) {
		private.proceed = false;	
		private.message = "
			Whoops!
			It looks like this user has not been checked-in yet."
		;	
	}
	else {
		private.magic = (StructKeyExists(url, private.mpName )) ? url[ private.mpName ] : 0;
		private.magicName = (isEnd) ? "" : obj.getExerciseName( private.magic ).pname;
		private.exSetType = sess.csp.exerciseParameter;
		private.exSetTypeLabel = private.labels[ partClass ][ sess.csp.exerciseParameter ];
		//private.modNames = (isEnd) ? obj.getModifiers() : dbExec(filename="elExercises.sql", bindArgs={ord=(sess.csp.exerciseParameter==1) ? 0 : 7}).results;
		//private.modNames = (isEnd) ? obj.getModifiers() : obj.getAllModifiers( ); 
		private.modNames = (isEnd) ? obj.getModifiers() : obj.getSpecificModifiers( sess.csp.exerciseParameter ); 
		private.dbPrefix = (isEnd) ? obj.getTimeInfo( private.magic ).prefix : obj.getExerciseName( private.magic ).prefix ;
		private.formValues = obj.getLabelsFor( sess.csp.exerciseParameter, private.magic ); 

		//
		if ( isRes ) {
			private.eqlog = dbExec(
				filename = "equipmentLogSingleMachineRETL.sql"
			 ,bindArgs = {
					pid = sess.current.participantId
				 ,exIndex = private.magic
				}
			);
		}

		//t = { cweek = sess.csp.week, dow = currentDayOfWeek };
		private.lastdays = dbExec(
			filename = "l#iif(isEnd,DE('EE'),DE('RE'))#PC.sql"
		 ,bindArgs = { 
				pid = sess.current.participantId 
			 ,dow = currentDayOfWeek
			 ,cdate = { value = userDateObject, type = "cf_sql_date" }
			 ,stdywk = sess.csp.week 
			}
		);

//writedump( userDateObject );
		//writedump( private.lastDays ); abort;

		//Select the most recent and current set of results
		private.etc = dbExec(
			filename = "input#iif(isEnd,DE('EE'),DE('RE'))#PC.sql"
		 ,bindArgs = {
				pid = sess.current.participantId 
			 ,stdywk = sess.csp.week
			 ,dayofwk = session.currentDayOfWeek
			 //,pstdywk = private.previous.week
			 //,pdayofwk = private.previous.day
			 ,pstdywk = private.lastdays.results.rWeek
			 ,pdayofwk = private.lastdays.results.rDay
			}
		);

		//writedump(private.lastDays); writedump(private.etc); abort;

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

		/*
		writedump( session );	
		writeoutput( "<h2>LAST DAYS</h2>" ); writedump( private.lastDays );		
		writeoutput( "<h2>PREVIOUS</h2>" ); writedump( private.etc );		
		abort;
		*/

		//Finally, initialize some backend AJAX magic to handle sending updates to server.
		AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
			location = link( "update.cfm" ) 
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
		//writedump( private ); abort;
	}
}
</cfscript>
