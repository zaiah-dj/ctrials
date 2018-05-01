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
			pid = { type="cfsqlinteger", value=currentId } 
		 ,sid = sess.key
		}
	);

	//There was an error
	if ( !p.status ) {
		writedump( p );
		abort;
	}


	//If it's full of stuff, write a new row...	
	ws = {};
	for ( nn in [ "ps_day", "ps_week", "ps_next_sched", "timeblock"  ] )
		if ( StructKeyExists(form, nn) ) StructInsert( ws, nn, form[ nn ] );
	for ( nn in [ "extype", "timeblock" ] )
		if ( StructKeyExists(url, nn)) StructInsert( ws, nn, url[ nn ] );
	misc = ( !StructIsEmpty( ws ) ) ? SerializeJSON( ws ) : "{}";

	//There are simply no values, so write a new one
	if ( !p.prefix.recordCount ) {
		p = ezdb.exec(
			string = "INSERT INTO #data.data.sessionTable# 
			 VALUES (	:aid, :sid, :loc, :tmp, :misc )"
		 ,bindArgs = {
			 aid = currentId 
			,sid = sess.key 
			,misc = misc
			,loc = "#cgi.script_name#"
			,tmp = {type = "cf_sql_datetime", value = DateTimeFormat(Now(),"YYYY-MM-DD HH:nn:ss")}
			}
		);

		if ( !p.status ) { writedump( p ); abort; }
	}
	else {
		//Now update the progress table
		p = ezdb.exec(
			string =
			"UPDATE 
				#data.data.sessionTable#	
			SET 
				location = :location
			 ,misc = :misc
			 ,active_pid = :aid 
			WHERE 
				session_id = :sid"
		 ,bindArgs = {
				aid = currentId
			 ,sid = sess.key
			 ,misc = misc
			 ,location = cgi.script_name
			}
		);

		if ( !p.status ) { writedump( p ); abort; }
	}
	writedump( ws );abort;
}
catch (any e) {
	writeoutput( "session write did not work... " );
	writeoutput(e.message);
	abort;	
}
</cfscript>
