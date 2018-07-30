<cfscript>
errstr = "Error at /api/resistance/* - ";
vpath = 1;
try {
	//Auto select exercise type if it's nowhere to be found
	if ( !StructKeyExists( form, "extype" ) )
		form.extype = 1;

	//Figure out the form type.
	if ( form.extype lt 1 || form.extype gt 14 ) {
		req.sendAsJson( status = 0, message = "#errstr# - Invalid exercise type #form.extype# specified." );
	}

	//Get the formname
	obj=createObject("component","components.resistance").init();
	desig = obj.getExerciseName( form.extype ).prefix;

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
			,#desig#
			,#desig#Rep1
			,#desig#Rep2
			,#desig#Rep3
			,#desig#Wt1
			,#desig#Wt2
			,#desig#Wt3
		)
		VALUES
		(  
			 :pid
			,:rthrd
			,:dtstamp
			,:insBy
			,:dwk
			,:swk
			,:exIsDone
			,:rep1
			,:rep2
			,:rep3
			,:wt1
			,:wt2
			,:wt3
		);";
	}
else {
	vpath = 1;
	sqlString = " 
		UPDATE
			#data.data.resistance#	
		SET 
			 #desig# = :exIsDone
			,#desig#Rep1 = :rep1
			,#desig#Wt1  = :wt1
			,#desig#Rep2 = :rep2
			,#desig#Wt2  = :wt2
			,#desig#Rep3 = :rep3
			,#desig#Wt3  = :wt3
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
		 //,dtstamp  = { value = DateTimeFormat( dstmp,"YYYY-MM-DD HH:nn:ss" ), type="cf_sql_date" }
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
