<cfscript>
errstr = "... - ";
try {
	stat = cmValidate( form, { 
		pid = { req = true }
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}

	fv = stat.results;

	stat = dbExec(
		string = "SELECT * FROM ParticipantNotes WHERE participantGUID = :pid ORDER BY notedate DESC"
	 ,bindArgs = { pid = fv.pid }
	);

	if ( !stat.status )	{
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}
}
catch (any e) {
	req.sendAsJson( 
		status = 500,
		message = '#e.message# - #e.detail#' 
	);
}

writeoutput( SerializeJSON( stat ) );
abort;
req.sendAsJson( 
	status = 200,
	message = "#SerializeJSON( stat.results )#" 
);
</cfscript>
