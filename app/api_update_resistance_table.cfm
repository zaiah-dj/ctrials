<cfscript>
errstr = "Error at /api/resistance/* - ";
vpath = 1;

try {
	//Check that some type of exercise has been specified in the request.
	if ( !StructKeyExists( form, "extype" ) ) {
		req.sendAsJson(status = 0, message = "#errstr# - No exercise type specified.");
	}

	//Figure out the form type.
	if ( form.extype lt 0 || form.extype gt 14 ) {
		req.sendAsJson( status = 0, message = "#errstr# - Invalid exercise type #form.extype# specified." );
	}

	//Fill warmup
	isWarmup = ( form.extype eq 0 ); 

	//Desig
	if ( form.extype eq 1 ) desig = "legpress";
	else if ( form.extype eq 2 ) desig = "modleg";
	else if ( form.extype eq 3 ) desig = "pulldown";
	else if ( form.extype eq 4 ) desig = "legcurl";
	else if ( form.extype eq 5 ) desig = "seatedrow";
	else if ( form.extype eq 6 ) desig = "kneeextension";
	else if ( form.extype eq 7 ) desig = "bicepcurl";
	else if ( form.extype eq 8 ) desig = "chestpress";
	else if ( form.extype eq 9 ) desig = "chest2";
	else if ( form.extype eq 10 ) desig = "abdominalcrunch";
	else if ( form.extype eq 11 ) desig = "overheadpress";
	else if ( form.extype eq 12 ) desig = "calfpress";
	else if ( form.extype eq 13 ) desig = "shoulder2";
	else if ( form.extype eq 14 ) desig = "triceppress";
	else desig = "wrmup_";

	extype = StructKeyExists( form, "extype" ) ? form.extype : 0;

	//...
	stat = cmValidate( form, {
		 pid = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,insBy = { req = true }
		,hrMonitor = { req = (isWarmup), ifNone = false }
		,is_exercise_done = { req = false, ifNone = false }
		,is_superset = { req = false, ifNone = false }
		,recordThread = { req = false, ifNone = false }
		,Rep1 = { req = false, ifNone = 0 }
		,Rep2 = { req = false, ifNone = 0 }
		,Rep3 = { req = false, ifNone = 0 }
		,Wt1  = { req = false, ifNone = 0 }
		,Wt2  = { req = false, ifNone = 0 }
		,Wt3  = { req = false, ifNone = 0 }
		,hr = { req = (isWarmup), ifNone = 0 }
		,rpe = { req = (isWarmup), ifNone = 0 }
		,othafct = { req = (isWarmup), ifNone = 0 }
	});

	//...
	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #stat.message#" );	
	}

	fv = stat.results;

	//Change hrMonitor
	if ( StructKeyExists( fv, "hrMonitor" ) ) {
		fv.hrMonitor = ( fv.hrMonitor eq "on" ) ? 1 : 0;
	}

	//Check what was submitted from metadata
	fv.exIsDone = ( fv.is_exercise_done eq "on" );
/* 
	if ( fv.is_exercise_done eq "on" && fv.is_superset eq "on" ) 
		fv.exIsDone = 2;
	else if	( fv.is_exercise_done eq "on" )
		fv.exIsDone = 1;
*/

	//Insert or update if the row is not there...
	upd = dbExec( 
		string = "
		SELECT 
			participantGUID 
		FROM 
			#data.data.resistance#	
		WHERE 
			participantGUID = :pid
		AND 
			stdywk = :stdywk
		AND 
			dayofwk = :dayofwk
		"
		,bindArgs = { 
			pid = fv.pid
		 ,stdywk = fv.stdywk
		 ,dayofwk = fv.dayofwk
		}
	);

	if ( !upd.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #upd.message#" );
	}
}
catch (any ff) {
	req.sendAsJson( status = 0, message = "#errstr# - #ff#" );
}


