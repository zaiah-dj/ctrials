<cfscript>
//Bring in ezdb
ezdb  = CreateObject( "component", "components.quella" );

//Destroy session key in db
ezdb.exec( 
	string = "DELETE FROM 
		ac_mtr_participant_transaction_set
	WHERE 
		p_transaction_id = :sid"
 ,bindArgs = { sid = 	session.iv_motrpac_transact_id }
);

//Get rid of other keys
StructDelete( session, "iv_motrpac_transact_id" );

//Loop through and get rid of all other session data
for ( n in session ) {
	StructDelete( session, n );
}
</cfscript>
