<!--- staff.cfm --->
<cfscript>

public = {
	staff = dbExec(
		string = "select * from #data.data.staff# where ts_siteid = :site"
	 ,bindArgs = { site = siteId }
	)

 ,staff=dbExec( string = "SELECT * FROM #data.data.staff#" )

 ,selStaff=dbExec( string = "SELECT * FROM #data.data.sessiondstaff#" )

 ,selParts=dbExec( string = "SELECT * FROM #data.data.sessiondpart#" )

 ,sel = dbExec( 
		string = "
		SELECT * FROM
			( SELECT * FROM #data.data.participants# ) as Parts
		INNER JOIN
			(	SELECT * FROM
					( SELECT * FROM #data.data.staff# ) as Staff
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
		"
   ,bindArgs = { 
			site_id= siteId
		 ,sid    = cs.staffId 
		 ,ssid   = cs.id
		}
	)

 ,allSel = dbExec( 
		string = "
		SELECT * FROM
			( SELECT * FROM #data.data.participants# ) as Parts
		INNER JOIN
			(	SELECT * FROM
					( SELECT * FROM #data.data.staff# ) as Staff
					JOIN			
					( SELECT * FROM
							( SELECT * FROM 
								#data.data.sessiondstaff# 
							WHERE
								ss_sessdayid = :sid
							 ) as SiteMembers 
							INNER JOIN
							( SELECT * FROM #data.data.sessiondpart# ) as SelParts
						ON SiteMembers.ss_participantrecordkey = SelParts.sp_participantrecordkey
					) as M
				ON Staff.ts_staffguid = M.ss_staffguid ) as StaffPlus
		ON Parts.participantGUID = StaffPlus.sp_participantGUID
		"
   ,bindArgs = { 
			site_id= siteId
		 ,sid    = csSid
		}
	)

	,junior = dbExec(
		string = " 
			SELECT * FROM 
				#data.data.sessiondstaff# 
			WHERE
				ss_sessdayid = :sid"
	 ,bindArgs = { sid = csSid }
	)

};
</cfscript>
