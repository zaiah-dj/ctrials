<cfscript>

//recall is needed, so let's handle it


//also check to see if a session was stopped early
aborted = StructKeyExists( url, "abort" );
	//get the type of user
	type = dbExec(
		string = "select randomGroupCode from #data.data.participants# where participantGUID = :pid"
	 ,bindArgs = { pid = url.id }
	).results.randomGroupCode;
	isEnd = ListContains(const.ENDURANCE, type );
	isRes = ListContains(const.RESISTANCE, type );
	mpName = ( isEnd ) ? "time" : "extype";
	partClass = ( isEnd ) ? "endurance" : "resistance";	
	lastIndicator = ( isEnd ) ? "Recorded Time" : "Exercise";

if ( aborted ) {

	//Figure out The text name will do a lot
	lastExercise = (StructKeyExists(url, mpName )) ? url[ mpName ] : 0;
	obj = CreateObject( "component", "components.#partClass#" ).init();	
	lastExerciseName = (isEnd) ? obj.getTimeInfo( lastExercise ).pname : obj.getExerciseName( lastExercise ).pname;
	lastExercisePrefix = (isEnd) ? obj.getTimeInfo( lastExercise ).prefix : obj.getExerciseName( lastExercise ).prefix;

}
</cfscript>
