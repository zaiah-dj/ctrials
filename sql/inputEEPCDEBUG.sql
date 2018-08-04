SELECT * FROM
	( SELECT TOP (1)
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
	,( CASE m10_exhr WHEN NULL THEN 0 ELSE m10_exhr END ) as p_m10_exhr
	,( CASE m10_exoth1 WHEN NULL THEN 0 ELSE m10_exoth1 END ) as p_m10_exoth1
	,( CASE m10_exoth2 WHEN NULL THEN 0 ELSE m10_exoth2 END ) as p_m10_exoth2
	,( CASE m10_exprctgrade WHEN NULL THEN 0 ELSE m10_exprctgrade END ) as p_m10_exprctgrade
	,( CASE m10_exrpm WHEN NULL THEN 0 ELSE m10_exrpm END ) as p_m10_exrpm
	,( CASE m10_exspeed WHEN NULL THEN 0 ELSE m10_exspeed END ) as p_m10_exspeed
	,( CASE m10_exwatres WHEN NULL THEN 0 ELSE m10_exwatres END ) as p_m10_exwatres
	,( CASE m15_exhr WHEN NULL THEN 0 ELSE m15_exhr END ) as p_m15_exhr
	,( CASE m15_exoth1 WHEN NULL THEN 0 ELSE m15_exoth1 END ) as p_m15_exoth1
	,( CASE m15_exoth2 WHEN NULL THEN 0 ELSE m15_exoth2 END ) as p_m15_exoth2
	,( CASE m15_exprctgrade WHEN NULL THEN 0 ELSE m15_exprctgrade END ) as p_m15_exprctgrade
	,( CASE m15_exrpm WHEN NULL THEN 0 ELSE m15_exrpm END ) as p_m15_exrpm
	,( CASE m15_exspeed WHEN NULL THEN 0 ELSE m15_exspeed END ) as p_m15_exspeed
	,( CASE m15_exwatres WHEN NULL THEN 0 ELSE m15_exwatres END ) as p_m15_exwatres
	,( CASE m20_exhr WHEN NULL THEN 0 ELSE m20_exhr END ) as p_m20_exhr
	,( CASE m20_exoth1 WHEN NULL THEN 0 ELSE m20_exoth1 END ) as p_m20_exoth1
	,( CASE m20_exoth2 WHEN NULL THEN 0 ELSE m20_exoth2 END ) as p_m20_exoth2
	,( CASE m20_exothafct WHEN NULL THEN 0 ELSE m20_exothafct END ) as p_m20_exothafct
	,( CASE m20_exprctgrade WHEN NULL THEN 0 ELSE m20_exprctgrade END ) as p_m20_exprctgrade
	,( CASE m20_exrpe WHEN NULL THEN 0 ELSE m20_exrpe END ) as p_m20_exrpe
	,( CASE m20_exrpm WHEN NULL THEN 0 ELSE m20_exrpm END ) as p_m20_exrpm
	,( CASE m20_exspeed WHEN NULL THEN 0 ELSE m20_exspeed END ) as p_m20_exspeed
	,( CASE m20_exwatres WHEN NULL THEN 0 ELSE m20_exwatres END ) as p_m20_exwatres
	,( CASE m25_exhr WHEN NULL THEN 0 ELSE m25_exhr END ) as p_m25_exhr
	,( CASE m25_exoth1 WHEN NULL THEN 0 ELSE m25_exoth1 END ) as p_m25_exoth1
	,( CASE m25_exoth2 WHEN NULL THEN 0 ELSE m25_exoth2 END ) as p_m25_exoth2
	,( CASE m25_exprctgrade WHEN NULL THEN 0 ELSE m25_exprctgrade END ) as p_m25_exprctgrade
	,( CASE m25_exrpm WHEN NULL THEN 0 ELSE m25_exrpm END ) as p_m25_exrpm
	,( CASE m25_exspeed WHEN NULL THEN 0 ELSE m25_exspeed END ) as p_m25_exspeed
	,( CASE m25_exwatres WHEN NULL THEN 0 ELSE m25_exwatres END ) as p_m25_exwatres
	,( CASE m30_exhr WHEN NULL THEN 0 ELSE m30_exhr END ) as p_m30_exhr
	,( CASE m30_exoth1 WHEN NULL THEN 0 ELSE m30_exoth1 END ) as p_m30_exoth1
	,( CASE m30_exoth2 WHEN NULL THEN 0 ELSE m30_exoth2 END ) as p_m30_exoth2
	,( CASE m30_exprctgrade WHEN NULL THEN 0 ELSE m30_exprctgrade END ) as p_m30_exprctgrade
	,( CASE m30_exrpm WHEN NULL THEN 0 ELSE m30_exrpm END ) as p_m30_exrpm
	,( CASE m30_exspeed WHEN NULL THEN 0 ELSE m30_exspeed END ) as p_m30_exspeed
	,( CASE m30_exwatres WHEN NULL THEN 0 ELSE m30_exwatres END ) as p_m30_exwatres
	,( CASE m35_exhr WHEN NULL THEN 0 ELSE m35_exhr END ) as p_m35_exhr
	,( CASE m35_exoth1 WHEN NULL THEN 0 ELSE m35_exoth1 END ) as p_m35_exoth1
	,( CASE m35_exoth2 WHEN NULL THEN 0 ELSE m35_exoth2 END ) as p_m35_exoth2
	,( CASE m35_exprctgrade WHEN NULL THEN 0 ELSE m35_exprctgrade END ) as p_m35_exprctgrade
	,( CASE m35_exrpm WHEN NULL THEN 0 ELSE m35_exrpm END ) as p_m35_exrpm
	,( CASE m35_exspeed WHEN NULL THEN 0 ELSE m35_exspeed END ) as p_m35_exspeed
	,( CASE m35_exwatres WHEN NULL THEN 0 ELSE m35_exwatres END ) as p_m35_exwatres
	,( CASE m40_exhr WHEN NULL THEN 0 ELSE m40_exhr END ) as p_m40_exhr
	,( CASE m40_exoth1 WHEN NULL THEN 0 ELSE m40_exoth1 END ) as p_m40_exoth1
	,( CASE m40_exoth2 WHEN NULL THEN 0 ELSE m40_exoth2 END ) as p_m40_exoth2
	,( CASE m40_exprctgrade WHEN NULL THEN 0 ELSE m40_exprctgrade END ) as p_m40_exprctgrade
	,( CASE m40_exspeed WHEN NULL THEN 0 ELSE m40_exspeed END ) as p_m40_exspeed
	,( CASE m40_exwatres WHEN NULL THEN 0 ELSE m40_exwatres END ) as p_m40_exwatres
	,( CASE m40_exrpm WHEN NULL THEN 0 ELSE m40_exrpm END ) as p_m40_exrpm
	,( CASE m45_exhr WHEN NULL THEN 0 ELSE m45_exhr END ) as p_m45_exhr
	,( CASE m45_exoth1 WHEN NULL THEN 0 ELSE m45_exoth1 END ) as p_m45_exoth1
	,( CASE m45_exoth2 WHEN NULL THEN 0 ELSE m45_exoth2 END ) as p_m45_exoth2
	,( CASE m45_exOthafct WHEN NULL THEN 0 ELSE m45_exOthafct END ) as p_m45_exOthafct
	,( CASE m45_exprctgrade WHEN NULL THEN 0 ELSE m45_exprctgrade END ) as p_m45_exprctgrade
	,( CASE m45_exrpe WHEN NULL THEN 0 ELSE m45_exrpe END ) as p_m45_exrpe
	,( CASE m45_exrpm WHEN NULL THEN 0 ELSE m45_exrpm END ) as p_m45_exrpm
	,( CASE m45_exspeed WHEN NULL THEN 0 ELSE m45_exspeed END ) as p_m45_exspeed
	,( CASE m45_exwatres WHEN NULL THEN 0 ELSE m45_exwatres END ) as p_m45_exwatres
	,( CASE m5_exhr WHEN NULL THEN 0 ELSE m5_exhr END ) as p_m5_exhr
	,( CASE m5_exoth1 WHEN NULL THEN 0 ELSE m5_exoth1 END ) as p_m5_exoth1
	,( CASE m5_exoth2 WHEN NULL THEN 0 ELSE m5_exoth2 END ) as p_m5_exoth2
	,( CASE m5_exprctgrade WHEN NULL THEN 0 ELSE m5_exprctgrade END ) as p_m5_exprctgrade
	,( CASE m5_exrpm WHEN NULL THEN 0 ELSE m5_exrpm END ) as p_m5_exrpm
	,( CASE m5_exspeed WHEN NULL THEN 0 ELSE m5_exspeed END ) as p_m5_exspeed
	,( CASE m5_exwatres WHEN NULL THEN 0 ELSE m5_exwatres END ) as p_m5_exwatres
	,( CASE m3_rechr WHEN NULL THEN 0 ELSE m3_rechr END ) as p_m5_rechr
	,( CASE m3_recoth1 WHEN NULL THEN 0 ELSE m3_recoth1 END ) as p_m5_recoth1
	,( CASE m3_recoth2 WHEN NULL THEN 0 ELSE m3_recoth2 END ) as p_m5_recoth2
	,( CASE m3_recprctgrade WHEN NULL THEN 0 ELSE m3_recprctgrade END ) as p_m5_recprctgrade
	,( CASE m3_recrpm WHEN NULL THEN 0 ELSE m3_recrpm END ) as p_m5_recrpm
	,( CASE m3_recspeed WHEN NULL THEN 0 ELSE m3_recspeed END ) as p_m5_recspeed
	,( CASE m3_recwatres WHEN NULL THEN 0 ELSE m3_recwatres END ) as p_m5_recwatres
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
	stdywk = :pstdywk
AND
	dayofwk = :pdayofwk ) as a
