<!--- reconcile 'part_list' vs 'all_part_list' --->
<cfif sess.status gt 1>
	<cfset notList = "( '#ValueList( part_list.p_lname, "', '" )#' )">
	<cfoutput>#notList#</cfoutput>
	<cfsavecontent variable="gig">
		SELECT 
			* 
		FROM
			ac_mtr_participants
		WHERE
			p_lname IN ( :in_lim )
		ORDER BY p_lname ASC
	</cfsavecontent>
</cfif>
