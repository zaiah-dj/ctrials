<!---
select everything from the thing
--->
<!---
SELECT * FROM ac_mtr_participant_transaction_set
WHERE p_transaction_id = <cfqueryparam cfsqltype="cf_sql_varchar"> ;
--->
<cfif sessionStatus eq 2>
<cfquery datasource = "#data.source#" name = "part_list">
SELECT 
	*
FROM
( SELECT 
		p_id	
	FROM 
		ac_mtr_participant_transaction_members
	WHERE 
		p_transaction_id = <cfqueryparam value="#mySession#" cfsqltype="cf_sql_int"> 
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
</cfif>
