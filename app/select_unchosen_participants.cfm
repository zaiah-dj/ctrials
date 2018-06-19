<!--- reconcile 'part_list' vs 'all_part_list' --->
<cfscript>
if ( sess.status gt 1 ) {
	unselectedParticipants = ezdb.exec( 
		string = "
		SELECT * FROM 
			#data.data.participants# 
		WHERE participantGUID NOT IN (
		  SELECT DISTINCT p_pid FROM 
				#data.data.sessionMembers#	
			WHERE 
				p_transaction_id = :sid 
		) ORDER BY lastname ASC"
	 ,bindArgs = {
			sid = sess.key
		}
	);

	selectedParticipants = ezdb.exec( 
		string = "SELECT * FROM
		( SELECT p_pid, p_participantGUID FROM 
				ac_mtr_participant_transaction_members
			WHERE 
				p_transaction_id = :sid ) AS CurrentTransactionIDList
		LEFT JOIN
		( SELECT * FROM
				#data.data.participants# ) AS amp
		ON CurrentTransactionIDList.p_participantGUID = amp.participantGUID"
	 ,bindArgs = {
			sid = sess.key
		}
	);
}
</cfscript>
