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
	
		//Select the last days with data 	
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
			//Out of laziness, I'm just going to hit the db again to figure out which superset this is for.
			supsup = dbExec( 
				string = "SELECT * FROM ac_mtr_retl_superset_bodypart 
					WHERE d_visit = :t AND participantGUID = :pid AND exercise = :ex"
			, bindArgs = { 
					pid = cs.participantId
				, ex = private.magic 
				,	t = { value = cdate, type = "cf_sql_date" } 
				}
			);

			private.exBool = {
				exercise = ( private.magic gt 0 ) ? private.etc.results[ "c_#private.dbPrefix#" ] : false
			 ,superset = ( supsup.prefix.recordCount gt 0 ) 
			};

			private.eqlog = dbExec(
				filename = "equipmentLogSingleMachineRETL.sql"
			 ,bindArgs = {
					pid = cs.participantId
				 ,exIndex = private.magic
				}
			);

			private.allSettings = dbExec(
				filename = "equipmentSettings.sql"
			 ,bindArgs = {
					pid = cs.participantId
				}
			);

			if ( private.magic eq 1 ) settings_prefix = "leg";
			else if ( private.magic eq 2 ) settings_prefix = "modleg";
			else if ( private.magic eq 3 ) settings_prefix = "pull";
			else if ( private.magic eq 4 ) settings_prefix = "legcurl";
			else if ( private.magic eq 5 ) settings_prefix = "seatrow";
			else if ( private.magic eq 6 ) settings_prefix = "knee";
			else if ( private.magic eq 7 ) settings_prefix = "bicep";
			else if ( private.magic eq 8 ) settings_prefix = "chest";
			else if ( private.magic eq 9 ) settings_prefix = "chest2";
			else if ( private.magic eq 10 ) settings_prefix = "abs";
			else if ( private.magic eq 11 ) settings_prefix = "overhead";
			else if ( private.magic eq 12 ) settings_prefix = "calf";
			else if ( private.magic eq 13 ) settings_prefix = "shoulder";
			else if ( private.magic eq 14 ) settings_prefix = "triceps";

			//In the settings table, these are the column name suffixes
			private.showResl = 0;
			private.reslValues = [];
			private.reslStatic = [
			/*	"machine"
			 ,"manufacture" */
			  "setting1na"
			 ,"setting1"
			 ,"setting2na"
			 ,"setting2"
			 ,"setting3na"
			 ,"setting3"
			 ,"setting4na"
			 ,"setting4"
			];

			//We loop through and concatenate them all with an underscore for column names 
			if ( isDefined( "settings_prefix" ) ) {
				for ( n in private.reslStatic ) {
					ArrayAppend( private.reslValues, "#settings_prefix#_#n# as #n#" );
				}

				//Now get the result
				private.getSettings = new query();
				private.getSettings.setDBType( "query" );	
				private.getSettings.setAttributes( srcQuery = private.allSettings.results ); 
				private.settingsThin = private.getSettings.execute(	
					sql="SELECT #ArrayToList(private.reslValues)# FROM srcQuery" );
				private.settings = private.settingsThin.getResult();
				private.showResl = 1;
			}
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
