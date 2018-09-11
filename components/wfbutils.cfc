/* --

 */
component name="wfbutils" {
	function buildRecordThreads( t, q ) {
		if ( !StructKeyExists( t, "participants" ) ) { 
			t.participants = {};
			//Check for the participant key in the partiicpants struct
			for ( p in q ) {
				//Regenerate if this is not there.
				if ( !StructKeyExists( t.participants, p.participantGUID ) ) {
					//Create a key that can be referenced by the participant GUID
					cp = t.participants[ Trim( p.participantGUID ) ] = {};
					//cp.recordThread = Trim( dbExec( string = "SELECT newID() as newGUID" ).results.newGUID );
					cp.checkInCompleted = 0 ;
					cp.exerciseParameter = 0 ;
					cp.recoveryCompleted = 0;
					cp.lastExerciseCompleted = 0;
					cp.randomizedType = ( ListContains( const.ENDURANCE, p.randomGroupCode ) ) ? E : R;
					cp.randomizedTypeName = ( ListContains( const.ENDURANCE, p.randomGroupCode ) ) ? "Endurance" : "Resistance";
					cp.week = 0;
					cp.getNewBP = 0;	
					//This has to be initialized later...
					cp.BPDaysLeft = 0;
					cp.BPSystolic = 0;
					cp.BPDiastolic = 0;
					cp.targetHR = 0;
					cp.weight = 0;
					cp.exlist = 0;
				}
			}
		}
	}


	//Display a message upon redirection
	function errAndRedirect( Required String goto, Required String msg, parameters ) {
		//clearly, this is not a good way to handle this...
		if ( StructKeyExists( arguments, "parameters" ) && !IsStruct( StructFind( arguments, "parameters" ) ) ) {
			throw "Parameters argument is not a struct!";
		} 

		//Create an array for the link
		theLink = link( goto & ".cfm" ) & "?";
		theLink &= "err=" & EncodeForURL( msg ) & "";

		//Add the params
		if ( StructKeyExists( arguments, "parameters" ) ) {
			//Loop through?
			for ( Par in arguments.parameters ) {
				theLink &= "&#Par#=#arguments.parameters[ Par ]#";
			}
		}

		//Redirect
		location( 
			addtoken="no" 
		 ,url = theLink
		);
	}
}
