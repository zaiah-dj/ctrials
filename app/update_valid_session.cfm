<cfscript>
try {
	//Select from the progress table and use this to prefill fields that don't exist
	p = ezdb.exec( 
		string = 
		"SELECT * FROM
			#data.data.sessionTable#	
		 WHERE
			active_pid = :pid 
		 AND
			session_id = :sid"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = currentId
		 ,sid = sess.key
		}
	);

	//There was an error
	if ( !p.status ) {
		req.sendAsJson( status=0, message="#p.message#." );
	abort;
	}
	//There are simply no values, so write a new one
	if ( !p.prefix.recordCount ) {
		p = ezdb.exec(
			string =
			"INSERT INTO
				#data.data.sessionTable# 
				(
					active_pid
				 ,session_id
				 ,location
				)
			 VALUES (	
				 :active_pid
				,:session_id
				,:location
			 )
			"
		 ,datasource = "#data.source#"
		 ,bindArgs = {
			 active_pid = currentId 
			,session_id = sess.key 
			,location = "somewhere" 
			}
		);
	}

	//Now update the progress table
	p = ezdb.exec(
		string =
		"UPDATE 
			#data.data.sessionTable#	
		SET 
			location = :location
		WHERE 
			active_pid = :aid 
		AND 
			session_id = :sid"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			aid = currentId
		 ,sid = sess.key
		 ,location = "somewhere else"
		}
	);
}
catch (any e) {
	writeoutput( "session write did not work... " );
	writeoutput(e.message);
	abort;	
}
</cfscript>