RIGHT JOIN
	( SELECT TOP (1)
	 rec_id as c_rec_id
	,recordthread as c_recordthread
	,d_inserted as c_d_inserted
	,insertedBy as c_insertedBy
	,deleted as c_deleted
	,deleteReason as c_deleteReason
	,participantGUID as c_participantGUID
	,visitGUID as c_visitGUID
	,d_visit as c_d_visit
	,staffID as c_staffID
	,dayofwk as c_dayofwk
	,stdywk as c_stdywk
	,weight as c_weight
	,Hrworking as c_Hrworking

	,( CASE m10_exhr WHEN NULL THEN 0 ELSE m10_exhr END ) AS c_m10_exhr
	,( CASE m10_exoth1 WHEN NULL THEN 0 ELSE m10_exoth1 END ) AS c_m10_exoth1
	,( CASE m10_exoth2 WHEN NULL THEN 0 ELSE m10_exoth2 END ) AS c_m10_exoth2
	,( CASE m10_exprctgrade WHEN NULL THEN 0 ELSE m10_exprctgrade END ) AS c_m10_exprctgrade
	,( CASE m10_exrpm WHEN NULL THEN 0 ELSE m10_exrpm END ) AS c_m10_exrpm
	,( CASE m10_exspeed WHEN NULL THEN 0 ELSE m10_exspeed END ) AS c_m10_exspeed
	,( CASE m10_exwatres WHEN NULL THEN 0 ELSE m10_exwatres END ) AS c_m10_exwatres
	,( CASE m15_exhr WHEN NULL THEN 0 ELSE m15_exhr END ) AS c_m15_exhr
	,( CASE m15_exoth1 WHEN NULL THEN 0 ELSE m15_exoth1 END ) AS c_m15_exoth1
	,( CASE m15_exoth2 WHEN NULL THEN 0 ELSE m15_exoth2 END ) AS c_m15_exoth2
	,( CASE m15_exprctgrade WHEN NULL THEN 0 ELSE m15_exprctgrade END ) AS c_m15_exprctgrade
	,( CASE m15_exrpm WHEN NULL THEN 0 ELSE m15_exrpm END ) AS c_m15_exrpm
	,( CASE m15_exspeed WHEN NULL THEN 0 ELSE m15_exspeed END ) AS c_m15_exspeed
	,( CASE m15_exwatres WHEN NULL THEN 0 ELSE m15_exwatres END ) AS c_m15_exwatres
	,( CASE m20_exhr WHEN NULL THEN 0 ELSE m20_exhr END ) AS c_m20_exhr
	,( CASE m20_exoth1 WHEN NULL THEN 0 ELSE m20_exoth1 END ) AS c_m20_exoth1
	,( CASE m20_exoth2 WHEN NULL THEN 0 ELSE m20_exoth2 END ) AS c_m20_exoth2
	,( CASE m20_exothafct WHEN NULL THEN 0 ELSE m20_exothafct END ) AS c_m20_exothafct
	,( CASE m20_exprctgrade WHEN NULL THEN 0 ELSE m20_exprctgrade END ) AS c_m20_exprctgrade
	,( CASE m20_exrpe WHEN NULL THEN 0 ELSE m20_exrpe END ) AS c_m20_exrpe
	,( CASE m20_exrpm WHEN NULL THEN 0 ELSE m20_exrpm END ) AS c_m20_exrpm
	,( CASE m20_exspeed WHEN NULL THEN 0 ELSE m20_exspeed END ) AS c_m20_exspeed
	,( CASE m20_exwatres WHEN NULL THEN 0 ELSE m20_exwatres END ) AS c_m20_exwatres
	,( CASE m25_exhr WHEN NULL THEN 0 ELSE m25_exhr END ) AS c_m25_exhr
	,( CASE m25_exoth1 WHEN NULL THEN 0 ELSE m25_exoth1 END ) AS c_m25_exoth1
	,( CASE m25_exoth2 WHEN NULL THEN 0 ELSE m25_exoth2 END ) AS c_m25_exoth2
	,( CASE m25_exprctgrade WHEN NULL THEN 0 ELSE m25_exprctgrade END ) AS c_m25_exprctgrade
	,( CASE m25_exrpm WHEN NULL THEN 0 ELSE m25_exrpm END ) AS c_m25_exrpm
	,( CASE m25_exspeed WHEN NULL THEN 0 ELSE m25_exspeed END ) AS c_m25_exspeed
	,( CASE m25_exwatres WHEN NULL THEN 0 ELSE m25_exwatres END ) AS c_m25_exwatres
	,( CASE m30_exhr WHEN NULL THEN 0 ELSE m30_exhr END ) AS c_m30_exhr
	,( CASE m30_exoth1 WHEN NULL THEN 0 ELSE m30_exoth1 END ) AS c_m30_exoth1
	,( CASE m30_exoth2 WHEN NULL THEN 0 ELSE m30_exoth2 END ) AS c_m30_exoth2
	,( CASE m30_exprctgrade WHEN NULL THEN 0 ELSE m30_exprctgrade END ) AS c_m30_exprctgrade
	,( CASE m30_exrpm WHEN NULL THEN 0 ELSE m30_exrpm END ) AS c_m30_exrpm
	,( CASE m30_exspeed WHEN NULL THEN 0 ELSE m30_exspeed END ) AS c_m30_exspeed
	,( CASE m30_exwatres WHEN NULL THEN 0 ELSE m30_exwatres END ) AS c_m30_exwatres
	,( CASE m35_exhr WHEN NULL THEN 0 ELSE m35_exhr END ) AS c_m35_exhr
	,( CASE m35_exoth1 WHEN NULL THEN 0 ELSE m35_exoth1 END ) AS c_m35_exoth1
	,( CASE m35_exoth2 WHEN NULL THEN 0 ELSE m35_exoth2 END ) AS c_m35_exoth2
	,( CASE m35_exprctgrade WHEN NULL THEN 0 ELSE m35_exprctgrade END ) AS c_m35_exprctgrade
	,( CASE m35_exrpm WHEN NULL THEN 0 ELSE m35_exrpm END ) AS c_m35_exrpm
	,( CASE m35_exspeed WHEN NULL THEN 0 ELSE m35_exspeed END ) AS c_m35_exspeed
	,( CASE m35_exwatres WHEN NULL THEN 0 ELSE m35_exwatres END ) AS c_m35_exwatres
	,( CASE m40_exhr WHEN NULL THEN 0 ELSE m40_exhr END ) AS c_m40_exhr
	,( CASE m40_exoth1 WHEN NULL THEN 0 ELSE m40_exoth1 END ) AS c_m40_exoth1
	,( CASE m40_exoth2 WHEN NULL THEN 0 ELSE m40_exoth2 END ) AS c_m40_exoth2
	,( CASE m40_exprctgrade WHEN NULL THEN 0 ELSE m40_exprctgrade END ) AS c_m40_exprctgrade
	,( CASE m40_exspeed WHEN NULL THEN 0 ELSE m40_exspeed END ) AS c_m40_exspeed
	,( CASE m40_exwatres WHEN NULL THEN 0 ELSE m40_exwatres END ) AS c_m40_exwatres
	,( CASE m40_exrpm WHEN NULL THEN 0 ELSE m40_exrpm END ) AS c_m40_exrpm
	,( CASE m45_exhr WHEN NULL THEN 0 ELSE m45_exhr END ) AS c_m45_exhr
	,( CASE m45_exoth1 WHEN NULL THEN 0 ELSE m45_exoth1 END ) AS c_m45_exoth1
	,( CASE m45_exoth2 WHEN NULL THEN 0 ELSE m45_exoth2 END ) AS c_m45_exoth2
	,( CASE m45_exOthafct WHEN NULL THEN 0 ELSE m45_exOthafct END ) AS c_m45_exOthafct
	,( CASE m45_exprctgrade WHEN NULL THEN 0 ELSE m45_exprctgrade END ) AS c_m45_exprctgrade
	,( CASE m45_exrpe WHEN NULL THEN 0 ELSE m45_exrpe END ) AS c_m45_exrpe
	,( CASE m45_exrpm WHEN NULL THEN 0 ELSE m45_exrpm END ) AS c_m45_exrpm
	,( CASE m45_exspeed WHEN NULL THEN 0 ELSE m45_exspeed END ) AS c_m45_exspeed
	,( CASE m45_exwatres WHEN NULL THEN 0 ELSE m45_exwatres END ) AS c_m45_exwatres
	,( CASE m5_exhr WHEN NULL THEN 0 ELSE m5_exhr END ) AS c_m5_exhr
	,( CASE m5_exoth1 WHEN NULL THEN 0 ELSE m5_exoth1 END ) AS c_m5_exoth1
	,( CASE m5_exoth2 WHEN NULL THEN 0 ELSE m5_exoth2 END ) AS c_m5_exoth2
	,( CASE m5_exprctgrade WHEN NULL THEN 0 ELSE m5_exprctgrade END ) AS c_m5_exprctgrade
	,( CASE m5_exrpm WHEN NULL THEN 0 ELSE m5_exrpm END ) AS c_m5_exrpm
	,( CASE m5_exspeed WHEN NULL THEN 0 ELSE m5_exspeed END ) AS c_m5_exspeed
	,( CASE m5_exwatres WHEN NULL THEN 0 ELSE m5_exwatres END ) AS c_m5_exwatres
	,( CASE m3_rechr WHEN NULL THEN 0 ELSE m3_rechr END ) AS c_m5_rechr
	,( CASE m3_recoth1 WHEN NULL THEN 0 ELSE m3_recoth1 END ) AS c_m5_recoth1
	,( CASE m3_recoth2 WHEN NULL THEN 0 ELSE m3_recoth2 END ) AS c_m5_recoth2
	,( CASE m3_recprctgrade WHEN NULL THEN 0 ELSE m3_recprctgrade END ) AS c_m5_recprctgrade
	,( CASE m3_recrpm WHEN NULL THEN 0 ELSE m3_recrpm END ) AS c_m5_recrpm
	,( CASE m3_recspeed WHEN NULL THEN 0 ELSE m3_recspeed END ) AS c_m5_recspeed
	,( CASE m3_recwatres WHEN NULL THEN 0 ELSE m3_recwatres END ) AS c_m5_recwatres

	,mchntype as c_mchntype
	,MthlyBPDia as c_MthlyBPDia
	,MthlyBPSys as c_MthlyBPSys
	,nomchntype as c_nomchntype
	,nxtsesn_dt as c_nxtsesn_dt
	,othMchn1 as c_othMchn1
	,othMchn2 as c_othMchn2
	,reasnmisd as c_reasnmisd
	,Sessionmisd as c_Sessionmisd
	,Sp_mchntype as c_Sp_mchntype
	,sp_reasnmisd as c_sp_reasnmisd
	,trgthr1 as c_trgthr1
	,trgthr2 as c_trgthr2
	,typedata as c_typedata
	,wrmup_hr as c_wrmup_hr
	,wrmup_oth1 as c_wrmup_oth1
	,wrmup_oth2 as c_wrmup_oth2
	,wrmup_othafct as c_wrmup_othafct
	,wrmup_prctgrade as c_wrmup_prctgrade
	,wrmup_rpe as c_wrmup_rpe
	,wrmup_rpm as c_wrmup_rpm
	,wrmup_speed as c_wrmup_speed
	,wrmup_watres as c_wrmup_watres
	,breaks as c_breaks
FROM 
	ac_mtr_endurance_new	
WHERE 
	participantGUID = :pid
AND 
	stdywk = :stdywk
AND 
	dayofwk = :dayofwk ) as b

ON a.p_participantGUID = b.c_participantGUID
