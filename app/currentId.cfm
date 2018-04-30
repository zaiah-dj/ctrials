<cfscript>
//Logic to get the most current ID.
currentId = 0;

//If an ID is specified in the URL or in POST (POST getting preference), then it is the current one
if ( StructKeyExists( form, "pid" ) )
	currentId = form.pid;	
else if ( StructKeyExists( url, "id" ) )
	currentId = url.id;
else {
	//Get the newest one
	if ( !isDefined("sess.key" ) )
		currentId = 0;
	else { 
		currentId = ezdb.exec(
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
