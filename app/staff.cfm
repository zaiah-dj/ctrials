<!--- staff.cfm --->
<cfscript>
public = {
	staff = ezdb.exec(
		string = "select * from #data.data.staff# where ts_siteid = :site"
	 ,bindArgs = { site = siteId }
	)

 ,staff=ezdb.exec( string = "SELECT * FROM #data.data.staff#" )

 ,selStaff=ezdb.exec( string = "SELECT * FROM #data.data.sessiondstaff#" )

 ,selParts=ezdb.exec( string = "SELECT * FROM #data.data.sessiondpart#" )

 ,sel = ezdb.exec( 
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
				ON Staff.ts_staffid = M.ss_staffid ) as StaffPlus
		ON Parts.participantGUID = StaffPlus.sp_participantGUID
		"
   ,bindArgs = { 
			site_id= siteId
		 ,sid    = sess.current.staffId 
		 ,ssid   = sess.current.id
		}
	)

 ,allSel = ezdb.exec( 
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
				ON Staff.ts_staffid = M.ss_staffid ) as StaffPlus
		ON Parts.participantGUID = StaffPlus.sp_participantGUID
		"
   ,bindArgs = { 
			site_id= siteId
		 ,sid    = csSid
		}
	)

	,junior = ezdb.exec(
		string = " 
							SELECT * FROM 
								#data.data.sessiondstaff# 
							WHERE
								ss_sessdayid = :sid"
	 ,bindArgs = { sid = csSid }
	)

};



//writedump( public.junior ); abort;
</cfscript>
