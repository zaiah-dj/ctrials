<!--- select participant notes --->
<cfscript>
try {
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
			pid = currentId 
		});

	if ( !pNotes.status ) {
		writedump( pNotes.message );
		abort;	
	}	
}
catch (any e) {
	writedump( e );
ABORT;	
}
</cfscript>
