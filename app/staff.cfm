<!--- staff.cfm --->
<cfscript>
public = {
	staff = ezdb.exec(
		string = "select * from #data.data.staff# where ts_siteid = :site"
	 ,bindArgs = { site = siteId }
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
