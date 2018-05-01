<cfscript>
try {
	if ( isDefined('old_ws') ) {
	new_ws = {};
	//Add keys from POST or GET
	for ( nn in [ "ps_day", "ps_week", "ps_next_sched", "staffer_id"  ] )
		if ( StructKeyExists(form, nn) ) StructInsert( new_ws, nn, form[ nn ] );
	for ( nn in [ "id", "extype", "time" ] )
		if ( StructKeyExists(url, nn)) StructInsert( new_ws, nn, url[ nn ] );

	//Check against old_ws, assume ws is already here
	if ( !StructIsEmpty(old_ws) ) {
		for ( nn in old_ws ) {
			//if element is only in old_ws, add it to new_ws
			if ( !StructKeyExists( new_ws, nn ) ) {
				StructInsert( new_ws, nn, old_ws[nn] );
			}
		}
	}

	//There are simply no values, so write a new one
	if ( !p.prefix.recordCount ) {
		p = ezdb.exec(
			string = "INSERT INTO #data.data.sessionTable# 
			 VALUES (	:aid, :sid, :loc, :tmp, :misc )"
		 ,bindArgs = {
			 aid = currentId 
			,sid = sess.key 
			,misc = SerializeJSON( new_ws )
			,loc = "#cgi.script_name#?#cgi.query_string#"
			,tmp = {type = "cf_sql_datetime", value = DateTimeFormat(Now(),"YYYY-MM-DD HH:nn:ss")}
			});
	}
	else {
		//Now update the progress table
		p = ezdb.exec(
			string =
			"UPDATE 
				#data.data.sessionTable#	
			SET 
				location = :loc
			 ,misc = :misc
			 ,active_pid = :aid 
			WHERE 
				session_id = :sid"
		 ,bindArgs = {
			  loc = "#cgi.script_name#?#cgi.query_string#"
			 ,sid = sess.key
			 ,misc = SerializeJSON( new_ws ) 
			 ,aid = currentId
			}
		);
	}

	//Use these throughout...
	globalValues = new_ws;
	}
}
catch (any e) {
	writeoutput( "session write did not work... " );
	writeoutput(e.message);
	writedump( e );
	abort;	
}
</cfscript>