//Choose a SQL statment
sqlStatement = "";
if ( !upd.prefix.recordCount ) {
	vpath = 0;
	sqlString = "
		INSERT INTO 
			#data.data.resistance#	
		(  
			 participantGUID
			,d_inserted
			,insertedBy
			,dayofwk
			,stdywk
	 		#iif(isWarmup,DE(''),DE(',hrworking'))#
			#iif(isWarmup,DE(''),DE(',#desig#'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep1'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep2'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep3'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt1'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt2'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt3'))#
			#iif(isWarmup,DE(',#desig#hr'),DE(''))#	
			#iif(isWarmup,DE(',#desig#rpe'),DE(''))#	
			#iif(isWarmup,DE(',#desig#othafct'),DE(''))#	
		)
		VALUES
		(  
			 :pid
			,:dtstamp
			,:insBy
			,:dwk
			,:swk
	 		#iif(isWarmup,DE(''),DE(',:hrworking'))#
			#iif(isWarmup,DE(''),DE(',:exIsDone'))#
			#iif(isWarmup,DE(''),DE(',:rep1'))#
			#iif(isWarmup,DE(''),DE(',:rep2'))#
			#iif(isWarmup,DE(''),DE(',:rep3'))#
			#iif(isWarmup,DE(''),DE(',:wt1'))#
			#iif(isWarmup,DE(''),DE(',:wt2'))#
			#iif(isWarmup,DE(''),DE(',:wt3'))#
			#iif(isWarmup,DE(',:hr'),DE(''))#	
			#iif(isWarmup,DE(',:rpe'),DE(''))#	
			#iif(isWarmup,DE(',:othafct'),DE(''))#	
		);";
	}
else {
	vpath = 1;
	sqlString = " 
		UPDATE
			#data.data.resistance#	
		SET 
			 d_inserted  = :dtstamp
			,insertedBy  = :insBy
			#iif(isWarmup,DE(''),DE(',hrWorking = :hrworking'))#
			#iif(isWarmup,DE(''),DE(',#desig# = :exIsDone'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep1 = :rep1'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt1  = :wt1'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep2 = :rep2'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt2  = :wt2'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep3 = :rep3'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt3  = :wt3'))#
			#iif(isWarmup,DE(',#desig#hr = :hr'),DE(''))#	
			#iif(isWarmup,DE(',#desig#rpe = :rpe'),DE(''))#	
			#iif(isWarmup,DE(',#desig#othafct = :othafct'),DE(''))#	
		WHERE
			participantGUID = :pid
		AND
			stdywk = :swk
		AND
			dayofwk = :dwk
		";
}

