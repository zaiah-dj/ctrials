<cfscript>
/*
//Objects
param name="old_ws.ps_week" default="0";
param name="old_ws.ps_day" default="0";
param name="old_ws.ps_next_sched" default="0";
param name="old_ws.ps_weight" default="0";
//param name="old_ws.ps_machine_value" default="0";
*/

//select days from this week with results (including today?)
tbName = ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) 
	? "#data.data.endurance#" : "#data.data.resistance#";


//Do all the queries here.	
Q = {
	exercises = ezdb.exec( string="SELECT et_name FROM ac_mtr_re_exercise_list" )
 ,machines  = ezdb.exec( string="SELECT et_id, et_name FROM ac_mtr_ee_machine_list" )
 ,failReason= ezdb.exec( string="SELECT et_name FROM ac_mtr_fail_visit_reasons" )

	//See today's blood pressure
 ,pbp       = ezdb.exec( 
		string="SELECT * FROM #data.data.bloodpressure# WHERE bp_pid = :pid", 
		bindArgs = { pid = "#currentParticipant.results.participantGUID#" } )

	//See just today's check in status
 ,ci        = ezdb.exec( 
		string="SELECT * FROM 
			#data.data.checkin#	
		WHERE ps_session_id = :sid AND ps_pid = :pid", 
		bindArgs = { pid = "#currentParticipant.results.participantGUID#", sid = "#sess.key#" } )

	//Get ALL of the previous check-in data to see next scheduled visit and previous blood pressure readings?
 ,ai        = ezdb.exec( 
		string="SELECT TOP 1 ps_next_sched,ps_date_time_assessed 
		FROM 
			#data.data.checkin#	
		WHERE ps_pid = :pid ORDER BY ps_date_time_assessed DESC", 
		bindArgs = { pid = "#currentParticipant.results.participantGUID#" } )
};


//Check in
checkIn = {
	//Blood pressure
	 BPSystolic = 0
	,BPDiastolic = 0
	,BPMinSystolic = 0
	,BPMaxSystolic = 0
	,BPMinDiastolic = 0
	,BPMaxDiastolic = 0

	//Target Heart Rate
	,targetHR = 0

	//Weight
	,weight = 0

	//Do I need a new blood pressure?
	,needsNewBp = false 

	//Completed days array
  ,cdays = [0,0,0,0,0,0]

	//Query completed days
	,qCompletedDays = ezdb.exec(
		string="SELECT dayofwk FROM #tbName# 
			WHERE participantGUID = :pid AND stdywk = :wk"
	 ,bindArgs={ pid=sess.current.participantId, wk=sess.current.week }
	)

	//Exercise list
	,elist = CreateObject( "component", "components.exercises" ).init()
};


for ( n in ListToArray( ValueList( checkIn.qCompletedDays.results.dayofwk, "," ) ) )
	{	checkIn.cdays[ n ] = n; }
</cfscript>
