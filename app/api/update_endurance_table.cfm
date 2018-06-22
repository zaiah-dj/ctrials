<cfscript>
//Define an error string for use throughout this part
errstr = "Error at /api/endurance/* - ";
try {
	//Differentiate between Cycles, Treadmills and Other
	CYCLE = 1;
	TREADMILL = 2;
	OTHER = 3;

	//Stop if no type was found
	if ( !StructKeyExists( form, "exParam" ) ) {
		req.sendAsJson( 
			status = 0, 
			message = "#errstr# Parameter 'exParam' " &
								"is not available in FORM (Can't " &
								"tell exercise type... so can't move further.)" 
		);
	}

	//Pull all required values out of the form scope.
	stat = val.validate( form, { 
		 pid = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,timeblock = { req = true }
		,affect = { req = true }
		,staffId = { req = false, ifNone = 1 }
		,mchntype = { req = false, ifNone = form.exParam }
		,rpm = { req = (form.exParam eq CYCLE), ifNone = 0 }
		,watts_resistance = { req = (form.exParam eq CYCLE), ifNone = 0 }
		,grade = { req = (form.exParam eq TREADMILL), ifNone = 0 }
		,speed = { req = (form.exParam eq TREADMILL), ifNone = 0 }
		,oth1 = { req = (form.exParam eq OTHER), ifNone = 0 }
		,oth2 = { req = (form.exParam eq OTHER), ifNone = 0 }
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}

	//Set fv to validated form values	
	fv = stat.results;

	//Figure out the form field name 
	desig = "";
	if ( fv.timeblock eq 0 )
		desig = "wrmup_";
	else if ( fv.timeblock gt 45 )
		desig = "m5_rec";
	else { 
		desig = "m#fv.timeblock#_ex";
	}

	//Check for the presence of a field already
	upd = ezdb.exec( 
		string = "
		SELECT * FROM 
			#data.data.endurance#	
		WHERE
			participantGUID = :pid
		AND stdywk = :stdywk
		AND dayofwk = :dayofwk
		"
	 ,datasource="#data.source#"
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
catch (any thing) {
	req.sendAsJson( status = 0, message = "#errstr# makes no sense - #thing#" );	
	abort;
}


sqlString = "";
if ( !upd.prefix.recordCount ) {
	sqlString = "
	INSERT INTO #data.data.endurance#	
	( participantGUID
	 ,insertedBy
	 ,mchntype
	 ,#desig#oth1
	 ,#desig#oth2
	 ,#desig#prctgrade
	 ,#desig#rpm
	 ,#desig#speed
	 ,#desig#watres  
	 ,dayofwk
	 ,stdywk
	 ,staffid
	)
	VALUES
	(  :pid
		,:insertedby
		,:mchntype
		,:oth1
		,:oth2
		,:prctgrade
		,:rpm
		,:speed
		,:watres
		,:dwk
		,:swk
		,:staffid
	)";
}
else {
	sqlString = "
	 UPDATE 
		#data.data.endurance#	
	 SET
		 mchntype = :mchntype
		,#desig#oth1 = :oth1
		,#desig#oth2 = :oth2
		,#desig#prctgrade = :prctgrade
		,#desig#rpm = :rpm
		,#desig#speed = :speed
		,#desig#watres = :watres
	 WHERE
		participantGUID = :pid
	 AND
		dayofwk = :dwk
	 AND
		stdywk = :swk
	";
}



try {
	qu = ezdb.exec( 
		string = sqlString
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid        = fv.pid
		 ,insertedby = "NOBODY"
		 ,oth1       = fv.oth1
		 ,oth2       = fv.oth2
		 ,prctgrade  = fv.grade
		 ,rpm        = fv.rpm
		 ,mchntype   = fv.mchntype
		 ,speed      = fv.speed
		 ,watres     = fv.watts_resistance
		 ,dwk        = fv.dayofwk
		 ,swk        = fv.stdywk
		 ,staffid    = fv.staffId
		} 
	);

	if ( !qu.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #qu.message#" );
	}
}
catch (any ff) {
	req.sendAsJson( status = 0, message = "#errstr# #ff#" );
}

req.sendAsJson( status = 1, message = "SUCCESS @ /api/endurance/* - #upd.message#" );	
</cfscript>
