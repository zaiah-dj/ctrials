<!---
Allow staff to choose a list of participants for the day.
--->
<cfquery datasource="#data.source#" name="all_part_list">
	SELECT 
		* 
	FROM 
		ac_mtr_participants
	ORDER BY participant_lname ASC 
</cfquery>
