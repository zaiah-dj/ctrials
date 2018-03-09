<!--- This should never be called on it's own.  It should always follow check.cfm --->
<cfquery name="updateSession" datasource=#data.source#>
	UPDATE	
		ac_mtr_participant_transaction_set
	SET
		p_lastUpdateTime = <cfqueryparam value="#DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" )#" cfsqltype="CF_SQL_DATETIME">
	WHERE
		p_transaction_id = <cfqueryparam value="#sessionVar#" cfsqltype="CF_SQL_INT">
	;
</cfquery>

