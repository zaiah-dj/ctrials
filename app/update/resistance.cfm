try {
	//Define a progress statement
	progressStmt =
	"UPDATE 
		ac_mtr_logging_progress_tracker 
	SET 
		re_reps1 = :re_reps1,
		re_weight1 = :re_weight1,
		re_reps2 = :re_reps2,
		re_weight2 = :re_weight2,
		re_reps3 = :re_reps3,
		re_weight3 = :re_weight3,
		re_extype = :re_extype 
	WHERE 
		active_pid = :aid AND session_id = :sid"
	;

	//check fields
	fields = cc.checkFields( form, 
		"pid", "sess_id",
		"el_re_reps1", "el_re_weight1",
		"el_re_reps2", "el_re_weight2",
		"el_re_reps3", "el_re_weight3",
		"el_re_extype" );

	num = form.el_ee_timeblock;
	fields = cc.checkFields( form,
		"pid", "sess_id",
		"m#num#_exhr",
		"m#num#_exoth1",
		"m#num#_exoth2",
		"m#num#_exprctgrade",
		"m#num#_exspeed",
		"m#num#_exwatres",
		"m#num#_rpm"
	);
	
	if ( !fields.status )
		sendRequest( status = 0, message = "#fields.message#" );	

	

	/*,insertStmt = "INSERT INTO ac_mtr_checkinstatus VALUES ( 0, '##form.truana##', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0 )"*/
	/*
	choosy = .Server( 
		listen   = "POST"
	 ,ds       = "#data.source#"
	 ,table    = "ac_mtr_checkinstatus"
	 ,using    = "SQLServer"
	 ,insertOn = '!checkFor( where = "sess_id = :sess_id", predicate = "##form.truana##" )'
	 ,where    = { clause = "sess_id = :sess_id", predicate = { sess_id = "##form.truana##" }}
	 ,only     = [ 
"insertedBy",
"deleted",
"deleteReason",
"participantGUID",
"visitGUID",
"d_visit",
"staffID",
"dayofwk",
"Hrworking",

"m10_exhr",
"m10_exoth1",
"m10_exoth2",
"m10_exprctgrade",
"m10_exrpm",
"m10_exspeed",
"m10_exwatres",
"m15_exhr",
"m15_exoth1",
"m15_exoth2",
"m15_exprctgrade",
"m15_exrpm",
"m15_exspeed",
"m15_exwatres",
"m20_exhr",
"m20_exoth1",
"m20_exoth2",
"m20_exOthafct",
"m20_exprctgrade",
"m20_exrpe",
"m20_exrpm",
"m20_exspeed",
"m20_exwatres",
"m25_exhr",
"m25_exoth1",
"m25_exoth2",
"m25_exprctgrade",
"m25_exrpm",
"m25_exspeed",
"m25_exwatres",
"m30_exhr",
"m30_exoth1",
"m30_exoth2",
"m30_exprctgrade",
"m30_exrpm",
"m30_exspeed",
"m30_exwatres",
"m35_exhr",
"m35_exoth1",
"m35_exoth2",
"m35_exprctgrade",
"m35_exrpm",
"m35_exspeed",
"m35_exwatres",
"m40_exhr",
"m40_exoth1",
"m40_exoth2",
"m40_exprctgrade",
"m40_exspeed",
"m40_exwatres",
"m40_rpm",
"m45_exhr",
"m45_exoth1",
"m45_exoth2",
"m45_exOthafct",
"m45_exprctgrade",
"m45_exrpe",
"m45_exrpm",
"m45_exspeed",
"m45_exwatres",
"m5_exhr",
"m5_exoth1",
"m5_exoth2",
"m5_exprctgrade",
"m5_exrpm",
"m5_exspeed",
"m5_exwatres",
"m5_rechr",
"m5_recoth1",
"m5_recoth2",
"m5_recprctgrade",
"m5_recrpm",
"m5_recspeed",
"m5_recwatres",
"mchntype",

"MthlyBPDia",
"MthlyBPSys",

"nomchntype",
"nxtsesn_dt",
"othMchn1",
"othMchn2",
"reasnmisd",
"Sessionmisd",
"Sp_mchntype",
"sp_reasnmisd",
"stdywk",
"trgthr1",
"trgthr2",
"typedata",
"weight",
"wrmup_hr",
"wrmup_oth1",
"wrmup_oth2",
"wrmup_othafct",
"wrmup_prctgrade",
"wrmup_rpe",
"wrmup_rpm",
"wrmup_speed",
"wrmup_watres",
"breaks",
	);
	*/

	
	//then insert or update if the row is not there...
	upd = qu.exec( 
		string = "SELECT * FROM ac_mtr_exercise_log_re WHERE el_re_ex_session_id = :sid AND el_re_pid = :pid AND el_re_extype = :extype",
		datasource="#data.source#",
		bindArgs = { sid="#form.sess_id#", pid="#form.pid#", extype="#form.el_re_extype#" } 
	);

	if ( !upd.status )
		sendRequest( status = 0, message = "#upd.message#" );

	if ( !upd.prefix.recordCount ) {
		upd = qu.exec( 
			datasource = "#data.source#",
			string = "INSERT INTO ac_mtr_exercise_log_re VALUES
				( :pid,:sid,:r1,:w1,:r2,:w2,:r3,:w3,:extype, :dt, :mdt );",
			bindArgs = {
				pid="#form.pid#" 
			 ,sid="#form.sess_id#"

			 ,r1="#form.el_re_reps1#" 
			 ,w1="#form.el_re_weight1#" 
			 ,r2="#form.el_re_reps2#" 
			 ,w2="#form.el_re_weight2#" 
			 ,r3="#form.el_re_reps3#" 
			 ,w3="#form.el_re_weight3#" 

			 ,extype="#form.el_re_extype#" 
			 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			 ,mdt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			} 
		);
	}
	else {
		upd = qu.exec( 
			string = "UPDATE ac_mtr_exercise_log_re 
			SET 
				el_re_reps1 = :r1,
				el_re_weight1 = :w1,
				el_re_reps2 = :r2,
				el_re_weight2 = :w2,
				el_re_reps3 = :r3,
				el_re_weight3 = :w3,
				el_re_extype = :extype,
				el_re_datetime_modified = :dt
			WHERE
				el_re_ex_session_id = :sid 
			AND
				el_re_extype = :extype
			AND
				el_re_pid = :pid",

			datasource = "#data.source#",

			bindArgs = {
				pid="#form.pid#" 
			 ,sid="#form.sess_id#"

			 ,r1="#form.el_re_reps1#" 
			 ,w1="#form.el_re_weight1#" 
			 ,r2="#form.el_re_reps2#" 
			 ,w2="#form.el_re_weight2#" 
			 ,r3="#form.el_re_reps3#" 
			 ,w3="#form.el_re_weight3#" 

			 ,extype="#form.el_re_extype#" 
			 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			}
		);	
	}

	//Progress tracking
	qu.exec( 
		string = progressStmt
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			aid = form.pid
		 ,sid = form.sess_id
		 ,re_reps1 = form.el_re_reps1
		 ,re_weight1 = form.el_re_weight1
		 ,re_reps2 = form.el_re_reps2
		 ,re_weight2 = form.el_re_weight2
		 ,re_reps3 = form.el_re_reps3
		 ,re_weight3 = form.el_re_weight3
		}
	);
}
catch (any e) {
	sendRequest( status = 0, message = "#e.message# - #e.detail#" );
}

sendRequest( status = 1, message = "#upd.message#" );	
abort;
