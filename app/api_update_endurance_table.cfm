<cfscript>
//Define an error string for use throughout this part
EP_ENDURANCE = "#link( 'api.cfm' )#";
errstr = "Error at #EP_ENDURANCE#/* - ";
vpath = 1;
try {
	//Differentiate between Cycles, Treadmills and Other
	CYCLE = 1;
	TREADMILL = 2;
	OTHER = 3;

	//Stop if no type was found
	if ( !StructKeyExists( form, "exparam" ) ) {
		req.sendAsJson( 
			status = 0, 
			message = "#errstr# Parameter 'exparam' " &
								"is not available in FORM (Can't " &
								"tell exercise type... so can't move further.)" 
		);
	}

	//Also stop if the timeblock is not there.
	if ( StructKeyExists( form, "timeblock" ) ) {
		ft = form.timeblock;
		ftstat = (ft == 0 || ft == 20 || ft == 45);
	}
	else {
		req.sendAsJson( 
			status = 0, 
			message = "#errstr# Parameter 'timeblock' " &
								"is not available in FORM (Can't " &
								"tell exercise type... so can't move further.)" 
		);
	}

	//Pull all required values out of the form scope.
	stat = cmValidate( form, { 
		 pid = { req = true }
		,pageUpdated = { req = true }
		,sess_id = { req = true }
		,stdywk = { req = true }
		,dayofwk = { req = true }
		,insBy = { req = true }
		,timeblock = { req = true }
		,mchntype = { req = false, ifNone = form.exparam }

		//Only required when at timeblock one (or warmup)
		,hrworking = { req = ( ft == 0 ), ifNone = "off" }
		,tfhr_time = { req = ( ft == 0 ), ifNone = 0 }

		//Only required when exercise chosen is cycle
		,rpm = { req = (form.exparam eq CYCLE), ifNone = 0 }
		,watres = { req = (form.exparam eq CYCLE), ifNone = 0 }

		//Only required when exercise chosen is treadmill 
		,prctgrade = { req = (form.exparam eq TREADMILL), ifNone = 0 }
		,speed = { req = (form.exparam eq TREADMILL), ifNone = 0 }

		//Only required when exercise chosen is other 
		,oth1 = { req = (form.exparam eq OTHER), ifNone = 0 }
		,oth2 = { req = (form.exparam eq OTHER), ifNone = 0 }

		//These are only required at times 0 (warm-up), 20m and 45m
		,othafct = { req = (ftstat), ifNone = 0 }
		,hr = { req = (ftstat), ifNone = 0 }
		,rpe = { req = (ftstat), ifNone = 0 }
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}

	//Set fv to validated form values	
	fv = stat.results;

	//Change hrMonitor
	if ( StructKeyExists( fv, "hrworking" ) ) {
		fv.hrworking = ( fv.hrworking eq "on" ) ? 1 : 0; 
	}

	//Parse the time
	if ( fv.tfhr_time eq 0 )
		ttobj = Now();
	else {
		now = Now();
		ttobj = LSParseDateTime( fv.tfhr_time );
		ttobj.setMonth( Month( now ) );
		ttobj.setDay( Day( now ) );
		ttobj.setYear( Year( now ) );
		//req.sendAsJson( status = 1, message = "24hrtime - #SerializeJSON({time = ttobj })#" );	
	}

	//Figure out the form field name 
	desig = "";
	if ( fv.timeblock lt 0 )
		req.sendAsJson( status = 0, message = "#errstr# - Timeblock cannot be less than 0 and not more than 45." );		
	else if ( fv.timeblock eq 0 )
		desig = "wrmup_";
	else if ( fv.timeblock gt 45 )
		desig = "m3_rec";
	else { 
		desig = "m#fv.timeblock#_ex";
	}

	//Check for the presence of a field already
	upd = dbExec( 
		string = "
		SELECT * FROM 
			frm_eetl	
		WHERE
			participantGUID = :pid
		AND 
			stdywk = :stdywk
		AND 
			dayofwk = :dayofwk
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
	vpath = 0;
	sqlString = "
	INSERT INTO 
		frm_eetl	
	( participantGUID
	 ,insertedBy
	 ,d_inserted
	 ,mchntype
	 #iif(ft eq 0, DE(',hrworking'),DE(''))#
	 #iif(ft eq 0, DE(',wrmup_starttime'),DE(''))#
	 ,#desig#oth1
	 ,#desig#oth2
	 ,#desig#prctgrade
	 ,#desig#rpm
	 ,#desig#speed
	 ,#desig#watres  
	 ,#desig#hr
	 #iif(ftstat,DE(',#desig#Othafct'),DE(''))#
	 #iif(ftstat,DE(',#desig#rpe'),DE(''))#
	 ,dayofwk
	 ,stdywk
	)
	VALUES
	(  :pid
		,:insBy
		,:dtstamp
		,:mchntype
	  #iif(ft eq 0, DE(',:hrworking'),DE(''))#
	  #iif(ft eq 0, DE(',:tfhr_time'),DE(''))#
		,:oth1
		,:oth2
		,:prctgrade
		,:rpm
		,:speed
		,:watres
		,:hr
		#iif(ftstat,DE(',:afct'),DE(''))#
		#iif(ftstat,DE(',:rpe'),DE(''))#
		,:dwk
		,:swk
	)";
}
else {
	vpath = 1;
	sqlString = "
	 UPDATE 
		frm_eetl	
	 SET
		 mchntype = :mchntype
		,d_inserted = :dtstamp
		,insertedBy = :insBy
	  #iif(ft eq 0, DE(',hrworking = :hrworking'),DE(''))#
	  #iif(ft eq 0, DE(',wrmup_starttime = :tfhr_time'),DE(''))#
		,#desig#oth1 = :oth1
		,#desig#oth2 = :oth2
		,#desig#prctgrade = :prctgrade
		,#desig#rpm = :rpm
		,#desig#speed = :speed
		,#desig#watres = :watres
		,#desig#hr = :hr
	  #iif(ftstat, DE(',#desig#Othafct = :afct'),DE(''))#
	  #iif(ftstat, DE(',#desig#rpe = :rpe'),DE(''))#
	 WHERE
		participantGUID = :pid
	 AND
		dayofwk = :dwk
	 AND
		stdywk = :swk
	";
}

try {
	//This is in case I find myself modifying dates from other times
	dstmp = LSParseDateTime( 
		"#session.currentYear#-#session.currentMonth#-#session.currentDayOfMonth# "
		& DateTimeFormat( Now(), "HH:nn:ss" )
	);

	qu = dbExec( 
		string = sqlString
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid      = fv.pid
		 ,insBy    = fv.insBy
		 ,dtstamp  = { value = dstmp, type="cf_sql_date" }
		 ,oth1     = fv.oth1
		 ,oth2     = fv.oth2
		 ,prctgrade= fv.prctgrade
		 ,rpm      = fv.rpm
		 ,hrworking= fv.hrworking
		 ,tfhr_time= { value = ttobj, type="cf_sql_timestamp" }
		 ,mchntype = fv.mchntype
		 ,speed    = fv.speed
		 ,watres   = fv.watres
		 ,dwk      = fv.dayofwk
		 ,swk      = fv.stdywk
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

	if ( fv.pageUpdated ) {
		//Write progress
		prog = dbExec(
			string = "
			SELECT * FROM
				ac_mtr_frm_progress
			WHERE
				fp_participantGUID = :pid
			AND
				fp_step = :step
			AND
				fp_sessdayid = :sid
			"
		 ,bindArgs = {
				pid = fv.pid
			 ,sid = csSid
			 ,step = fv.timeblock 
			}
		);

		if ( !prog.status ) {
			req.sendAsJson( status = 0, message = "#errstr# - #prog.message#" );
		}

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
					step = fv.timeblock 
				 ,pid = fv.pid
				 ,sdid = csSid
				}
			);

			if ( !prog.status ) {
				req.sendAsJson( status = 0, message = "#errstr# - #prog.message#" );
			}
		}
	}
}
catch (any ff) {
	req.sendAsJson( status = 0, message = "#errstr# #ff#" );
}

req.sendAsJson( 
	status = 1, 
	message = ( !vpath ) ? 
		"SUCCESS @ #EP_ENDURANCE#/* - Inserted into #data.data.endurance# with values #SerializeJSON( fv )#" :
		"SUCCESS @ #EP_ENDURANCE#/* - Updated #data.data.endurance# with values #SerializeJSON( fv )#" ) ;
</cfscript>
