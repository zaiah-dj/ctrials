SELECT 
	*
FROM
	( SELECT 
		 parttype 
		,prefix 
		,pname 
		,urlparam 
		,class 
		,:pid as pidd 
		FROM
		ac_mtr_frm_labels
	WHERE
		parttype = :pt 
	) As Labels
INNER JOIN
	( SELECT 
			fp_participantGUID
		, fp_step
		, fp_sessdayid 
	FROM
		ac_mtr_frm_progress
	WHERE	
		fp_participantGUID = :pid 
	) AS Progress
ON Labels.pidd = Progress.fp_participantGUID
