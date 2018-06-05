SELECT
	MAX( stdywk ) as mstdywk 
 ,MAX( dayofwk ) as mdayofwk
FROM
	#data.data.endurance#
WHERE
	participantGUID = :pid
GROUP BY
	participantGUID
