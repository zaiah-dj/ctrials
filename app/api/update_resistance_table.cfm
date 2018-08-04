<cfscript>
errstr = "Error at /api/resistance/* - ";
vpath = 1;
try {
	//Check that some type of exercise has been specified in the request.
	if ( !StructKeyExists( form, "extype" ) ) {
		req.sendAsJson( status = 0, message = "#errstr# - No exercise type specified." );
	}

	//Figure out the form type.
	if ( form.extype lt 0 || form.extype gt 14 ) {
		req.sendAsJson( status = 0, message = "#errstr# - Invalid exercise type #form.extype# specified." );
	}

	//Fill warmup
	isWarmup = ( form.extype eq 0 ); 

	//Get the formname
	desig = dbExec(
		filename = "elExerciseName.sql", 
		bindArgs = { id = form.extype }
	).results.prefix;

//req.sendAsJson( status=0, message='#SerializeJSON(desig)#' ); 
req.sendAsJson( status=0, message='{ "weighttype": "#desig#" }' );

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
	upd = ezdb.exec( 
		string = "
		SELECT * FROM 
			#data.data.resistance#	
		WHERE participantGUID = :pid
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk
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
			,recordthread
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
			,:rthrd
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
			#iif(isWarmup,DE(''),DE('#desig# = :exIsDone'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep1 = :rep1'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt1  = :wt1'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep2 = :rep2'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt2  = :wt2'))#
			#iif(isWarmup,DE(''),DE(',#desig#Rep3 = :rep3'))#
			#iif(isWarmup,DE(''),DE(',#desig#Wt3  = :wt3'))#
			#iif(isWarmup,DE(' #desig#hr = :hr'),DE(''))#	
			#iif(isWarmup,DE(',#desig#rpe = :rpe'),DE(''))#	
			#iif(isWarmup,DE(',#desig#othafct :othafct'),DE(''))#	
			,d_inserted  = :dtstamp
			,insertedBy  = :insBy
		WHERE
			participantGUID = :pid
		AND
			recordthread = :rthrd
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

	qu = ezdb.exec(
		string = sqlString
	 ,datasource = "#data.source#"
 	 ,bindArgs = {
			pid      = fv.pid 
		 ,sid      = fv.sess_id
		 ,rthrd    = fv.recordThread
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
		 ,hr = fv.hr
		 ,rpe = fv.rpe
		 ,othafct = fv.othafct
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

abort;
</cfscript>
