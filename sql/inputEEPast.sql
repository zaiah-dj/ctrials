SELECT TOP (1)
	 rec_id as p_rec_id
	,recordthread as p_recordthread
	,d_inserted as p_d_inserted
	,insertedBy as p_insertedBy
	,deleted as p_deleted
	,deleteReason as p_deleteReason
	,participantGUID as p_participantGUID
	,visitGUID as p_visitGUID
	,d_visit as p_d_visit
	,staffID as p_staffID
	,dayofwk as p_dayofwk
	,stdywk as p_stdywk
	,weight as p_weight
	,Hrworking as p_Hrworking
	,( CASE m10_exhr WHEN '' THEN 0 ELSE m10_exhr END ) as p_m10_exhr
	,( CASE m10_exoth1 WHEN '' THEN 0 ELSE m10_exoth1 END ) as p_m10_exoth1
	,( CASE m10_exoth2 WHEN '' THEN 0 ELSE m10_exoth2 END ) as p_m10_exoth2
	,( CASE m10_exprctgrade WHEN '' THEN 0 ELSE m10_exprctgrade END ) as p_m10_exprctgrade
	,( CASE m10_exrpm WHEN '' THEN 0 ELSE m10_exrpm END ) as p_m10_exrpm
	,( CASE m10_exspeed WHEN '' THEN 0 ELSE m10_exspeed END ) as p_m10_exspeed
	,( CASE m10_exwatres WHEN '' THEN 0 ELSE m10_exwatres END ) as p_m10_exwatres
	,( CASE m15_exhr WHEN '' THEN 0 ELSE m15_exhr END ) as p_m15_exhr
	,( CASE m15_exoth1 WHEN '' THEN 0 ELSE m15_exoth1 END ) as p_m15_exoth1
	,( CASE m15_exoth2 WHEN '' THEN 0 ELSE m15_exoth2 END ) as p_m15_exoth2
	,( CASE m15_exprctgrade WHEN '' THEN 0 ELSE m15_exprctgrade END ) as p_m15_exprctgrade
	,( CASE m15_exrpm WHEN '' THEN 0 ELSE m15_exrpm END ) as p_m15_exrpm
	,( CASE m15_exspeed WHEN '' THEN 0 ELSE m15_exspeed END ) as p_m15_exspeed
	,( CASE m15_exwatres WHEN '' THEN 0 ELSE m15_exwatres END ) as p_m15_exwatres
	,( CASE m20_exhr WHEN '' THEN 0 ELSE m20_exhr END ) as p_m20_exhr
	,( CASE m20_exoth1 WHEN '' THEN 0 ELSE m20_exoth1 END ) as p_m20_exoth1
	,( CASE m20_exoth2 WHEN '' THEN 0 ELSE m20_exoth2 END ) as p_m20_exoth2
	,( CASE m20_exothafct WHEN '' THEN 0 ELSE m20_exothafct END ) as p_m20_exothafct
	,( CASE m20_exprctgrade WHEN '' THEN 0 ELSE m20_exprctgrade END ) as p_m20_exprctgrade
	,( CASE m20_exrpe WHEN '' THEN 0 ELSE m20_exrpe END ) as p_m20_exrpe
	,( CASE m20_exrpm WHEN '' THEN 0 ELSE m20_exrpm END ) as p_m20_exrpm
	,( CASE m20_exspeed WHEN '' THEN 0 ELSE m20_exspeed END ) as p_m20_exspeed
	,( CASE m20_exwatres WHEN '' THEN 0 ELSE m20_exwatres END ) as p_m20_exwatres
	,( CASE m25_exhr WHEN '' THEN 0 ELSE m25_exhr END ) as p_m25_exhr
	,( CASE m25_exoth1 WHEN '' THEN 0 ELSE m25_exoth1 END ) as p_m25_exoth1
	,( CASE m25_exoth2 WHEN '' THEN 0 ELSE m25_exoth2 END ) as p_m25_exoth2
	,( CASE m25_exprctgrade WHEN '' THEN 0 ELSE m25_exprctgrade END ) as p_m25_exprctgrade
	,( CASE m25_exrpm WHEN '' THEN 0 ELSE m25_exrpm END ) as p_m25_exrpm
	,( CASE m25_exspeed WHEN '' THEN 0 ELSE m25_exspeed END ) as p_m25_exspeed
	,( CASE m25_exwatres WHEN '' THEN 0 ELSE m25_exwatres END ) as p_m25_exwatres
	,( CASE m30_exhr WHEN '' THEN 0 ELSE m30_exhr END ) as p_m30_exhr
	,( CASE m30_exoth1 WHEN '' THEN 0 ELSE m30_exoth1 END ) as p_m30_exoth1
	,( CASE m30_exoth2 WHEN '' THEN 0 ELSE m30_exoth2 END ) as p_m30_exoth2
	,( CASE m30_exprctgrade WHEN '' THEN 0 ELSE m30_exprctgrade END ) as p_m30_exprctgrade
	,( CASE m30_exrpm WHEN '' THEN 0 ELSE m30_exrpm END ) as p_m30_exrpm
	,( CASE m30_exspeed WHEN '' THEN 0 ELSE m30_exspeed END ) as p_m30_exspeed
	,( CASE m30_exwatres WHEN '' THEN 0 ELSE m30_exwatres END ) as p_m30_exwatres
	,( CASE m35_exhr WHEN '' THEN 0 ELSE m35_exhr END ) as p_m35_exhr
	,( CASE m35_exoth1 WHEN '' THEN 0 ELSE m35_exoth1 END ) as p_m35_exoth1
	,( CASE m35_exoth2 WHEN '' THEN 0 ELSE m35_exoth2 END ) as p_m35_exoth2
	,( CASE m35_exprctgrade WHEN '' THEN 0 ELSE m35_exprctgrade END ) as p_m35_exprctgrade
	,( CASE m35_exrpm WHEN '' THEN 0 ELSE m35_exrpm END ) as p_m35_exrpm
	,( CASE m35_exspeed WHEN '' THEN 0 ELSE m35_exspeed END ) as p_m35_exspeed
	,( CASE m35_exwatres WHEN '' THEN 0 ELSE m35_exwatres END ) as p_m35_exwatres
	,( CASE m40_exhr WHEN '' THEN 0 ELSE m40_exhr END ) as p_m40_exhr
	,( CASE m40_exoth1 WHEN '' THEN 0 ELSE m40_exoth1 END ) as p_m40_exoth1
	,( CASE m40_exoth2 WHEN '' THEN 0 ELSE m40_exoth2 END ) as p_m40_exoth2
	,( CASE m40_exprctgrade WHEN '' THEN 0 ELSE m40_exprctgrade END ) as p_m40_exprctgrade
	,( CASE m40_exspeed WHEN '' THEN 0 ELSE m40_exspeed END ) as p_m40_exspeed
	,( CASE m40_exwatres WHEN '' THEN 0 ELSE m40_exwatres END ) as p_m40_exwatres
	,( CASE m40_exrpm WHEN '' THEN 0 ELSE m40_exrpm END ) as p_m40_exrpm
	,( CASE m45_exhr WHEN '' THEN 0 ELSE m45_exhr END ) as p_m45_exhr
	,( CASE m45_exoth1 WHEN '' THEN 0 ELSE m45_exoth1 END ) as p_m45_exoth1
	,( CASE m45_exoth2 WHEN '' THEN 0 ELSE m45_exoth2 END ) as p_m45_exoth2
	,( CASE m45_exOthafct WHEN '' THEN 0 ELSE m45_exOthafct END ) as p_m45_exOthafct
	,( CASE m45_exprctgrade WHEN '' THEN 0 ELSE m45_exprctgrade END ) as p_m45_exprctgrade
	,( CASE m45_exrpe WHEN '' THEN 0 ELSE m45_exrpe END ) as p_m45_exrpe
	,( CASE m45_exrpm WHEN '' THEN 0 ELSE m45_exrpm END ) as p_m45_exrpm
	,( CASE m45_exspeed WHEN '' THEN 0 ELSE m45_exspeed END ) as p_m45_exspeed
	,( CASE m45_exwatres WHEN '' THEN 0 ELSE m45_exwatres END ) as p_m45_exwatres
	,( CASE m5_exhr WHEN '' THEN 0 ELSE m5_exhr END ) as p_m5_exhr
	,( CASE m5_exoth1 WHEN '' THEN 0 ELSE m5_exoth1 END ) as p_m5_exoth1
	,( CASE m5_exoth2 WHEN '' THEN 0 ELSE m5_exoth2 END ) as p_m5_exoth2
	,( CASE m5_exprctgrade WHEN '' THEN 0 ELSE m5_exprctgrade END ) as p_m5_exprctgrade
	,( CASE m5_exrpm WHEN '' THEN 0 ELSE m5_exrpm END ) as p_m5_exrpm
	,( CASE m5_exspeed WHEN '' THEN 0 ELSE m5_exspeed END ) as p_m5_exspeed
	,( CASE m5_exwatres WHEN '' THEN 0 ELSE m5_exwatres END ) as p_m5_exwatres
	,( CASE m3_rechr WHEN '' THEN 0 ELSE m3_rechr END ) as p_m5_rechr
	,( CASE m3_recoth1 WHEN '' THEN 0 ELSE m3_recoth1 END ) as p_m5_recoth1
	,( CASE m3_recoth2 WHEN '' THEN 0 ELSE m3_recoth2 END ) as p_m5_recoth2
	,( CASE m3_recprctgrade WHEN '' THEN 0 ELSE m3_recprctgrade END ) as p_m5_recprctgrade
	,( CASE m3_recrpm WHEN '' THEN 0 ELSE m3_recrpm END ) as p_m5_recrpm
	,( CASE m3_recspeed WHEN '' THEN 0 ELSE m3_recspeed END ) as p_m5_recspeed
	,( CASE m3_recwatres WHEN '' THEN 0 ELSE m3_recwatres END ) as p_m5_recwatres
	,mchntype as p_mchntype
	,MthlyBPDia as p_MthlyBPDia
	,MthlyBPSys as p_MthlyBPSys
	,nomchntype as p_nomchntype
	,nxtsesn_dt as p_nxtsesn_dt
	,othMchn1 as p_othMchn1
	,othMchn2 as p_othMchn2
	,reasnmisd as p_reasnmisd
	,Sessionmisd as p_Sessionmisd
	,Sp_mchntype as p_Sp_mchntype
	,sp_reasnmisd as p_sp_reasnmisd
	,trgthr1 as p_trgthr1
	,trgthr2 as p_trgthr2
	,typedata as p_typedata
	,wrmup_hr as p_wrmup_hr
	,wrmup_oth1 as p_wrmup_oth1
	,wrmup_oth2 as p_wrmup_oth2
	,wrmup_othafct as p_wrmup_othafct
	,wrmup_prctgrade as p_wrmup_prctgrade
	,wrmup_rpe as p_wrmup_rpe
	,wrmup_rpm as p_wrmup_rpm
	,wrmup_speed as p_wrmup_speed
	,wrmup_watres as p_wrmup_watres
	,breaks as p_breaks
FROM 
	frm_EETL	
WHERE 
	participantGUID = :pid
AND 
	stdywk = :stdywk
AND
	dayofwk = :dayofwk
