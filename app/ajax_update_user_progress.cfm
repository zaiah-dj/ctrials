<cfscript>
/*
try {
	if ( StructKeyExists( form, "sess_id" ) ) 
	{
		//Check the thing
		ckr = ezdb.exec( 
			 bindArgs = { sid=form.sess_id }
			,datasource="#data.source#"
			,string = "SELECT TOP 1 * FROM 
			ac_mtr_logging_progress_tracker WHERE session_id = :sid" 
		);

		//If no records exist...
		if ( !ckr.prefix.recordCount ) 
		{
			//I insert a dummy record here because I'm going to update to change my tracker...
			insertStmt = "
			INSERT INTO
				ac_mtr_logging_progress_tracker 
			VALUES ( 
				 :aid
  			,:sid
				,:ee_rpm
				,:ee_watts_resistance
				,:ee_speed
				,:ee_grade
				,:ee_perceived_exertion
				,:ee_equipment
				,:ee_timeblock
				,:re_reps1
				,:re_weight1
				,:re_reps2
				,:re_weight2
				,:re_reps3
				,:re_weight3
				,:re_extype
				,:dt
			)"
			;

			ezdb.exec( 
			 datasource="#data.source#"
			,string = insertStmt
			,bindArgs = {
				 aid=0
				,sid=0
				,ee_rpm=0
				,ee_watts_resistance=0
				,ee_speed=0
				,ee_grade=0
				,ee_perceived_exertion=0
				,ee_equipment=0
				,ee_timeblock=0
				,re_reps1=0
				,re_weight1=0
				,re_reps2=0
				,re_weight2=0
				,re_reps3=0
				,re_weight3=0
				,re_extype=0
				,dt={value=DateTimeFormat(Now(),"YYYY-MM-DD HH:nn:ss"),type="cf_sql_datetime"}
				}
			);
		}
	}
}
catch (any e) {
	req.sendRequest( status = 0, message = "#e.message# - #e.detail#" );	
	abort;
}
*/
</cfscript>
