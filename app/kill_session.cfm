<cfif StructKeyExists( session, "iv_motrpac_transact_id" )>
	<cfquery name="killSession" datasource=#data.source#>
	DELETE FROM 
		ac_mtr_participant_transaction_set
	WHERE 
		p_transaction_id = <cfqueryparam value="#session.iv_motrpac_transact_id#" cfsqltype="CF_SQL_INT">
	</cfquery>

	<cfscript>
	StructDelete( session, "iv_motrpac_transact_id" );
	</cfscript>
</cfif>
