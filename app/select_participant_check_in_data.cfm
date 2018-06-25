<cfscript>
//select days from this week with results (including today?)
tbName = ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) 
	? "#data.data.endurance#" : "#data.data.resistance#";

//This should be private...
privateBPQ = ezdb.exec( 
	string="SELECT * FROM #data.data.bloodpressure# WHERE bp_pid = :pid", 
	bindArgs = { pid = "#sess.current.participantId#" } 
).results;

//...
privateReBP = ( privateBPQ.bp_daterecorded eq "" || DateDiff( "d", privateBPQ.bp_daterecorded, Now() ) gt 30 ); 

//Check in
checkIn = {
	//Blood pressure
	//Do I need a new blood pressure?
	 getNewBP = (privateReBP) ? 1 : 0 
	,BPDaysLeft = (privateReBP) ? 1 : 0 
	,BPSystolic = (privateReBP) ? 40 : privateBPQ.bp_systolic
	,BPDiastolic = (privateReBP) ? 40 : privateBPQ.bp_diastolic
	,BPMinSystolic = 40  
	,BPMaxSystolic = 160
	,BPMinDiastolic = 40
	,BPMaxDiastolic = 90

	//Target Heart Rate
	,targetHR = 0

	//Weight
	,weight = 0

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

//...
for ( n in ListToArray( ValueList( checkIn.qCompletedDays.results.dayofwk, "," ) ) )
	{	checkIn.cdays[ n ] = n; }
</cfscript>
