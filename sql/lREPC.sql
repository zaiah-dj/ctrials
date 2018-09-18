SELECT 
	 pDayofwk
	,pStdywk
	,pVisit
	,topVisit
	,topDayofwk
	,topStdywk
	,(CASE
		WHEN topDayofWk = :dow
			THEN pDayOfWk
		ELSE
			topDayOfWk
		END) as rDay
	,(CASE
		WHEN topStdywk = :stdywk
			THEN pStdyWk
		ELSE
			topStdyWk
		END) as rWeek
FROM
(
	SELECT
		TOP( 1 )
		dayofwk as pDayofwk
	 ,pGUID
	 ,stdywk as pStdywk
	 ,d_visit as pVisit
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
			stdywk DESC, dayofwk DESC ) as resultSet 
		ORDER BY
			d_visit DESC
) As Prev

INNER JOIN

(
	SELECT
		TOP( 1 )
		dayofwk as topDayofwk
	 ,tGUID
	 ,stdywk as topStdywk
	 ,d_visit as topVisit
	FROM
	( SELECT 
		TOP(2)
		 dayofwk
		,participantGUID as tGUID
		,stdywk
		,d_visit
	FROM
		frm_RETL
	WHERE
		participantGUID = :pid 
	AND
		d_visit <= :cdate
	AND
		stdywk <= :stdywk
	ORDER BY
		stdywk DESC, dayofwk DESC ) chimney
	ORDER BY
		stdywk DESC, dayofwk DESC 
) As Today 
ON Prev.pGUID = Today.tGUID
