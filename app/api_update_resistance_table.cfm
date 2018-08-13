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
	/*
	//This should work but it's crashing every time, why?
	obj = CreateObject( "component", "components.resistance" );
	desig = obj.getExerciseName( form.extype ).prefix;
	*/
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
/*
	//Get the formname
	desig = dbExec(
		filename = "elExerciseName.sql", 
		bindArgs = { id = form.extype }
	).results.prefix;

	//...
	if ( desig eq "leg" )
		desig = "legpress";
	else if ( desig eq "modleg" )
		desig = "dumbbellsquat";
	else if ( desig eq "pull" )
		desig = "pulldown";
	else if ( desig eq "legcurl" )
		desig = "legcurl";
	else if ( desig eq "seatrow" )
		desig = "seatedrow";
	else if ( desig eq "knee" )
		desig = "kneeextension";
	else if ( desig eq "bicep" )
		desig = "bicepcurl";
	else if ( desig eq "chest" )
		desig = "chestpress";
	else if ( desig eq "chest2" )
		desig = "chest2";
	else if ( desig eq "abs" )
		desig = "abdominalcrunch";
	else if ( desig eq "overhead" )
		desig = "overheadpress";
	else if ( desig eq "calf" )
		desig = "calfpress";
	else if ( desig eq "shoulder" )
		desig = "shoulder2";
	else if ( desig eq "triceps" )
		desig = "triceppress";
	else {
		desig = "wrmup_";
	}
*/

//req.sendAsJson( status=0, message='{ "weighttype": "#desig#" }' );

	//...
	stat = val.validate( form, {
		 pid = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,insBy = { req = true }
		,is_exercise_done = { req = true }
		,is_superset = { req = true }
		,recordThread = { req = false, ifNone = "hi" }
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

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #stat.message#" );	
	}

	fv = stat.results;

	//Check what was submitted from metadata
	fv.exIsDone = 0;	
	if ( fv.is_exercise_done eq "on" && fv.is_superset eq "on" ) 
		fv.exIsDone = 2;
	else if	( fv.is_exercise_done eq "on" )
		fv.exIsDone = 1;

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
/*
req.sendAsJson( status = 0, message = "#fv.pid#, #fv.stdywk#, #fv.dayofwk#" ); 
req.sendAsJson( status = 0, message = "#fv.pid#" ); 
req.sendAsJson( status = 0, message = "#fv.pid#" ); 
req.sendAsJson( status = 0, message = "#SerializeJSON(upd.results)#" ); 
*/
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

//req.sendAsJson( status=0, message='#sqlString# - #SerializeJSON(fv)#' ); 

//Then perform the query
try {
	//This is in case I find myself modifying dates from other times
	dstmp = LSParseDateTime( 
		"#session.currentYear#-#session.currentMonth#-#session.currentDayOfMonth# "
		& DateTimeFormat( Now(), "HH:nn:ss" )
	);

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
		req.sendAsJson( status = 0, message = "#errstr# - #qu.message#" );
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
