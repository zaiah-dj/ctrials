<!---
select everything from the thing
--->
<!---
SELECT * FROM ac_mtr_participant_transaction_set
WHERE p_transaction_id = <cfqueryparam cfsqltype="cf_sql_varchar"> ;
--->
<cfquery datasource = "#data.source#" name = "part_list">
SELECT 
	*
FROM
( SELECT 
		p_id	
	FROM 
		ac_mtr_participant_transaction_members
	WHERE 
		p_transaction_id = <cfqueryparam value="#session.iv_sess_id#" cfsqltype="cf_sql_int"> 
) AS CurrentTransactionIDList
LEFT JOIN
( SELECT 
		* 
	FROM 
		ac_mtr_participants 
) AS amp
ON CurrentTransactionIDList.p_id = amp.participant_id;
</cfquery>
<!---
<cfdump var=#part_list#>
<cfabort>
--->

