/*

arrg.sql


*/
SELECT 
	[groupID], 
	[siteID], 
	[siteGUID], 
	[siteName], 
	[siteDescription], 
	[siteLocation], 
	[sitePIName], 
	[sitePIEmail], 
	[siteType], 
	[domainGUID], 
	[confCallInfo], 
	[d_inserted], 
	[insertedby], 
	[documentFolderGUID], 
	[active], 
	[physAdd1], 
	[physAdd2], 
	[physCity], 
	[physStPr], 
	[physCountry], 
	[physCode], 
	[shipAdd1], 
	[shipAdd2], 
	[shipCity], 
	[shipStPr], 
	[shipCountry], 
	[shipCode], 
	[contFName], 
	[contLName], 
	[contEmail], 
	[contPhone], 
	[contWebsite], 
	[mailAdd1], 
	[mailAdd2], 
	[mailCity], 
	[mailStPr], 
	[mailCountry], 
	[mailCode], 
	[domainCode], 
	[domainDescription] 
FROM [dbo].[v_sysSites] 
WHERE
	domainCode = :dom
AND 
	siteGUID IN ( :list )
	
