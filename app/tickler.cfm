<cfscript>
tickler = ezdb.exec( string = "
	SELECT 
    [participantGUID], 
    [pid], 
    [acrostic], 
    [firstname], 
    [lastname], 
    [randomGroupGuid], 
    [randomGroupCode], 
    [randomGroupDescription], 
    [siteID], 
    [siteName], 
    [siteGUID], 
    [d_session] 
	FROM [dbo].[v_ADUSessionTickler]
"
);

/*
CREATE VIEW bla AS
SELECT

FROM
	(	
	SELECT

	FROM
	)
	(	
	SELECT

	FROM
	)


SELECT
   DISTINCT a.*
FROM
   v_ADUSessionTickler a
INNER JOIN
   _sysUserPermissions b
ON
   a.SiteGUID = b.resource
WHERE
   b.requestor = '#session.userGUID#'
ORDER BY
   siteID,pid,acrostic
		 ,"select_all_participants"
		 ,"select_chosen_participants"
		 ,"select_unchosen_participants" 
		 ,"update_valid_session"
*/
</cfscript>
