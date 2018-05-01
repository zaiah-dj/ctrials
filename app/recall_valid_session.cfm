<!--- ... --->
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
	 ,bindArgs = {
			pid = currentId
		 ,sid = sess.key
		}
	);

	//There was an error
	if ( !p.status ) {
		writedump( p );abort;
	}

	old_ws = {};
	
	//Deserialize the old records
	if ( p.prefix.recordCount )
		old_ws = DeserializeJSON( p.results.misc );

}
catch (any e) {
	req.sendAsJSON( status = 0, message = "#e.message#" );
}
</cfscript>
