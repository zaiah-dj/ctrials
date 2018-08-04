SELECT DISTINCT * FROM
( SELECT 
		settingGUID AS stgGUID, 
		settingDescription 
	FROM 
		equipmentTrackingSettings ) As Sett

INNER JOIN

(	SELECT * FROM
	( SELECT * FROM
		( SELECT * FROM
			( SELECT 
					machineGUID as a_maguid
				 ,manufacturerGUID as a_mnguid
				FROM equipmentTrackingMachines ) As Ma
			INNER JOIN
			( SELECT
					manufacturerGUID
				 ,manufacturerDescription
				FROM equipmentTrackingManufacturers ) As Mn
			ON Ma.a_mnguid = Mn.manufacturerGUID
		) As AllManufacturers

		INNER JOIN

		( SELECT * FROM
			( SELECT 
					machineGUID as b_maguid
				 ,modelGUID as b_moguid
				FROM equipmentTrackingManufacturers ) As Ma

			INNER JOIN

			( SELECT 
					modelGUID
				 ,modelDescription
				FROM equipmentTrackingModels ) As Mo
			ON Ma.b_moguid = Mo.modelGUID
		) As AllModels
		ON AllManufacturers.a_maguid = AllModels.b_maguid 
	) As Machines

	INNER JOIN
	(
		SELECT * FROM
			( SELECT * FROM equipmentTrackingExercises ) AS EXY
			INNER JOIN
			( SELECT * FROM
				( SELECT * FROM 
						ac_mtr_participants_v2	
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
								equipmentTracking	
						) AS ETS
					INNER JOIN
						( SELECT DISTINCT
								siteGUID
							 ,machineGUID
							 ,equipmentGUID
							 ,exerciseGUID
							 ,active
							FROM 
								equipmentTrackingEquipment	
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
