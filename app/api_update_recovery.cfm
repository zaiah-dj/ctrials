<!--- save recovery data (for both exericses) --->
<cfscript>
/*
Save:

breaks (how many)
session stopped early
reason
heart rate, rpe, and affect here if stopped early (will need session trickery)

Find resistance fields and see if it saves
 */

if ( StructKeyExists( form, "pid" ) ) {
	//Get type
	type = dbExec(
		string = "select randomGroupCode from #data.data.participants# where participantGUID = :pid"
	 ,bindArgs = { pid = form.pid }
	).results.randomGroupCode;

	isEnd = ListContains(const.ENDURANCE, type );
	isRes = ListContains(const.RESISTANCE, type );

	//....
	if ( !StructKeyExists( form, "sessionStoppedEarly" ) ) {
		req.sendAsJson( status = 0, message = "sessionStoppedEarly does not exist." );
	}

	//If this is zero, many things aren't evaluated
	asa = form.sessionStoppedEarly;

	//Validate values
	v = cmValidate( form, {
		recovery = { req = true } 
	 ,breaksTaken = { req = true } 
	 ,dayofwk = { req = true } 
	 ,stdywk = { req = true } 
	 ,sessionStoppedEarly = { req = true } 
	 ,reasonStoppedEarly = { req = ( asa ), ifNone = "" } 
	 ,recoveryAffect = { req = ( asa ), ifNone = 0 } 
	 ,recoveryRPE = { req = ( asa ), ifNone = 0 } 
	 ,recoveryHR = { req = ( asa ), ifNone = 0 } 
	}); 

	if ( !v.status ) {
		req.sendAsJson( status = 0, message = "#SerializeJSON( v )#" );
	}

	fv = v.results;

/*
	req.sendAsJson( status = 0, message = "#SerializeJSON( fv )#" );
	#iif( asa, DE(''), DE('') )# 
 */

	dbName = isEnd ? data.data.endurance : data.data.resistance;
	db = dbExec(
		string = "
			UPDATE 
				#dbName#
			SET
				breaks = :breaksTaken
			 ,stopped = :stopped
				#iif( asa, DE(',stoppedhr = :hr'), DE('') )# 
				#iif( asa, DE(',stoppedrpe = :rpe'), DE('') )# 
				#iif( asa, DE(',stoppedOthafct = :afct'), DE('') )# 
				#iif( asa, DE(',stoppedsp = :sp'), DE('') )# 
			WHERE
				participantGUID = :pid
			AND
				dayofwk = :dow
			AND
				stdywk = :sw
		"
	 ,bindArgs = {
			breaksTaken = fv.breaksTaken
		 ,dow = fv.dayofwk
		 ,sw = fv.stdywk
		 ,pid = form.pid
		 ,stopped = form.sessionStoppedEarly
		 ,hr = fv.recoveryHR
		 ,rpe = fv.recoveryRPE
		 ,afct = fv.recoveryAffect
		 ,sp = fv.reasonStoppedEarly
		}
	);

	if ( !db.status ) {
		req.sendAsJson( status = 0, message = "#SerializeJSON( db )#" );
	}

	req.sendAsJson( status = 1, message = "SUCCESS!" );
}
</cfscript>
