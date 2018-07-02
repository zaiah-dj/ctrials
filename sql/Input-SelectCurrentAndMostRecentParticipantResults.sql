SELECT * FROM
	( SELECT * FROM
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
		,#private.designation#hr as p_#private.designation#hr
		,#private.designation#oth1 as p_#private.designation#oth1
		,#private.designation#oth2 as p_#private.designation#oth2
		,#private.designation#prctgrade as p_#private.designation#prctgrade
		,#private.designation#rpm as p_#private.designation#rpm
		,#private.designation#speed as p_#private.designation#speed
		,#private.designation#watres as p_#private.designation#watres
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
