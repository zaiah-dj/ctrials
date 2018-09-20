SELECT * FROM
	( SELECT * FROM v_ADUSessionTickler WHERE siteID = :site_id ) as Parts
INNER JOIN
	(	SELECT * FROM
			( 
				SELECT 
					userGUID
				, userID
				, firstname as staff_fname
				, lastname as staff_lname 
				FROM 
					v_Interventionists 
			) as Staff
			JOIN			
			( 
				SELECT * FROM 
					ac_mtr_session_interventionist_assignment	
				WHERE
					csd_daily_session_id = :ssid
				AND
					csd_interventionist_guid != :self
			) as SA 
		ON Staff.userGUID = SA.csd_interventionist_guid 
	) as StaffAssignments
ON Parts.participantGUID = StaffAssignments.csd_participant_guid
