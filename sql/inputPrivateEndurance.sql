/*Add all the other things here*/
SELECT * FROM
	( SELECT
			 rec_id 
			,recordthread 
			,participantGUID 
			,dayofwk 
			,stdywk 
			,mchntype 
			,othMchn1
			,othMchn2
			,nomchntype 
			,Sessionmisd 
			,breaks 
		FROM
		#data.data.endurance#
	WHERE
		participantGUID = :pid
		AND stdywk = :stdywk
		AND dayofwk = :dayofwk 
		AND recordthread = :rthrd
	) as cweek
INNER JOIN
(	SELECT TOP (1) 
		 rec_id as p_rec_id
		,recordthread as p_recordthread
		,participantGUID as p_participantGUID
		,dayofwk as p_dayofwk
		,stdywk as p_stdywk
		,mchntype as p_mchntype
		,nomchntype as p_nomchntype
		,Sessionmisd as p_Sessionmisd
		,breaks as p_breaks 
	FROM
		#data.data.endurance#
	WHERE
		participantGUID = :pid
	AND
		stdywk <= :stdywk
	ORDER BY
		stdywk DESC, dayofwk DESC ) as pweek
ON pweek.p_participantGUID = cweek.participantGUID
