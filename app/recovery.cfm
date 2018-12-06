<cfscript>
	//get the type of user
	type = dbExec(
		string = "select randomGroupCode from v_ADUSessionTickler where participantGUID = :pid"
	 ,bindArgs = { pid = url.id }
	).results.randomGroupCode;
	isEnd = ListContains(const.ENDURANCE, type );
	isRes = ListContains(const.RESISTANCE, type );
	mpName = ( isEnd ) ? "time" : "extype";
	dbName = ( isEnd ) ? "frm_eetl" : "frm_retl";
	partClass = ( isEnd ) ? "endurance" : "resistance";	
	lastIndicator = ( isEnd ) ? "Recorded Time" : "Exercise";

//recall is needed, so let's handle it
previous = dbExec( 
	string = "
SELECT 
	breaks
, stopped
, stoppedhr
, stoppedrpe
, stoppedOthafct
, stoppedsp
FROM
	#dbName#
WHERE
	participantGUID = :pid
AND
	d_visit = :dvisit
"
, bindArgs = {
		pid = currentId
  , dvisit = { value = cdate, type = "cf_sql_date" }
  }
);
	

//Approximate the values from what is in the database (if anything)
pr = previous.results;
values = {
	recoveryDone = ( previous.prefix.recordCount gt 0 )
 ,breaksTaken=[
		(pr.breaks eq 0 || pr.breaks eq "" ) ? "checked" : ""
	 ,(pr.breaks eq 1 ) ? "checked" : ""
	 ,(pr.breaks eq 2 ) ? "checked" : ""
	]
 ,sessionStoppedEarly=[
		(pr.stopped eq 0 || pr.stopped eq "") ? "checked" : ""
	 ,(pr.stopped eq 1 ) ? "checked" : ""
	]
 ,stoppedReason = pr.stoppedsp
 ,stoppedAfct = ( pr.stoppedOthafct eq "" ) ? 0 : pr.stoppedOthafct
 ,stoppedHr = ( pr.stoppedhr eq "" ) ? 145 : pr.stoppedhr
 ,stoppedRpe = ( pr.stoppedrpe eq "" ) ? 13 : pr.stoppedrpe
 ,hiddenOrNot = ( pr.stopped eq 1 ) ? "" : "js-hidden"
}

</cfscript>
