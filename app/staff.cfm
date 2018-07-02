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
							( SELECT * FROM #data.data.sessiondstaff# ) as SiteMembers 
							INNER JOIN
							( SELECT * FROM #data.data.sessiondpart# ) as SelParts
						ON SiteMembers.ss_participantrecordkey = SelParts.sp_participantrecordkey
					) as M
				ON Staff.ts_staffid = M.ss_staffid ) as StaffPlus
		ON Parts.participantGUID = StaffPlus.sp_participantGUID
		"
   ,bindArgs = { site_id = siteId, sid=sess.current.staffId }
	)

 ,megalife = ezdb.exec(
		string = "
		SELECT * FROM
			( SELECT * FROM 
				#data.data.participants# 
			) as PARTY
			INNER JOIN	
			( SELECT * FROM
				( SELECT * 
					FROM 
						#data.data.staff#
					WHERE
						ts_siteid = :site_id
				) as staff 
				INNER JOIN
				( SELECT * FROM
					( SELECT * FROM
						#data.data.sessiondstaff# 
						WHERE
							ss_staffid = :sid ) as SiteMembers 
					INNER JOIN
					( SELECT * FROM
						#data.data.sessiondpart# ) as SelParts
					ON SiteMembers.ss_participantrecordkey = SelParts.sp_participantrecordkey
				) as mem  
				ON staff.ts_staffid = mem.ss_staffid 
			) as GAR
		ON PARTY.participantguid = GAR.sp_participantguid 
		"
		,bindArgs = {
			sid = csSid
		 ,site_id = siteId 
		}	
	)

 ,staffToMem = ezdb.exec(
		string = "
		SELECT * FROM
			(SELECT * FROM
				( SELECT * FROM
					#data.data.staff# 
				WHERE
					ts_siteid = :site ) as j 	
				INNER JOIN
				( SELECT * FROM
					#data.data.sessiondstaff# 
				WHERE
					ss_sessdayid = :sid ) as k
			ON j.ts_staffid = k.ss_staffid ) as SiteMembers 
			INNER JOIN
			( SELECT * FROM
				#data.data.sessiondpart# ) as SelParts
			ON SiteMembers.ss_participantrecordkey = SelParts.sp_participantrecordkey
		"
		,bindArgs = {
			sid = csSid
		 ,site = siteId 
		}	
	)
};



//writedump( public ); abort;
</cfscript>
