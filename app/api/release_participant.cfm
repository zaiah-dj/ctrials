<!--- release_participant.cfm --->
<cfscript>
try {
	ezdb.exec(
		string = "
		DELETE FROM 
			#data.data.sessiondpart#
		WHERE 
			sp_participantGUID = :pguid
		AND
			sp_sessdayid = :sfid
		"
	 ,bindArgs = {
			sfid = csSid
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
abort;

</cfscript>
