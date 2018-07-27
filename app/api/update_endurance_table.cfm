<cfscript>
//Define an error string for use throughout this part
errstr = "Error at /api/endurance/* - ";
vpath = 1;
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

	//Also stop if the timeblock is not there.
	if ( !StructKeyExists( form, "timeblock" ) ) {
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
		,recordthread = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,insBy = { req = true }
		,timeblock = { req = true }
		,mchntype = { req = false, ifNone = form.exParam }

		//Only required when exercise chosen is cycle
		,rpm = { req = (form.exParam eq CYCLE), ifNone = 0 }
		,watres = { req = (form.exParam eq CYCLE), ifNone = 0 }

		//Only required when exercise chosen is treadmill 
		,prctgrade = { req = (form.exParam eq TREADMILL), ifNone = 0 }
		,speed = { req = (form.exParam eq TREADMILL), ifNone = 0 }

		//Only required when exercise chosen is other 
		,oth1 = { req = (form.exParam eq OTHER), ifNone = 0 }
		,oth2 = { req = (form.exParam eq OTHER), ifNone = 0 }

		//These are only required at times 0 (warm-up), 20m and 45m
		,othafct = { req = (ListContains( form.timeblock, "0,20,45") ), ifNone = 0 }
		,hr = { req = (ListContains( form.timeblock, "0,20,45") ), ifNone = 0 }
		,rpe = { req = (ListContains( form.timeblock, "0,20,45") ), ifNone = 0 }
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}


	//Set fv to validated form values	
	fv = stat.results;

	//Figure out the form field name 
	desig = "";
	if ( fv.timeblock lt 0 )
		req.sendAsJson( status = 0, message = "#errstr# - Timeblock cannot be less than 0 and not more than 45." );		
	else if ( fv.timeblock eq 0 )
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
		AND 
			stdywk = :stdywk
		AND 
			recordthread = :recordthread
		AND 
			dayofwk = :dayofwk
		"
	 ,datasource="#data.source#"
	 ,bindArgs = { 
		 pid = fv.pid
		,stdywk = fv.stdywk
		,recordthread = fv.recordthread
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
	vpath = 0;
	sqlString = "
	INSERT INTO 
		#data.data.endurance#	
	( participantGUID
	 ,recordthread
	 ,insertedBy
	 ,d_inserted
	 ,mchntype
	 ,#desig#oth1
	 ,#desig#oth2
	 ,#desig#prctgrade
	 ,#desig#rpm
	 ,#desig#speed
	 ,#desig#watres  
	 ,#desig#hr
	 #iif(ListContains(fv.timeblock,'0,20,45') ,DE(',#desig#Othafct'),DE(''))#
	 #iif(ListContains(fv.timeblock,'0,20,45') ,DE(',#desig#rpe'),DE(''))#
	 ,dayofwk
	 ,stdywk
	)
	VALUES
	(  :pid
		,:rthrd
		,:insBy
		,:dtstamp
		,:mchntype
		,:oth1
		,:oth2
		,:prctgrade
		,:rpm
		,:speed
		,:watres
		,:hr
		#iif(ListContains(fv.timeblock,'0,20,45') ,DE(',:afct'),DE(''))#
		#iif(ListContains(fv.timeblock,'0,20,45') ,DE(',:rpe'),DE(''))#
		,:dwk
		,:swk
	)";
}
else {
	vpath = 1;
	sqlString = "
	 UPDATE 
		#data.data.endurance#	
	 SET
		 mchntype = :mchntype
		,d_inserted = :dtstamp
		,insertedBy = :insBy
		,#desig#oth1 = :oth1
		,#desig#oth2 = :oth2
		,#desig#prctgrade = :prctgrade
		,#desig#rpm = :rpm
		,#desig#speed = :speed
		,#desig#watres = :watres
		,#desig#hr = :hr
	 #iif(ListContains(fv.timeblock,'0,20,45') ,DE(',#desig#Othafct = :afct'),DE(''))#
	 #iif(ListContains(fv.timeblock,'0,20,45') ,DE(',#desig#rpe = :rpe'),DE(''))#
	 WHERE
		participantGUID = :pid
	 AND
		recordthread = :rthrd
	 AND
		dayofwk = :dwk
	 AND
		stdywk = :swk
	";
}

/*
		if ( 1 ) {
			req.sendAsJson( 
				status = 0
			 ,message = "Form values received were: #SerializeJSON(stat)#" 
			);
		}
*/

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
		 ,insBy    = fv.insBy
		 ,dtstamp  = { value = DateTimeFormat( dstmp,"YYYY-MM-DD HH:nn:ss" ), type="cfsqldate" }
		 ,oth1     = fv.oth1
		 ,oth2     = fv.oth2
		 ,prctgrade= fv.prctgrade
		 ,rpm      = fv.rpm
		 ,mchntype = fv.mchntype
		 ,speed    = fv.speed
		 ,watres   = fv.watres
		 ,dwk      = fv.dayofwk
		 ,swk      = fv.stdywk
		 ,rthrd    = fv.recordthread
		 ,afct     = fv.othafct
		 ,hr       = fv.hr
		 ,rpe      = fv.rpe
		} 
	);

	if ( !qu.status ) {
		req.sendAsJson( 
			status = 0, 
			message = "#errstr# #iif(vpath,DE("UPDATE"),DE("INSERT"))# #qu.message#" 
		);
	}
}
catch (any ff) {
	req.sendAsJson( status = 0, message = "#errstr# #ff#" );
}

req.sendAsJson( 
	status = 1, 
	message = ( !vpath ) ? 
		"SUCCESS @ /api/endurance/* - Inserted into #data.data.endurance# with values #SerializeJSON( fv )#" :
		"SUCCESS @ /api/endurance/* - Updated #data.data.endurance# with values #SerializeJSON( fv )#" ) ;
</cfscript>
