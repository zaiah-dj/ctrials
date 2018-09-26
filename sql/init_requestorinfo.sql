SELECT
	 requestor
	,resource
	,resource2
FROM
	dbo._sysAccessControl
WHERE
	requestor = :uuid
AND 
	resource = (
		Select 
			siteGUID 
		from 
			v_sysSites 
		Where 
			siteGUID = :siteguid 
	)
AND 
	resource2 = (
		Select 
			siteAccessTypeGUID 
		from 
			_sysSiteAccessTypes 
		Where 
			siteAccessTypeName = :accessTypeName
	)

