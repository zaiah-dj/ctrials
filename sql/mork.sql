SELECT * FROM
	( SELECT * FROM vADU_sessionTickler ) as Parts
INNER JOIN
	(	SELECT * FROM
			( SELECT * FROM vInterventionists ) as Staff
			JOIN			
			( SELECT * FROM
					( SELECT * FROM 
						#data.data.sessiondstaff# 
					WHERE
						ss_staffsessionid = :ssid
					 ) as SiteMembers 
					INNER JOIN
					( SELECT * FROM #data.data.sessiondpart# ) as SelParts
				ON SiteMembers.ss_participantrecordkey = SelParts.sp_participantrecordkey
			) as M
		ON Staff.ts_staffguid = M.ss_staffguid ) as StaffPlus
ON Parts.participantGUID = StaffPlus.sp_participantGUID
