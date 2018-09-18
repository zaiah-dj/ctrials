SELECT
	TOP( 1 )
	dayofwk as pDayofwk
 ,pGUID
 ,stdywk as pStdywk
 ,d_visit
FROM
( SELECT 
	TOP(2)
	 dayofwk
	,participantGUID as pGUID
	,stdywk
	,d_visit
FROM
	frm_RETL
WHERE
	participantGUID = :pid 
AND
	d_visit < :cdate
AND
	stdywk <= :stdywk
ORDER BY
	stdywk DESC, dayofwk DESC ) chimney
ORDER BY
	stdywk ASC, dayofwk ASC
