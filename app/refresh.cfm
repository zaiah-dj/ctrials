<!--- Refresh the key --->
<cfscript>
sess_key = session.iv_motrpac_transact_id;
qu = CreateObject( "component", "components.quella" );

if ( StructKeyExists ( form, "userSaysYes" ) && LCase(form.userSaysYes) eq "yes" ) 
{
	ds = qu.exec( 
		string = "UPDATE ac_mtr_participant_transaction_set
			SET p_lastUpdateTime = #DateTimeFormat( Now(), "YYYY-MM-DD" )#
			WHERE p_uuid = :sid",
		bindArgs = { sid = sess_key }
	);

	//If this fails, it's kind of a problem...
	if ( !ds.status )
		0;

	//Redirect to the user's last location (which needs to be saved in db) 
	location( url="input.cfm", addtoken="no" ) /* Should go to last location */
}
else 
{
	//Delete the key...
	qu.exec( 
		datasource="#data.source#"
	 ,string="DELETE FROM ac_mtr_participant_transaction_set WHERE p_transaction_id = :sid" 
	 ,bindArgs={sid=session.iv_motrpac_transact_id}
	);
	StructDelete( session, "iv_motrpac_transact_id" );

	//Redirect somewhere...
	location( url="", addtoken="no" ) /* Should go to last location */
}

</cfscript>
