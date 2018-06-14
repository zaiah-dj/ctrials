<cfscript>
//Objects
param name="old_ws.ps_week" default="0";
param name="old_ws.ps_day" default="0";
param name="old_ws.ps_next_sched" default="0";
param name="old_ws.ps_weight" default="0";
param name="old_ws.ps_machine_value" default="0";


//Check more
selectedDays = {};

//Do all the queries here.	
Q = {
	exercises = ezdb.exec( string="SELECT et_name FROM ac_mtr_re_exercise_list" )
 ,machines  = ezdb.exec( string="SELECT et_id, et_name FROM ac_mtr_ee_machine_list" )
 ,failReason= ezdb.exec( string="SELECT et_name FROM ac_mtr_fail_visit_reasons" )

	//See today's blood pressure
 ,pbp       = ezdb.exec( 
		string="SELECT * FROM #data.data.bloodpressure# WHERE bp_pid = :pid", 
		bindArgs = { pid = "#part_list.results.participantGUID#" } )

	//See just today's check in status
 ,ci        = ezdb.exec( 
		string="SELECT * FROM 
			#data.data.checkin#	
		WHERE ps_session_id = :sid AND ps_pid = :pid", 
		bindArgs = { pid = "#part_list.results.participantGUID#", sid = "#sess.key#" } )

	//Get ALL of the previous check-in data to see next scheduled visit and previous blood pressure readings?
 ,ai        = ezdb.exec( 
		string="SELECT TOP 1 ps_next_sched,ps_date_time_assessed 
		FROM 
			#data.data.checkin#	
		WHERE ps_pid = :pid ORDER BY ps_date_time_assessed DESC", 
		bindArgs = { pid = "#part_list.results.participantGUID#" } )
};




//Getting the next scheduled visit is not super straightforward if it's not recorded in patient table.
nextScheduledVisit = ( Q.ai.prefix.recordCount ) ? Q.ai.results.ps_next_sched : Now(); 

//Blood pressure needs some help.
if ( Q.pbp.prefix.recordCount ) 
	model = {
		needsNewBp = ( DateDiff( "d", Q.pbp.results.bp_daterecorded, Now() ) > 30 ) ? true : false
	 ,currentBpSystolic = Q.pbp.results.bp_systolic
	 ,currentBpDiastolic = Q.pbp.results.bp_diastolic
	 ,targetHeartRate = 0 //part_list.results.p_targetheartrate
	 ,nextSchedVisit = listFirst( old_ws.ps_next_sched, DateTimeFormat( nextScheduledVisit, "YYYY-MM-DD" ) )
	 ,currentWeek = ListFirst( old_ws.ps_week, 0 )
	 ,currentDay = ListFirst( old_ws.ps_day, 0 )
	 ,weight = ListFirst( old_ws.ps_weight, 0 )
	 ,machineValue = ListFirst( old_ws.ps_machine_value, 0 )
	 ,minBPS = 40
	 ,maxBPS = 210
	 ,minBPD = 20
	 ,maxBPD = 120
	};
else {
	model = {
		needsNewBp = true
	 ,currentBpSystolic = 0
	 ,currentBpDiastolic = 0
	 ,targetHeartRate = 0 //part_list.results.p_targetheartrate
	 ,nextSchedVisit = listFirst( old_ws.ps_next_sched, DateTimeFormat( Q.ci.results.ps_next_sched, "MM/DD/YYYY" ) )
	 ,currentWeek = ListFirst( old_ws.ps_week, 0 )
	 ,currentDay = ListFirst( old_ws.ps_day, 0 )
	 ,weight = ListFirst( old_ws.ps_weight, 0 )
	 ,machineValue = ListFirst( old_ws.ps_machine_value, 0 )
	 ,minBPS = 40
	 ,maxBPS = 210
	 ,minBPD = 20
	 ,maxBPD = 120
	};
}
/*
//Blood pressure needs some help.
if ( Q.pbp.prefix.recordCount ) 
	model = {
		needsNewBp = ( DateDiff( "d", Q.pbp.results.bp_daterecorded, Now() ) > 30 ) ? true : false
	 ,currentBpSystolic = Q.pbp.results.bp_systolic
	 ,currentBpDiastolic = Q.pbp.results.bp_diastolic
	 ,targetHeartRate = part_list.results.p_targetheartrate
	 ,nextSchedVisit = DateTimeFormat( nextScheduledVisit, "YYYY-MM-DD" )
	 ,minBPS = 40
	 ,maxBPS = 210
	 ,minBPD = 20
	 ,maxBPD = 120
	};
else {
	model = {
		needsNewBp = true
	 ,currentBpSystolic = 0
	 ,currentBpDiastolic = 0
	 ,targetHeartRate = part_list.results.p_targetheartrate
	 ,nextSchedVisit = DateTimeFormat( Q.ci.results.ps_next_sched, "MM/DD/YYYY" )
	 ,minBPS = 40
	 ,maxBPS = 210
	 ,minBPD = 20
	 ,maxBPD = 120
	};
}
*/
</cfscript>
