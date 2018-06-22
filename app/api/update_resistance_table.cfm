<cfscript>
errstr = "Error at /api/resistance/* - ";
try {
	//Auto select exercise type if it's nowhere to be found
	if ( !StructKeyExists( form, "extype" ) )
		form.extype = 0;

	//Figure out the form type.
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

	//...
	stat = val.validate( form, {
		 pid = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,staffId = { req = false, ifNone = 1 }
		,recordThread = { req = false, ifNone = "hi" }
		,reps1 = { req = true }
		,reps2 = { req = true }
		,reps3 = { req = true }
		,weight1 = { req = true }
		,weight2 = { req = true }
		,weight3 = { req = true }
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
	sqlString = "
		INSERT INTO 
			#data.data.resistance#	
		(  participantGUID
			,recordthread
			,insertedBy
			,dayofwk
			,stdywk
			,#desig#Rep1
			,#desig#Rep2
			,#desig#Rep3
			,#desig#Wt1
			,#desig#Wt2
			,#desig#Wt3
		)
		VALUES
		(  :pid
			,:recThr
			,:insBy
			,:dwk
			,:swk
			,:rep1
			,:rep2
			,:rep3
			,:wt1
			,:wt2
			,:wt3
		);";
	}
else {
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
	qu = ezdb.exec(
		string = sqlString
	 ,datasource = "#data.source#"
 	 ,bindArgs = {
			pid      = fv.pid 
		 ,sid      = fv.sess_id
		 ,staffId  = fv.staffId 
		 ,recThr   = fv.recordThread
		 ,insBy    = "NOBODY" 
		 ,dwk      = fv.dayofwk
		 ,swk      = fv.stdywk
		 ,rep1     = fv.reps1 
		 ,rep2     = fv.weight1 
		 ,rep3     = fv.reps2 
		 ,wt1      = fv.weight2 
		 ,wt2      = fv.reps3 
		 ,wt3      = fv.weight3 
		} 
	);

	if ( !qu.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #qu.message#" );
	}
}
catch (any ff) {
	req.sendAsJson( status = 0, message = "#errstr# - #ff#" );
}
req.sendAsJson( status = 1, message = "SUCCESS at /api/resistance/* - #upd.message#" );	
abort;
</cfscript>
