SELECT
	 UP.participantGUID
	,UP.pid
	,UP.firstname
	,UP.lastname
	,UP.acrostic
	,UP.randomGroupGUID
	,UP.randomGroupCode
	,UP.randomGroupDescription
	,UP.siteID
	,UP.siteName
	,UP.siteGUID
	,UP.d_session
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
			v_ADUSessionTickler	
		WHERE participantGUID NOT IN (
			SELECT DISTINCT 
				csd_participant_guid 
			FROM 
				ac_mtr_session_interventionist_assignment
			WHERE 
				csd_daily_session_id = :sid
		) 
	) AS UP

ON TP.participantGUID = UP.participantGUID
