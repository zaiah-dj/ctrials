<cfscript>
try {
	//Fields change depending on whether it's input or endurance, and if it's check-in, nothing
	fields = cc.checkFields( form, 
		 "pid"
		,"sess_id"
		,"location"
	);

	//Select from the progress table and use this to prefill fields that don't exist
	p = ezdb.exec( 
		string = 
		"SELECT * FROM
			ac_mtr_logging_progress_tracker 
		 WHERE
			active_pid = :pid 
		 AND
			session_id = :sid"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = form.pid
		 ,sess_id = form.sess_id
		}
	);

	//There was an error
	if ( !p.status ) {
		writedump( p );
		abort;
	}

	//There are simply no values, so write a new one
	if ( !p.results.resultCount ) {
		p = ezdb.exec(
			string =
			"INSERT INTO
				ac_mtr_logging_progress_tracker 
				(
					active_pid
				 ,session_id
				 ,location
				 ,ee_rpm
				 ,ee_speed
				 ,ee_grade
				 ,ee_perceived_exertion
				 ,ee_equipment
				 ,ee_affect
				 ,ee_watts_resistance
				 ,re_reps1
				 ,re_weight1
				 ,re_reps2
				 ,re_weight2
				 ,re_reps3
				 ,re_weight3
				 ,re_extype
				)
			 VALUES (	
				 :active_pid
				,:session_id
				,:location
				,:rpm 
				,:speed 
				,:grade 
				,:rpe
				,:equipment
				,:affect
				,:watres
				,:re_reps1
				,:re_weight1
				,:re_reps2
				,:re_weight2
				,:re_reps3
				,:re_weight3
				,:re_extype 
			 )
			"
		 ,datasource = "#data.source#"
		 ,bindArgs = {
				 active_pid = x
				,session_id = x
				,location = x
				,rpm  = x
				,speed  = x
				,grade  = x
				,rpe = x
				,equipment = x
				,affect = x
				,watres = x
				,re_reps1 = x
				,re_weight1 = x
				,re_reps2 = x
				,re_weight2 = x
				,re_reps3 = x
				,re_weight3 = x
				,re_extype  = x
			}
		);
	}

	//Now update the progress table
	p = ezdb.exec(
		string =
		"UPDATE 
			ac_mtr_logging_progress_tracker 
		SET 
			 location = :location
			,ee_rpm = :rpm 
			,ee_speed = :speed 
			,ee_grade = :grade 
			,ee_perceived_exertion = :rpe
			,ee_equipment = :equipment
			,ee_affect = :affect
			,ee_watts_resistance = :watres
			,re_reps1 = :re_reps1
			,re_weight1 = :re_weight1
			,re_reps2 = :re_reps2
			,re_weight2 = :re_weight2
			,re_reps3 = :re_reps3
			,re_weight3 = :re_weight3
			,re_extype = :re_extype 
		WHERE 
			active_pid = :aid 
		AND 
			session_id = :sid"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			aid = form.pid
		 ,sid = form.sess_id
		 ,location = form.location
		 ,ee_rpm = form.rpm 
		 ,ee_speed = form.speed 
		 ,ee_grade = form.grade 
		 ,ee_perceived_exertion = form.rpe
		 ,ee_equipment = form.equipment
		 ,ee_affect = form.affect
		 ,ee_watts_resistance = form.watres
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

}

</cfscript>
