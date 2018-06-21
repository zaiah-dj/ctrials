<cfscript>
//Logic to get the most current ID.
sess.current.participantId = 0;

//If an ID is specified in the URL or in POST (POST getting preference), then it is the current one
if ( StructKeyExists( form, "pid" ) )
	sess.current.participantId = form.pid;	
else if ( StructKeyExists( url, "id" ) )
	sess.current.participantId = url.id;
else {
	//Get the newest one
	if ( !isDefined("sess.key" ) )
		sess.current.participantId = 0;
	else { 
		sess.current.participantId = ezdb.exec(
			string = "SELECT 
				TOP 1 active_pid 
			FROM 
				#data.data.sessionTable#
			WHERE
				session_id = :sid
			"
		 ,bindArgs = {
				sid = sess.key
			}
		).results.active_pid;
	}
}
</cfscript>
