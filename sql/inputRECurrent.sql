SELECT TOP (1) 
	 rec_id as c_rec_id
	,recordthread as c_recordthread
	,d_inserted as c_d_inserted
	,insertedBy as c_insertedBy
	,dayofwk as c_dayofwk
	,stdywk as c_stdywk
	,typedata as c_typedata
	,weight as c_weight
	,deleted as c_deleted
	,deleteReason as c_deleteReason
	,participantGUID as c_participantGUID
	,visitGUID as c_visitGUID
	,d_visit as c_d_visit
	,staffID as c_staffID
	,abdominalcrunch as c_abdominalcrunch
	,abdominalcrunchRep1 as c_abdominalcrunchRep1
	,abdominalcrunchRep2 as c_abdominalcrunchRep2
	,abdominalcrunchRep3 as c_abdominalcrunchRep3
	,abdominalcrunchWt1 as c_abdominalcrunchWt1
	,abdominalcrunchWt2 as c_abdominalcrunchWt2
	,abdominalcrunchWt3 as c_abdominalcrunchWt3
	,bicepcurl as c_bicepcurl
	,bicepcurlRep1 as c_bicepcurlRep1
	,bicepcurlRep2 as c_bicepcurlRep2
	,bicepcurlRep3 as c_bicepcurlRep3
	,bicepcurlWt1 as c_bicepcurlWt1
	,bicepcurlWt2 as c_bicepcurlWt2
	,bicepcurlWt3 as c_bicepcurlWt3
	,bodypart as c_bodypart
	,bodyweight as c_bodyweight
	,bp1set1 as c_bp1set1
	,bp1set2 as c_bp1set2
	,bp1set3 as c_bp1set3
	,bp2set1 as c_bp2set1
	,bp2set2 as c_bp2set2
	,bp2set3 as c_bp2set3
	,breaks as c_breaks
	,calfpress as c_calfpress
	,calfpressRep1 as c_calfpressRep1
	,calfpressRep2 as c_calfpressRep2
	,calfpressRep3 as c_calfpressRep3
	,calfpressWt1 as c_calfpressWt1
	,calfpressWt2 as c_calfpressWt2
	,calfpressWt3 as c_calfpressWt3
	,chest2 as c_chest2
	,chest2Rep1 as c_chest2Rep1
	,chest2Rep2 as c_chest2Rep2
	,chest2Rep3 as c_chest2Rep3
	,chest2Wt1 as c_chest2Wt1
	,chest2Wt2 as c_chest2Wt2
	,chest2Wt3 as c_chest2Wt3
	,chestpress as c_chestpress
	,chestpressRep1 as c_chestpressRep1
	,chestpressRep2 as c_chestpressRep2
	,chestpressRep3 as c_chestpressRep3
	,chestpressWt1 as c_chestpressWt1
	,chestpressWt2 as c_chestpressWt2
	,chestpressWt3 as c_chestpressWt3
	,dumbbellsquat as c_dumbbellsquat
	,dumbbellsquatRep1 as c_dumbbellsquatRep1
	,dumbbellsquatRep2 as c_dumbbellsquatRep2
	,dumbbellsquatRep3 as c_dumbbellsquatRep3
	,dumbbellsquatWt1 as c_dumbbellsquatWt1
	,dumbbellsquatWt2 as c_dumbbellsquatWt2
	,dumbbellsquatWt3 as c_dumbbellsquatWt3
	,Hrworking as c_Hrworking
	,kneeextension as c_kneeextension
	,kneeextensionRep1 as c_kneeextensionRep1
	,kneeextensionRep2 as c_kneeextensionRep2
	,kneeextensionRep3 as c_kneeextensionRep3
	,kneeextensionWt1 as c_kneeextensionWt1
	,kneeextensionWt2 as c_kneeextensionWt2
	,kneeextensionWt3 as c_kneeextensionWt3
	,legcurl as c_legcurl
	,legcurlRep1 as c_legcurlRep1
	,legcurlRep2 as c_legcurlRep2
	,legcurlRep3 as c_legcurlRep3
	,legcurlWt1 as c_legcurlWt1
	,legcurlWt2 as c_legcurlWt2
	,legcurlWt3 as c_legcurlWt3
	,legpress as c_legpress
	,legpressRep1 as c_legpressRep1
	,legpressRep2 as c_legpressRep2
	,legpressRep3 as c_legpressRep3
	,legpressWt1 as c_legpressWt1
	,legpressWt2 as c_legpressWt2
	,legpressWt3 as c_legpressWt3
	,MthlyBPDia as c_MthlyBPDia
	,mthlybpsys as c_mthlybpsys
	,nxtsesn_dt as c_nxtsesn_dt
	,othMchn1 as c_othMchn1
	,othMchn2 as c_othMchn2
	,overheadpress as c_overheadpress
	,overheadpressRep1 as c_overheadpressRep1
	,overheadpressRep2 as c_overheadpressRep2
	,overheadpressRep3 as c_overheadpressRep3
	,overheadpressWt1 as c_overheadpressWt1
	,overheadpressWt2 as c_overheadpressWt2
	,overheadpressWt3 as c_overheadpressWt3
	,pulldown as c_pulldown
	,pulldownRep1 as c_pulldownRep1
	,pulldownRep2 as c_pulldownRep2
	,pulldownRep3 as c_pulldownRep3
	,pulldownWt1 as c_pulldownWt1
	,pulldownWt2 as c_pulldownWt2
	,pulldownWt3 as c_pulldownWt3
	,reasnmisd as c_reasnmisd
	,recstrcomplete as c_recstrcomplete
	,seatedrow as c_seatedrow
	,seatedrowRep1 as c_seatedrowRep1
	,seatedrowRep2 as c_seatedrowRep2
	,seatedrowRep3 as c_seatedrowRep3
	,seatedrowWt1 as c_seatedrowWt1
	,seatedrowWt2 as c_seatedrowWt2
	,seatedrowWt3 as c_seatedrowWt3
	,Sessionmisd as c_Sessionmisd
	,shoulder2 as c_shoulder2
	,shoulder2Rep1 as c_shoulder2Rep1
	,shoulder2Rep2 as c_shoulder2Rep2
	,shoulder2Rep3 as c_shoulder2Rep3
	,shoulder2Wt1 as c_shoulder2Wt1
	,shoulder2Wt2 as c_shoulder2Wt2
	,shoulder2Wt3 as c_shoulder2Wt3
	,sp_reasnmisd as c_sp_reasnmisd
	,triceppress as c_triceppress
	,triceppressRep1 as c_triceppressRep1
	,triceppressRep2 as c_triceppressRep2
	,triceppressRep3 as c_triceppressRep3
	,triceppressWt1 as c_triceppressWt1
	,triceppressWt2 as c_triceppressWt2
	,triceppressWt3 as c_triceppressWt3
	,wrmup_hr as c_wrmup_hr
	,wrmup_oth1 as c_wrmup_oth1
	,wrmup_oth2 as c_wrmup_oth2
	,wrmup_prctgrade as c_wrmup_prctgrade
	,wrmup_rpm as c_wrmup_rpm
	,wrmup_speed as c_wrmup_speed
	,wrmup_watres as c_wrmup_watres
FROM
	frm_RETL	
WHERE
	participantGUID = :pid
AND
	stdywk = :stdywk
AND
	dayofwk = :dayofwk