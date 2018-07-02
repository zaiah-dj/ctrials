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
	desig = obj.getExerciseName( form.extype ).formName;

/*	
	if ( form.extype == 0 || form.extype == 1 )
		desig = "abdominalcrunch";
	else if ( form.extype == 2 )
		desig = "bicepcurl";
	else if ( form.extype == 3 )
		desig = "calfpress";
	else if ( form.extype == 4 )
		desig = "chest2";
	else if ( form.extype == 5 )
		desig = "chestpress";
	else if ( form.extype == 6 )
		desig = "dumbbellsquat";
	else if ( form.extype == 7 )
		desig = "kneeextension";
	else if ( form.extype == 8 )
		desig = "legcurl";
	else if ( form.extype == 9 )
		desig = "legpress";
	else if ( form.extype == 10 )
		desig = "overheadpress";
	else if ( form.extype == 11 )
		desig = "pulldown";
	else if ( form.extype == 12 )
		desig = "seatedrow";
	else if ( form.extype == 13 )
		desig = "shoulder2";
	else if ( form.extype == 14 ) {
		desig = "triceppress";
	}
*/

	//...
	stat = val.validate( form, {
		 pid = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,staffid = { req = true }
		,recordThread = { req = false, ifNone = "hi" }
		/*
		,reps1 = { req = true }
		,reps2 = { req = true }
		,reps3 = { req = true }
		,weight1 = { req = true }
		,weight2 = { req = true }
		,weight3 = { req = true }
		*/
		,Rep1 = { req = true }
		,Rep2 = { req = true }
		,Rep3 = { req = true }
		,Wt1  = { req = true }
		,Wt2  = { req = true }
		,Wt3  = { req = true }
	});	

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #stat.message#" );	
	}

	fv = stat.results;

	//Insert or update if the row is not there...
	upd = ezdb.exec( 
		string = "
		SELECT * 
		FROM 
			#data.data.resistance#	
		WHERE 
			participantGUID = :pid
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
			,insertedBy
			,dayofwk
			,stdywk
			,staffID
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
			,:insBy
			,:dwk
			,:swk
			,:staff_id
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
			 #desig#Rep1 = :rep1
			,#desig#Wt1  = :wt1
			,#desig#Rep2 = :rep2
			,#desig#Wt2  = :wt2
			,#desig#Rep3 = :rep3
			,#desig#Wt3  = :wt3
			,staffID     = :staff_id
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
	qu = ezdb.exec(
		string = sqlString
	 ,datasource = "#data.source#"
 	 ,bindArgs = {
			pid      = fv.pid 
		 ,sid      = fv.sess_id
		 ,staff_id = fv.staffId 
		 ,rthrd    = fv.recordThread
		 ,insBy    = "NOBODY" 
		 ,dwk      = fv.dayofwk
		 ,swk      = fv.stdywk
		 ,rep1     = fv.Rep1 
		 ,rep2     = fv.Wt1 
		 ,rep3     = fv.Rep2 
		 ,wt1      = fv.Wt2 
		 ,wt2      = fv.Rep3 
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

	message = ( !vpath ) ? 
		"SUCCESS @ /api/resistance/* - Inserted into #data.data.resistance# with values #SerializeJSON( fv )#" :
		"SUCCESS @ /api/resistance/* - Updated #data.data.resistance# with values #SerializeJSON( fv )#"

);	

abort;
</cfscript>
