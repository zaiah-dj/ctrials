<cfquery datasource="#data.source#" name="all_part_list">
	SELECT 
		* 
	FROM 
		ac_mtr_participants
	ORDER BY p_lname ASC 
</cfquery>
