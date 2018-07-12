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

	//Where do the supersets go?	
	temp = val.validate( form, {
	});	

	//...
	stat = val.validate( form, {
		 pid = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,staffid = { req = true }
		,set = { req = true }
		,recordThread = { req = false, ifNone = "hi" }
		,Rep1 = { req = ( form.set == 1 ), ifNone = 0 }
		,Rep2 = { req = ( form.set == 2 ), ifNone = 0 }
		,Rep3 = { req = ( form.set == 3 ), ifNone = 0 }
		,Wt1  = { req = ( form.set == 1 ), ifNone = 0 }
		,Wt2  = { req = ( form.set == 2 ), ifNone = 0 }
		,Wt3  = { req = ( form.set == 3 ), ifNone = 0 }
		,SuRep1 = { req = ( form.set == 4 ), ifNone = 0 }
		,SuRep2 = { req = ( form.set == 5 ), ifNone = 0 }
		,SuRep3 = { req = ( form.set == 6 ), ifNone = 0 }
		,SuWt1  = { req = ( form.set == 4 ), ifNone = 0 }
		,SuWt2  = { req = ( form.set == 5 ), ifNone = 0 }
		,SuWt3  = { req = ( form.set == 6 ), ifNone = 0 }
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# - #stat.message#" );	
	}

	fv = stat.results;

	if ( fv.set gt 3 ) {
		req.sendAsJson( status = 1, message = "Can't update supersets yet." );
	} 

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
