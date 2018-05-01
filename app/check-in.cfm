<cfscript>
//Objects
db = createObject("component", "components.quella");
wb = createObject("component", "components.writeback");
er = createObject("component", "components.exceptRequest");

//Do all the queries here.	
db.setDs( "#data.source#" );
Q = {
	exercises = db.exec( string="SELECT et_name FROM ac_mtr_re_exercise_list" )
 ,machines  = db.exec( string="SELECT et_name FROM ac_mtr_ee_machine_list" )
 ,failReason= db.exec( string="SELECT et_name FROM ac_mtr_fail_visit_reasons" )

	//See today's blood pressure
 ,pbp = db.exec( 
		string="SELECT * FROM ac_mtr_bloodpressure WHERE bp_pid = :pid", 
		bindArgs = { pid = "#part_list.p_pid#" } )

	//See just today's check in status
 ,ci = db.exec( 
		string="SELECT * FROM ac_mtr_checkinstatus WHERE ps_session_id = :sid AND ps_pid = :pid", 
		bindArgs = { pid = "#part_list.p_pid#", sid = "#sess.key#" } )

	//Get ALL of the previous check-in data to see next scheduled visit and previous blood pressure readings?
 ,ai = db.exec( 
		string="SELECT TOP 1 ps_next_sched, ps_date_time_assessed 
		 FROM 
			ac_mtr_checkinstatus WHERE ps_pid = :pid ORDER BY ps_date_time_assessed DESC", 
		bindArgs = { pid = "#part_list.p_pid#" } )
};


//Getting the next scheduled visit is not super straightforward if it's not recorded in patient table.
nextScheduledVisit = ( Q.ai.prefix.recordCount ) ? Q.ai.results.ps_next_sched : Now();

//Blood pressure needs some help.
if ( Q.pbp.prefix.recordCount ) 
	model = {
		needsNewBp = ( DateDiff( "d", Q.pbp.results.bp_daterecorded, Now() ) > 30 ) ? true : false
	 ,currentBpSystolic = Q.pbp.results.bp_systolic
	 ,currentBpDiastolic = Q.pbp.results.bp_diastolic
	 ,targetHeartRate = part_list.p_targetheartrate
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
	 ,targetHeartRate = part_list.p_targetheartrate
	 ,nextSchedVisit = DateTimeFormat( Q.ci.results.ps_next_sched, "MM/DD/YYYY" )
	 ,minBPS = 40
	 ,maxBPS = 210
	 ,minBPD = 20
	 ,maxBPD = 120
	};
}
</cfscript>
<cfoutput>
</cfoutput>
