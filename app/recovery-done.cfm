<!--- save recovery data (for both exericses) --->
<cfscript>

/*
Save:

breaks (how many)
session stopped early
reason
heart rate, rpe, and affect here if stopped early (will need session trickery)


 */


if ( StructKeyExists( form, "pid" ) ) {
	//Get type
	type = ezdb.exec(
		string = "select randomGroupCode from #data.data.participants# where participantGUID = :pid"
	 ,bindArgs = { pid = form.pid }
	).results.randomGroupCode;

	if ( type neq "" ) { 
		if ( ListContains( ENDURANCE, type ) ) {	
			dbb = data.data.endurance;

			v = val.validate( form, {
				recovery = { req = true } 
			 ,breaksTaken = { req = true } 
			}); 

			db = ezdb.exec(
				string = ""
			 ,bindArgs = {}
			);
		}
		else if ( ListContains( RESISTANCE, type ) ) {
			dbb = data.data.resistance;

			v = val.validate( form, {
				recovery = { req = true } 
			 ,breaksTaken = { req = true } 
			 ,reasonStoppedEarly = { req = true } 
			 ,recoveryAffect = { req = true } 
			 ,recoveryRPE = { req = true } 
			 ,recoveryHR = { req = true } 
			}); 

			db = ezdb.exec(
				string = ""
			 ,bindArgs = {}
			);
		}
	}
}
</cfscript>
