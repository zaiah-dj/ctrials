try {
	//Define a progress statement
	progressStmt =
	"UPDATE 
		ac_mtr_logging_progress_tracker 
	SET 
		 ee_rpm = :ee_rpm 
		,ee_speed = :ee_speed 
		,ee_grade = :ee_grade 
		,ee_perceived_exertion = :ee_perceived_exertion 
		,ee_equipment = :ee_equipment
		,ee_affect = :ee_affect
		,ee_watts_resistance = :ee_watts_resistance
	WHERE 
		active_pid = :aid AND session_id = :sid"
	;

	//check fields
	fields = cc.checkFields( form, 
		"pid", "sess_id","el_ee_equipment", "el_ee_affect",
		"el_ee_timeblock","el_ee_rpm","el_ee_watts_resistance",
		"el_ee_speed","el_ee_grade","el_ee_perceived_exertion" );

	if ( !fields.status )
		sendRequest( status = 0, message = "#fields.message#" );	
	
	//then insert or update if the row is not there...
	upd = qu.exec( 
		string = "SELECT * FROM ac_mtr_exercise_log_ee WHERE el_ee_ex_session_id = :sid AND el_ee_pid = :pid AND el_ee_timeblock = :tb"
	 ,datasource="#data.source#"
	 ,bindArgs = { sid="#form.sess_id#", pid="#form.pid#", tb="#form.el_ee_timeblock#" } );

	if ( !upd.status )
		sendRequest( status = 0, message = "#upd.message#" );

	if ( !upd.prefix.recordCount ) {
		upd = qu.exec( 
			datasource = "#data.source#",
			string = "INSERT INTO ac_mtr_exercise_log_ee VALUES 
				( :pid,:sid,:eq,:tb,:rpm,:wr,:speed,:grade,:af,:pe,:dt,:mdt )",
			bindArgs = {
				sid="#form.sess_id#"
			 ,pid="#form.pid#" 
			 ,"eq"="#form.el_ee_equipment#" 
			 ,tb="#form.el_ee_timeblock#" 
			 ,rpm="#form.el_ee_rpm#" 
			 ,wr="#form.el_ee_watts_resistance#" 
			 ,speed="#form.el_ee_speed#" 
			 ,grade="#form.el_ee_grade#" 
			 ,af="#form.el_ee_affect#" 
			 ,pe="#form.el_ee_perceived_exertion#" 
			 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			 ,mdt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			} 
		);
	}
	else {
		upd = qu.exec( 
			string = "UPDATE ac_mtr_exercise_log_ee 
			SET 
				el_ee_equipment = :eq,
				el_ee_timeblock = :tb,
				el_ee_rpm = :rpm,
				el_ee_watts_resistance = :wr,
				el_ee_speed = :speed,
				el_ee_grade = :grade,
				el_ee_affect = :af,
				el_ee_perceived_exertion = :pe,
				el_ee_datetime_modified = :dt
			WHERE
				el_ee_ex_session_id = :sid 
			AND
				el_ee_timeblock = :tb
			AND
				el_ee_pid = :pid",
			datasource = "#data.source#",
			bindArgs = { 
				sid = "#form.sess_id#",
				pid = "#form.pid#" ,
				"eq" = "#form.el_ee_equipment#" ,
				tb = "#form.el_ee_timeblock#" ,
				rpm = "#form.el_ee_rpm#" ,
				af="#form.el_ee_affect#",
				wr = "#form.el_ee_watts_resistance#" ,
				speed = "#form.el_ee_speed#" ,
				grade = "#form.el_ee_grade#" ,
				pe = "#form.el_ee_perceived_exertion#" ,
				dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			}
		);	
	}

	//Also save progress (but the thing needs to be checked)
	qu.exec(
		string = progressStmt
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			aid = form.pid
		 ,sid = form.sess_id
		 ,ee_rpm = form.el_ee_rpm
		 ,ee_rpm = form.el_ee_rpm
		 ,ee_watts_resistance = form.el_ee_watts_resistance
		 ,ee_speed = form.el_ee_speed
		 ,ee_grade = form.el_ee_grade
		 ,ee_affect = form.el_ee_affect
		 ,ee_perceived_exertion = form.el_ee_perceived_exertion
		 ,ee_equipment = form.el_ee_equipment
	 }
	);
}
catch (any e) {
	sendRequest( status = 0, message = "#e.message# - #e.detail#" );	
}
sendRequest( status = 1, message = "#upd.message#" );	
abort;
