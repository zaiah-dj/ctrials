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
		 ,0 as hr1 
		 ,0 as hr2
		 ,bodypart as exerciseType 
	FROM 
		frm_retl
	WHERE 
		participantGUID = :pid
	AND 
		d_visit = :visit
	) as frmVal
ON bpp.bp_pid = frmVal._pid
