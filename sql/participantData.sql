SELECT * FROM
	( 
	SELECT * FROM 
		ac_mtr_bloodpressure_v2	
	WHERE 
		bp_pid = :pid 
	) as bpp 
	RIGHT JOIN
	( SELECT 
			participantGUID as _pid	
		 ,MthlyBPDia
		 ,mthlybpsys
		 ,d_visit
		 ,dayofwk
		 ,stdywk
		 ,weight
		 ,Hrworking
		 ,#iif(isEnd,DE('trgthr1'),DE('0'))# as hr1 
		 ,#iif(isEnd,DE('trgthr2'),DE('0'))# as hr2
		 ,#iif(isEnd,DE('mchntype'),DE('bodypart'))# as exerciseType 
	FROM 
		#iif(isEnd,DE('frm_EETL'),DE('frm_RETL'))# 
	WHERE 
		participantGUID = :pid
	AND 
		d_visit = :visit
	) as frmVal
ON bpp.bp_pid = frmVal._pid
