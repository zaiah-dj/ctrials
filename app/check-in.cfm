<cfscript>
db = createObject("component", "components.quella");
wb = createObject("component", "components.writeback");
er = createObject("component", "components.exceptRequest");


//Do all the queries here.	
db.setDs( "#data.source#" );
Q = {
	exercises = db.exec( string="SELECT et_name FROM ac_mtr_re_exercise_list" )
 ,machines  = db.exec( string="SELECT et_name FROM ac_mtr_ee_machine_list" )
 ,failReason= db.exec( string="SELECT et_name FROM ac_mtr_fail_visit_reasons" )
 ,pbp       = db.exec( 
		string="SELECT * FROM ac_mtr_bloodpressure WHERE bp_pid = :pid", 
		bindArgs = { pid = "#part_list.p_pid#" } )
 ,ci        = db.exec( 
		string="SELECT * FROM ac_mtr_checkinstatus WHERE ps_session_id = :sid AND ps_pid = :pid", 
		bindArgs = { pid = "#part_list.p_pid#", sid = "#sess.key#" } )
};


//Blood pressure needs some help.
model = {
	needsNewBp = ( DateDiff( "d", Q.pbp.results.bp_daterecorded, Now() ) > 30 ) ? true : false
 ,currentBpSystolic = Q.pbp.results.bp_systolic
 ,currentBpDiastolic = Q.pbp.results.bp_diastolic
 ,targetHeartRate = part_list.p_targetheartrate
 ,nextSchedVisit = DateTimeFormat( Q.ci.results.ps_next_sched, "MM/DD/YYYY" )
};

/*
writedump( Q );
writedump( model );
abort;
*/
</cfscript>
<cfoutput>
</cfoutput>
