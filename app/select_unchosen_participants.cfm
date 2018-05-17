<!--- reconcile 'part_list' vs 'all_part_list' --->
<cfscript>
if ( sess.status gt 1 ) {
	notList = "'#ValueList( part_list.p_lname, "', '" )#'";
	qu = createObject("Component", "components.quella" );

	antiPartList = qu.exec( 
		string = "
		SELECT * FROM 
			#data.data.participants# 
		WHERE p_id NOT IN (
		  SELECT DISTINCT p_pid FROM 
				ac_mtr_participant_transaction_members
			WHERE 
				p_transaction_id = :sid 
		) ORDER BY p_lname ASC"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			sid = sess.key
		}
	);

	partList = qu.exec( 
		string = "SELECT * FROM
		( SELECT p_pid FROM 
				ac_mtr_participant_transaction_members
			WHERE 
				p_transaction_id = :sid ) AS CurrentTransactionIDList
		LEFT JOIN
		( SELECT * FROM
				#data.data.participants# ) AS amp
		ON CurrentTransactionIDList.p_pid = amp.p_id"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			sid = sess.key
		}
	);
}
</cfscript>
