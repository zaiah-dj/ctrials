<!--- select participant notes --->
<cfscript>
if ( isDefined( "url.id" ) ) {
	myPid = url.id;

	pNotes = ezdb.exec(
		string = "
			SELECT
				note_datetime_added	
			 ,note_text	
			FROM 
				ac_mtr_participant_notes
			WHERE 
				note_participant_match_id = :pid
			ORDER BY note_datetime_added DESC
			"
	 ,datasource = "#data.source#" 
	 ,bindArgs = {
			pid = myPid
		});
}
</cfscript>