//Then perform the query
try {
	//This is in case I find myself modifying dates from other times
	dstmp = LSParseDateTime( 
		"#session.currentYear#-#session.currentMonth#-#session.currentDayOfMonth# "
		& DateTimeFormat( Now(), "HH:nn:ss" )
	);
/*
	//req.sendAsJson( status=0, message='#sqlString# - #SerializeJSON(fv)#' ); abort;
	qu = dbExec(
		string = sqlString
	 ,datasource = "#data.source#"
 	 ,bindArgs = {
			pid      = fv.pid 
		 ,sid      = fv.sess_id
		 ,dtstamp  = { value = dstmp, type="cf_sql_date" }
		 ,exIsDone = fv.exIsDone 
		 ,insBy    = fv.insBy
		 ,hrworking= fv.hrMonitor
		 ,dwk      = fv.dayofwk
		 ,swk      = fv.stdywk
		 ,rep1     = fv.Rep1 
		 ,rep2     = fv.Rep2 
		 ,rep3     = fv.Rep3
		 ,wt1      = fv.Wt1 
		 ,wt2      = fv.Wt2
		 ,wt3      = fv.Wt3 
		 ,hr       = fv.hr
		 ,rpe      = fv.rpe
		 ,othafct  = fv.othafct
		} 
	);

	if ( !qu.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - QU - #qu.message#" );
	}
*/
	//If a superset was submitted save it.  there can only be a max of 6 submitttals,
	//have to check betweeen one two and three for the records in frm_retl
	if ( fv.is_superset eq "on" ) {
		//Grab the superset values from today and check if any are done
		supCheck = dbExec(
			string = "
				SELECT 
					bp1set1	
				 ,bp1set2	
				 ,bp1set3	
				 ,bp2set1	
				 ,bp2set2	
				 ,bp2set3	
				FROM
					frm_retl
				WHERE
					d_visit = :today
				AND
					participantGUID = :pid
			"
		 ,bindArgs = {
				today = { value = dstmp, type = "cf_sql_date" } 
			 ,pid = fv.pid
			}	
		);

		//the values save, but there is no exercise type.  problem is, I can't recall the selection this way...
		//either I create my own table to store this, or modify frm_retl
		res = [ 
			supCheck.results.bp1set1	
		 ,supCheck.results.bp1set2	
		 ,supCheck.results.bp1set3	
		 ,supCheck.results.bp2set1	
		 ,supCheck.results.bp2set2	
		 ,supCheck.results.bp2set3	
		];

		//If bp1set1 and bp2set2 are both filled, it's likely that the supersets are completed
		
		maxSupersets = ArrayFind( res, 0 ); 
		//req.sendAsJson( status=1, message="#ArrayToList( res )#" );	
		//req.sendAsJson( status=1, message="#maxSupersets#" );	

		if ( maxSupersets <= 4 ) {
			if ( maxSupersets < 3 ) {
				res[ 1 ] = ( res[ 1 ] > 0 ) ? res[ 1 ] : fv.Wt1;
				res[ 2 ] = ( res[ 2 ] > 0 ) ? res[ 2 ] : fv.Wt2;
				res[ 3 ] = ( res[ 3 ] > 0 ) ? res[ 3 ] : fv.Wt3;
			//exname = ?
			}
			else {
				res[ 4 ] = ( res[ 4 ] > 0 ) ? res[ 4 ] : fv.Wt1;
				res[ 5 ] = ( res[ 5 ] > 0 ) ? res[ 5 ] : fv.Wt2;
				res[ 6 ] = ( res[ 6 ] > 0 ) ? res[ 6 ] : fv.Wt3;
			//exname = ?
			}
			
			//req.sendAsJson( status=1, message="#ArrayToList( res )#" );	
			
			add = dbExec( 
				string = "
					UPDATE	
						frm_retl
					SET 
						bp1set1 = :b1s1	
					 ,bp1set2 = :b1s2	
					 ,bp1set3 = :b1s3	
					 ,bp2set1 = :b2s1	
					 ,bp2set2 = :b2s2	
					 ,bp2set3 = :b2s3	
					WHERE
						d_visit = :today
					AND
						participantGUID = :pid
					"
				,bindArgs = {
					b1s1 = ( res[ 1 ] )
				 ,b1s2 = ( res[ 2 ] )
				 ,b1s3 = ( res[ 3 ] )
				 ,b2s1 = ( res[ 4 ] )
				 ,b2s2 = ( res[ 5 ] )
				 ,b2s3 = ( res[ 6 ] )
				 ,today = { value = dstmp, type = "cf_sql_date" } 
				 ,pid = fv.pid
				}	
			);

req.sendAsJson( status = 1, message = "#SerializeJSON(add)#" );
			
		}
	}

req.sendAsJson( status = 1, message = "#errstr# - superset done" );
	//Write progress
	prog = dbExec(
		string = "
		SELECT * FROM
			ac_mtr_frm_progress
		WHERE
			fp_participantGUID = :pid
		AND
			fp_step = :step
		"
	 ,bindArgs = {
			pid = fv.pid
		 ,step = extype
		}
	);

	if ( !prog.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #prog.message#" );
	}

	//req.sendAsJson( status = 1, message = "#errstr# - #prog.prefix.recordCount#" );

	//If there is anything here, add a row
	if ( prog.prefix.recordCount eq 0 ) {
		prog = dbExec(
			string = "
			INSERT INTO	ac_mtr_frm_progress
				( fp_step, fp_participantGUID, fp_sessdayid )
			VALUES 
				( :step, :pid, :sdid )
			"
		 ,bindArgs = {
				step = extype
			 ,pid = fv.pid
			 ,sdid = csSid
			}
		);

		if ( !prog.status ) {
			req.sendAsJson( status = 0, message = "#errstr# - #prog.message#" );
		}
	}
}
catch (any ff) {
	req.sendAsJson( status = 0, message = "#errstr# - #ff#" );
}

req.sendAsJson( 
	status = 1, 
	message = "SUCCESS @ /api/resistance/* - " &
		"#iif(!vpath,DE('Inserted'),DE('Updated'))# into " &
		"#data.data.resistance# with values #SerializeJSON( fv )#" 
);	
</cfscript>
