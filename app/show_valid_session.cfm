<cfscript>
//Pull the current data and log it at every request.
if ( !StructKeyExists( url, "sid" ) ) 
	req.sendAsJson( status = 0, message = "URL.SID not specified." );
else {
	try {
		a = ezdb.exec(
			string = "SELECT * FROM #data.data.sessionTable# WHERE session_id = :sid"
			,bindArgs = { sid = url.sid }
		);

		if ( !a.status )
			req.sendAsJson( status = 0, message = "#a.message#" );

		req.sendAsJson( 
			status = 1, 
			message = "cid = #currentId#, sid = #a.results.session_id#, pid = #a.results.active_pid#, location = #a.results.location#"
		);
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "#e.message#" );
	}
}
</cfscript>
