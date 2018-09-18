SELECT 
	 dayofwk
	,pGUID
	,stdywk
	,d_visit
FROM 
( SELECT 
	TOP(2)
	 dayofwk
	,participantGUID as pGUID
	,stdywk
	,d_visit
FROM
	frm_EETL
WHERE
	participantGUID = :pid 
AND
	d_visit < :cdate
AND
	stdywk <= :stdywk
ORDER BY
	stdywk DESC
 ,dayofwk DESC ) as wonk
ORDER BY d_visit DESC
