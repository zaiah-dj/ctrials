<!--- release_participant.cfm --->
<cfscript>
try {
	dbExec(
		string = "
		DELETE FROM 
			#data.data.sia#
		WHERE 
			csd_participant_guid = :pguid
		AND
			csd_daily_session_id = :sid
		"
	 ,bindArgs = {
			sid = csSid
		 ,pguid = currentId 
		}
	);
}
catch ( any ff ) {

	req.sendAsJson( 
		status = 0, 
		message = "Error occured at api/release_participant: #ff#" 
	); abort;

}


req.sendAsJson( 
	status = 1, 
	message = "Deleted #currentId# from table." 
); 

</cfscript>
