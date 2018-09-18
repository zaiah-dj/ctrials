<cfscript>
/* input.cfm - Controls the appearance of pages that need data. */
if ( cgi.query_string neq "" ) {
	//What type of exercise has been requested
	if ( StructKeyExists( url, "param" ) ) {
		sc.exerciseParameter = url.param;
	}

	//Select a week
	if ( StructKeyExists( url, "week" ) ) {
		sc.week = url.week;
	}
}


//Get the participant types first to figure out if there is any reason to move further.
isEnd = ListContains(const.ENDURANCE, currentParticipant.results.randomGroupCode );
isRes = ListContains(const.RESISTANCE, currentParticipant.results.randomGroupCode );


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
	private.hiddenVarName = (isEnd) ? "timeblock" : "extype";
	private.cssPrefix = partClass;
	private.proceed = true;

	if ( sc.exerciseParameter eq "" ) {
		private.proceed = false;	
		private.message = "Whoops! It looks like this user has not been checked-in yet.";
	}
	else {
		private.magic = (StructKeyExists(url, private.mpName )) ? url[ private.mpName ] : 0;
		private.magicName = (isEnd) ? "" : obj.getExerciseName( private.magic ).pname;
		private.exSetType = sc.exerciseParameter;
		private.exSetTypeLabel = private.labels[ partClass ][ sc.exerciseParameter ];
		private.dbPrefix = (isEnd) ? obj.getTimeInfo( private.magic ).prefix : obj.getExerciseName( private.magic ).prefix ;
		private.formValues = obj.getLabelsFor( sc.exerciseParameter, private.magic ); 

		private.modNames = (isEnd) ? obj.getModifiers() : obj.getSpecificModifiers( sc.exerciseParameter ); 

/*
		private.modNames = dbExec(
			string = "
				SELECT * FROM
					ac_mtr_frm_labels
				WHERE
					parttype = :pt
				AND
					class = :cls
			"
		 ,bindArgs = {
				pt = ( isEnd ) ? 0 : 1
			 ,cls = private.exSetType
			 ,pid = cs.participantId 
			}
		).results;
*/
		private.exercisesDone = dbExec(
			string = "SELECT * FROM ac_mtr_frm_progress 
				WHERE fp_participantGUID = :pid
				  AND fp_sessdayid = :sid"
		 ,bindArgs = {
				sid = csSid
			 ,pid = cs.participantId 
			}
		);

		//turn the above into an array
		//check for a number and call it a day
		private.edlist = ValueList( private.exercisesDone.results.fp_step, "," );
//writedump( private.edlist ); abort;

//writedump( private.exercisesDone ); 
//writedump( private.modNames ); abort;

		private.progress = dbExec(
			string = "
				SELECT * FROM
					ac_mtr_frm_progress
				WHERE
					fp_participantGUID = :pid
				AND
					fp_sessdayid = :sid
			"
		 ,bindArgs = {
				pid = cs.participantId 
			 ,sid = csSid
			}
		);

		//writedump( private.progress ); abort;	
	
		private.lastdays = dbExec(
			filename = "l#iif(isEnd,DE('EE'),DE('RE'))#PC.sql"
		 ,bindArgs = { 
				pid = cs.participantId 
			 ,dow = udo.object.currentDayOfWeek
			 ,cdate = { value = cdate, type = "cf_sql_date" }
			 ,stdywk = sc.week 
			}
		);

		//Select the most recent and current set of results
		private.etc = dbExec(
			filename = "input#iif(isEnd,DE('EE'),DE('RE'))#PC.sql"
		 ,bindArgs = {
				pid = cs.participantId 
			 ,stdywk = sc.week
			 ,dayofwk = udo.object.currentDayOfWeek
			 ,pstdywk = private.lastdays.results.rWeek
			 ,pdayofwk = private.lastdays.results.rDay
			}
		);

		if ( isRes ) {
			private.exBool = {
				exercise = ( private.magic gt 0 ) ? private.etc.results[ "c_#private.dbPrefix#" ] : false
			 ,superset = false
			};

			private.eqlog = dbExec(
				filename = "equipmentLogSingleMachineRETL.sql"
			 ,bindArgs = {
					pid = cs.participantId
				 ,exIndex = private.magic
				}
			);
		}

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
	}
}
</cfscript>
