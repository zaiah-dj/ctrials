SELECT DISTINCT * FROM
( SELECT settingGUID AS stgGUID, settingDescription FROM #data.data.etst# ) As Sett
INNER JOIN
(	SELECT * FROM
	( 
		SELECT * FROM
		( 
			SELECT * FROM
			( SELECT 
					machineGUID as a_maguid
				 ,manufacturerGUID as a_mnguid
				FROM #data.data.etma# ) As Ma
			INNER JOIN
			( SELECT
					manufacturerGUID
				 ,manufacturerDescription
				FROM #data.data.etmn# ) As Mn
			ON Ma.a_mnguid = Mn.manufacturerGUID
		) As AllManufacturers
		INNER JOIN
		( 
			SELECT * FROM
			( SELECT 
					machineGUID as b_maguid
				 ,modelGUID as b_moguid
				FROM #data.data.etma# ) As Ma
			INNER JOIN
			( SELECT 
					modelGUID
				 ,modelDescription
				FROM #data.data.etmo# ) As Mo
			ON Ma.b_moguid = Mo.modelGUID
		) As AllModels
		ON AllManufacturers.a_maguid = AllModels.b_maguid 
	) As Machines

	INNER JOIN
	(
		SELECT * FROM
			( SELECT * FROM #data.data.etex# ) AS EXY
			INNER JOIN
			(
				SELECT * FROM
				( SELECT * FROM 
					#data.data.participants# 
					WHERE participantGUID = :pid ) AS PT
				INNER JOIN
				(
					SELECT 
						 siteGUID AS sGUID
						,equipmentGUID
						,settingGUID	
						,machineGUID
						,exerciseGUID AS exGUID
					FROM
						( SELECT DISTINCT
								siteGUID AS ETSSITEGUID
							 ,equipmentGUID AS eGUID
							 ,settingGUID	
							FROM
							#data.data.et#
						) AS ETS
					INNER JOIN
						( SELECT DISTINCT
								siteGUID
							 ,machineGUID
							 ,equipmentGUID
							 ,exerciseGUID
							 ,active
							FROM 
								#data.data.eteq# 
							WHERE 
								active = 1
							AND
								interventionGUID = 'BE3D6628-7BC2-452C-92AC-9F03B992316B'
						) AS ETE
					ON ETS.ETSSITEGUID = ETE.siteGUID 
				) AS PE 
				ON PT.siteGUID = PE.sGUID  
				WHERE exGUID = :exc
			) AS AXY
			ON EXY.exerciseGUID = AXY.exGUID
		) As ABB 
		ON Machines.a_maguid = ABB.machineGUID
	) AS Other
	ON Sett.stgGUID = Other.settingGUID
