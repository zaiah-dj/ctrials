/*Pulls all endurance data from current and previous weeks*/
SELECT * FROM

	( 
	SELECT * FROM 
		frm_EETL	
	WHERE 
		participantGUID = :pid 
		AND stdywk = :stdywk
		AND dayofwk = :dayofwk
		AND recordthread = :rthrd
	) AS cweek

INNER JOIN

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
		,m10_exhr as p_m10_exhr
		,m10_exoth1 as p_m10_exoth1
		,m10_exoth2 as p_m10_exoth2
		,m10_exprctgrade as p_m10_exprctgrade
		,m10_exrpm as p_m10_exrpm
		,m10_exspeed as p_m10_exspeed
		,m10_exwatres as p_m10_exwatres
		,m15_exhr as p_m15_exhr
		,m15_exoth1 as p_m15_exoth1
		,m15_exoth2 as p_m15_exoth2
		,m15_exprctgrade as p_m15_exprctgrade
		,m15_exrpm as p_m15_exrpm
		,m15_exspeed as p_m15_exspeed
		,m15_exwatres as p_m15_exwatres
		,m20_exhr as p_m20_exhr
		,m20_exoth1 as p_m20_exoth1
		,m20_exoth2 as p_m20_exoth2
		,m20_exothafct as p_m20_exothafct
		,m20_exprctgrade as p_m20_exprctgrade
		,m20_exrpe as p_m20_exrpe
		,m20_exrpm as p_m20_exrpm
		,m20_exspeed as p_m20_exspeed
		,m20_exwatres as p_m20_exwatres
		,m25_exhr as p_m25_exhr
		,m25_exoth1 as p_m25_exoth1
		,m25_exoth2 as p_m25_exoth2
		,m25_exprctgrade as p_m25_exprctgrade
		,m25_exrpm as p_m25_exrpm
		,m25_exspeed as p_m25_exspeed
		,m25_exwatres as p_m25_exwatres
		,m30_exhr as p_m30_exhr
		,m30_exoth1 as p_m30_exoth1
		,m30_exoth2 as p_m30_exoth2
		,m30_exprctgrade as p_m30_exprctgrade
		,m30_exrpm as p_m30_exrpm
		,m30_exspeed as p_m30_exspeed
		,m30_exwatres as p_m30_exwatres
		,m35_exhr as p_m35_exhr
		,m35_exoth1 as p_m35_exoth1
		,m35_exoth2 as p_m35_exoth2
		,m35_exprctgrade as p_m35_exprctgrade
		,m35_exrpm as p_m35_exrpm
		,m35_exspeed as p_m35_exspeed
		,m35_exwatres as p_m35_exwatres
		,m40_exhr as p_m40_exhr
		,m40_exoth1 as p_m40_exoth1
		,m40_exoth2 as p_m40_exoth2
		,m40_exprctgrade as p_m40_exprctgrade
		,m40_exspeed as p_m40_exspeed
		,m40_exwatres as p_m40_exwatres
		,m40_exrpm as p_m40_exrpm
		,m45_exhr as p_m45_exhr
		,m45_exoth1 as p_m45_exoth1
		,m45_exoth2 as p_m45_exoth2
		,m45_exOthafct as p_m45_exOthafct
		,m45_exprctgrade as p_m45_exprctgrade
		,m45_exrpe as p_m45_exrpe
		,m45_exrpm as p_m45_exrpm
		,m45_exspeed as p_m45_exspeed
		,m45_exwatres as p_m45_exwatres
		,m5_exhr as p_m5_exhr
		,m5_exoth1 as p_m5_exoth1
		,m5_exoth2 as p_m5_exoth2
		,m5_exprctgrade as p_m5_exprctgrade
		,m5_exrpm as p_m5_exrpm
		,m5_exspeed as p_m5_exspeed
		,m5_exwatres as p_m5_exwatres
		,m3_rechr as p_m5_rechr
		,m3_recoth1 as p_m5_recoth1
		,m3_recoth2 as p_m5_recoth2
		,m3_recprctgrade as p_m5_recprctgrade
		,m3_recrpm as p_m5_recrpm
		,m3_recspeed as p_m5_recspeed
		,m3_recwatres as p_m5_recwatres
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
		stdywk <= :stdywk
	ORDER BY	
		stdywk DESC, dayofwk DESC ) as pweek
ON pweek.p_participantGUID = cweek.participantGUID
