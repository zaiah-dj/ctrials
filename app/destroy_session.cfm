<cfscript>
if ( StructKeyExists( session, "ivId" ) ) { 
	//Bring in ezdb
	ezdb  = CreateObject( "component", "components.quella" );

	//Destroy session key in db
	ezdb.exec( 
		string = "DELETE FROM 
			ac_mtr_participant_transaction_set
		WHERE 
			p_transaction_id = :sid"
	 ,bindArgs = { sid = 	session.ivId }
	);

	//Get rid of other keys
	StructDelete( session, "ivId" );
}

//Loop through and get rid of all other session data
for ( n in session ) {
	StructDelete( session, n );
}
</cfscript>
