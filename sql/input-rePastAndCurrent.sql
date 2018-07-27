/*Pulls all resistance data from current and previous weeks*/
SELECT * FROM

	( 
	SELECT * FROM 
		frm_RETL	
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
		,d_inserted as p_d_inserted
		,insertedBy as p_insertedBy
		,dayofwk as p_dayofwk
		,stdywk as p_stdywk
		,typedata as p_typedata
		,weight as p_weight
		,deleted as p_deleted
		,deleteReason as p_deleteReason
		,participantGUID as p_participantGUID
		,visitGUID as p_visitGUID
		,d_visit as p_d_visit
		,staffID as p_staffID
		,abdominalcrunch as p_abdominalcrunch
		,abdominalcrunchRep1 as p_abdominalcrunchRep1
		,abdominalcrunchRep2 as p_abdominalcrunchRep2
		,abdominalcrunchRep3 as p_abdominalcrunchRep3
		,abdominalcrunchWt1 as p_abdominalcrunchWt1
		,abdominalcrunchWt2 as p_abdominalcrunchWt2
		,abdominalcrunchWt3 as p_abdominalcrunchWt3
		,bicepcurl as p_bicepcurl
		,bicepcurlRep1 as p_bicepcurlRep1
		,bicepcurlRep2 as p_bicepcurlRep2
		,bicepcurlRep3 as p_bicepcurlRep3
		,bicepcurlWt1 as p_bicepcurlWt1
		,bicepcurlWt2 as p_bicepcurlWt2
		,bicepcurlWt3 as p_bicepcurlWt3
		,bodypart as p_bodypart
		,bodyweight as p_bodyweight
		,bp1set1 as p_bp1set1
		,bp1set2 as p_bp1set2
		,bp1set3 as p_bp1set3
		,bp2set1 as p_bp2set1
		,bp2set2 as p_bp2set2
		,bp2set3 as p_bp2set3
		,breaks as p_breaks
		,calfpress as p_calfpress
		,calfpressRep1 as p_calfpressRep1
		,calfpressRep2 as p_calfpressRep2
		,calfpressRep3 as p_calfpressRep3
		,calfpressWt1 as p_calfpressWt1
		,calfpressWt2 as p_calfpressWt2
		,calfpressWt3 as p_calfpressWt3
		,chest2 as p_chest2
		,chest2Rep1 as p_chest2Rep1
		,chest2Rep2 as p_chest2Rep2
		,chest2Rep3 as p_chest2Rep3
		,chest2Wt1 as p_chest2Wt1
		,chest2Wt2 as p_chest2Wt2
		,chest2Wt3 as p_chest2Wt3
		,chestpress as p_chestpress
		,chestpressRep1 as p_chestpressRep1
		,chestpressRep2 as p_chestpressRep2
		,chestpressRep3 as p_chestpressRep3
		,chestpressWt1 as p_chestpressWt1
		,chestpressWt2 as p_chestpressWt2
		,chestpressWt3 as p_chestpressWt3
		,dumbbellsquat as p_dumbbellsquat
		,dumbbellsquatRep1 as p_dumbbellsquatRep1
		,dumbbellsquatRep2 as p_dumbbellsquatRep2
		,dumbbellsquatRep3 as p_dumbbellsquatRep3
		,dumbbellsquatWt1 as p_dumbbellsquatWt1
		,dumbbellsquatWt2 as p_dumbbellsquatWt2
		,dumbbellsquatWt3 as p_dumbbellsquatWt3
		,Hrworking as p_Hrworking
		,kneeextension as p_kneeextension
		,kneeextensionRep1 as p_kneeextensionRep1
		,kneeextensionRep2 as p_kneeextensionRep2
		,kneeextensionRep3 as p_kneeextensionRep3
		,kneeextensionWt1 as p_kneeextensionWt1
		,kneeextensionWt2 as p_kneeextensionWt2
		,kneeextensionWt3 as p_kneeextensionWt3
		,legcurl as p_legcurl
		,legcurlRep1 as p_legcurlRep1
		,legcurlRep2 as p_legcurlRep2
		,legcurlRep3 as p_legcurlRep3
		,legcurlWt1 as p_legcurlWt1
		,legcurlWt2 as p_legcurlWt2
		,legcurlWt3 as p_legcurlWt3
		,legpress as p_legpress
		,legpressRep1 as p_legpressRep1
		,legpressRep2 as p_legpressRep2
		,legpressRep3 as p_legpressRep3
		,legpressWt1 as p_legpressWt1
		,legpressWt2 as p_legpressWt2
		,legpressWt3 as p_legpressWt3
		,MthlyBPDia as p_MthlyBPDia
		,mthlybpsys as p_mthlybpsys
		,nxtsesn_dt as p_nxtsesn_dt
		,othMchn1 as p_othMchn1
		,othMchn2 as p_othMchn2
		,overheadpress as p_overheadpress
		,overheadpressRep1 as p_overheadpressRep1
		,overheadpressRep2 as p_overheadpressRep2
		,overheadpressRep3 as p_overheadpressRep3
		,overheadpressWt1 as p_overheadpressWt1
		,overheadpressWt2 as p_overheadpressWt2
		,overheadpressWt3 as p_overheadpressWt3
		,pulldown as p_pulldown
		,pulldownRep1 as p_pulldownRep1
		,pulldownRep2 as p_pulldownRep2
		,pulldownRep3 as p_pulldownRep3
		,pulldownWt1 as p_pulldownWt1
		,pulldownWt2 as p_pulldownWt2
		,pulldownWt3 as p_pulldownWt3
		,reasnmisd as p_reasnmisd
		,recstrcomplete as p_recstrcomplete
		,seatedrow as p_seatedrow
		,seatedrowRep1 as p_seatedrowRep1
		,seatedrowRep2 as p_seatedrowRep2
		,seatedrowRep3 as p_seatedrowRep3
		,seatedrowWt1 as p_seatedrowWt1
		,seatedrowWt2 as p_seatedrowWt2
		,seatedrowWt3 as p_seatedrowWt3
		,Sessionmisd as p_Sessionmisd
		,shoulder2 as p_shoulder2
		,shoulder2Rep1 as p_shoulder2Rep1
		,shoulder2Rep2 as p_shoulder2Rep2
		,shoulder2Rep3 as p_shoulder2Rep3
		,shoulder2Wt1 as p_shoulder2Wt1
		,shoulder2Wt2 as p_shoulder2Wt2
		,shoulder2Wt3 as p_shoulder2Wt3
		,sp_reasnmisd as p_sp_reasnmisd
		,triceppress as p_triceppress
		,triceppressRep1 as p_triceppressRep1
		,triceppressRep2 as p_triceppressRep2
		,triceppressRep3 as p_triceppressRep3
		,triceppressWt1 as p_triceppressWt1
		,triceppressWt2 as p_triceppressWt2
		,triceppressWt3 as p_triceppressWt3
		,wrmup_hr as p_wrmup_hr
		,wrmup_oth1 as p_wrmup_oth1
		,wrmup_oth2 as p_wrmup_oth2
		,wrmup_prctgrade as p_wrmup_prctgrade
		,wrmup_rpm as p_wrmup_rpm
		,wrmup_speed as p_wrmup_speed
		,wrmup_watres as p_wrmup_watres
	FROM
		frm_RETL	
	WHERE
		participantGUID = :pid
	AND
		stdywk <= :stdywk
	ORDER BY
		stdywk DESC, dayofwk DESC ) as pweek
ON pweek.p_participantGUID = cweek.participantGUID



