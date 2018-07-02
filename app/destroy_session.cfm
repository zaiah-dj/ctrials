<cfscript>
//Bring in ezdb
ezdb  = CreateObject( "component", "components.quella" );

//Destroy session key in db
ezdb.exec( 
	string = "DELETE FROM 
		#data.data.sessiondappl#	
	WHERE 
		sm_siteid = :site_id
	AND
		sm_dayofweek = :dayofwk
	"
 ,bindArgs = { 
		site_id = 999 
	 ,dayofwk = DayOfWeek( Now() )
	}
);


//Get rid of the main identifier
if ( StructKeyExists( session, "ivId" ) ) { 
	StructDelete( session, "ivId" );
}


//Loop through and get rid of all other session data
for ( n in session ) {
	StructDelete( session, n );
}
</cfscript>
