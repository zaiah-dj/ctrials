<!--- | --->
<cfif sess.status gt 1>
	<cfquery datasource = "#data.source#" name = "part_list">
	SELECT
		*
	FROM
	( SELECT 
			p_pid
		FROM 
			ac_mtr_participant_transaction_members
		WHERE 
			p_transaction_id = <cfqueryparam value="#sess.key#" cfsqltype="cf_sql_nvarchar"> 
	) AS CurrentTransactionIDList
	LEFT JOIN
	( SELECT 
			* 
		FROM 
			ac_mtr_participants 
	) AS amp
	ON CurrentTransactionIDList.p_pid = amp.p_id;
	</cfquery>
</cfif>
