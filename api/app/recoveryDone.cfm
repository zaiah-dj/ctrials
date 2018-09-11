<!--- save recovery data (for both exericses) --->
<cfscript>
/*
Save:

breaks (how many)
session stopped early
reason
heart rate, rpe, and affect here if stopped early (will need session trickery)

endurance fields to be written are these?	
	 breaks
	,[m3_rechr]
	,[m3_recoth1]
	,[m3_recoth2]
	,[m3_recprctgrade]
	,[m3_recrpm]
	,[m3_recspeed]
	,[m3_recwatres]

Find resistance fields and see if it saves
 */


if ( StructKeyExists( form, "pid" ) ) {
	//Get type
	type = dbExec(
		string = "select randomGroupCode from #data.data.participants# where participantGUID = :pid"
	 ,bindArgs = { pid = form.pid }
	).results.randomGroupCode;

	if ( type neq "" ) { 
		if ( ListContains( const.ENDURANCE, type ) ) {	
			dbb = data.data.endurance;

			v = cmValidate( form, {
				recovery = { req = true } 
			 ,breaksTaken = { req = true } 
			}); 

			db = dbExec(
				string = ""
			 ,bindArgs = {}
			);
		}
		else if ( ListContains( const.RESISTANCE, type ) ) {
			dbb = data.data.resistance;

			v = cmValidate( form, {
				recovery = { req = true } 
			 ,breaksTaken = { req = true } 
			 ,reasonStoppedEarly = { req = true } 
			 ,recoveryAffect = { req = true } 
			 ,recoveryRPE = { req = true } 
			 ,recoveryHR = { req = true } 
			}); 

			db = dbExec(
				string = ""
			 ,bindArgs = {}
			);
		}
	}
}
</cfscript>
