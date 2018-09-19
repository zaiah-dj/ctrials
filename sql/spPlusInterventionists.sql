SELECT
	 SP.participantGUID
	,SP.pid
	,SP.firstname
	,SP.lastname
	,SP.acrostic
	,SP.randomGroupGUID
	,SP.randomGroupCode
	,SP.randomGroupDescription
	,SP.siteID
	,SP.siteName
	,SP.siteGUID
	,SP.d_session
FROM
	(
		(
			SELECT 	
				d_visit
			 ,participantGUID
			FROM
				frm_RETL
			WHERE
				d_visit = :today
		)
		UNION
		(
			SELECT 	
				d_visit
			 ,participantGUID as eguid
			FROM
				frm_EETL
			WHERE
				d_visit = :today
		)
	) AS TP
INNER JOIN 
	(
		SELECT
			 participantGUID
			,pid
			,firstname
			,lastname
			,acrostic
			,randomGroupGUID
			,randomGroupCode
			,randomGroupDescription
			,siteID
			,siteName
			,siteGUID
			,d_session
		FROM
			( SELECT * FROM
					ac_mtr_session_interventionist_assignment
				WHERE 
					csd_interventionist_guid = :guid
				AND
					csd_daily_session_id = :sid
			) AS AssociatedParts 
		LEFT JOIN
			( SELECT * FROM v_ADUSessionTickler	) AS amp
		ON AssociatedParts.csd_participant_guid = amp.participantGUID
	) AS SP
ON 
	TP.participantGUID = SP.participantGUID

WHERE
	SP.siteID = :site_id 
