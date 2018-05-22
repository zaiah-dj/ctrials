<cfquery datasource="#data.source#" name="all_part_list">
	SELECT 
		* 
	FROM 
		#data.data.participants#	
	ORDER BY lastname ASC 
</cfquery>
