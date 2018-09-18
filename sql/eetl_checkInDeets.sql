SELECT * FROM
	( SELECT * FROM 
		ac_mtr_bloodpressure_v2	
	WHERE 
		bp_pid = :pid ) as bpp 
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
		 ,trgthr1 as hr1 
		 ,trgthr2 as hr2
		 ,mchntype as exerciseType 
	FROM 
		frm_eetl
	WHERE 
		participantGUID = :pid
	AND 
		d_visit = :visit
	) as frmVal
ON bpp.bp_pid = frmVal._pid
