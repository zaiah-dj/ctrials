/* -------------------------------
INTERVENTION TRACKING TABLES

SQL tables to run a local instance of
the intervention tracking application.

Running this file will allow one to
run the motrpac intervention interface
from a local setup.

NOTE: Only works with SQL server.
 ------------------------------- */
IF db_id( 'zProgrammer_AntonioCollins' ) IS NULL
BEGIN
	CREATE DATABASE zProgrammer_AntonioCollins;
END
GO
/* -------------------------------
 PRODUCTION SCHEMA for DEVELOPMENT ONLY
 ------------------------------- */
/*CREATE DATABASE localmotrpac;
>>>>>>> 56767cac180fc28edaaa47e78e7b8085ac9ac3d6
GO

USE localmotrpac;
GO*/

USE zProgrammer_AntonioCollins;
GO

DECLARE @BUILD_EQUIPMENT_LOG integer;
SET @BUILD_EQUIPMENT_LOG = 1;

/*
----------------------------------
ac_mtr_serverlog

The entire app logs here, AJAX updates will go 
here as well:

 sl_id INT IDENTITY(1,1) NOT NULL - unique ID
,sl_method VARCHAR(10)            - GET, POST, etc.
,sl_ip VARCHAR(128)               - IP Address making request
,sl_dateofrequest DATETIME        - Date request made
,sl_status INT                    - Status of request
,sl_contentsize INT               - How big was response?
,sl_pagerequested VARCHAR(2048)   - What was asked for?
,sl_useragent VARCHAR(512)        - Which user agent?
,sl_message VARCHAR(MAX)          - Custom message (AJAX here)
----------------------------------
 */
IF OBJECT_ID( N'ac_mtr_serverlog', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_serverlog;
END
CREATE TABLE ac_mtr_serverlog
(
	 sl_id INT IDENTITY(1,1) NOT NULL
	,sl_session_id VARCHAR(64)
	,sl_method VARCHAR(10)
	,sl_ip VARCHAR(128)
	,sl_pagerequested VARCHAR(2048)
	,sl_useragent VARCHAR(512)
	,sl_message VARCHAR(MAX)
);



/*
 ----------------------------
ac_mtr_checkinstatus_v3

What condition is the patient
in during the visit?

 ps_id INT IDENTITY(1,1) NOT NULL - Unique ID
,ps_pid VARCHAR(64)               - Partiicipant GUID
,ps_session_id VARCHAR(64)        - The session ID that this participant was tested during.
,ps_week int                      - Week in question
,ps_day int                       - Day of testing
,ps_next_sched datetime           - (not used)
,ps_weight int                    - Weight of participant at check-in time
,ps_reex_type int                 - (not used)
,ps_date_time_assessed datetime   - Date assessed
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_checkinstatus_v2', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_checkinstatus_v2;
END
CREATE TABLE ac_mtr_checkinstatus_v2 (	
	 ps_id INT IDENTITY(1,1) NOT NULL
	,ps_pid VARCHAR(64)
	,ps_session_id VARCHAR(64)
	,ps_week int
	,ps_day int
	,ps_next_sched datetime
	,ps_weight int
	,ps_reex_type int
	,ps_date_time_assessed datetime
);


/*
 ----------------------------
ac_mtr_bloodpressure_v3

Get the blood pressure of a 
participant if needed.

 bp_id INT IDENTITY(1,1) NOT NULL - Unique ID
,bp_pid VARCHAR(64)               - GUID of participant
,bp_systolic int                  - Systolic at date
,bp_diastolic int                 - Diastolic at date
,bp_daterecorded DATETIME         - Date
,bp_notes varchar(max)            - Notes?
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_bloodpressure_v2', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_bloodpressure_v2;
END
CREATE TABLE ac_mtr_bloodpressure_v2 (
	 bp_id INT IDENTITY(1,1) NOT NULL
	,bp_pid VARCHAR(64)
	,bp_systolic int
	,bp_diastolic int
	,bp_daterecorded DATETIME
	,bp_notes varchar(max)
);



/* ---------------------------
v_ADUSessionTickler

Participant data table in lieu
of a session tickler or some 
other data source.

 p_id int IDENTITY(1 - 1) NOT NULL       - 
,participantGUID varchar(50) NOT NULL    - 
,pid int NOT NULL                        - 
,firstname varchar(256) NULL             - 
,lastname varchar(256) NULL              - 
,middlename varchar(256) NULL            -  
,acrostic int NULL                       -  
,randomGroupGUID varchar(50) NULL        - 
,randomGroupCode varchar(50) NULL        - 
,randomGroupDescription varchar(50) NULL - 
,siteID int NULL                         - 
,siteName varchar(256) NULL              - 
,siteGUID varchar(256) NULL              - 
,d_session datetime NULL                 - ?
 ---------------------------- */
IF OBJECT_ID( N'v_ADUSessionTickler', N'U') IS NOT NULL
BEGIN
	DROP TABLE v_ADUSessionTickler;
END
CREATE TABLE v_ADUSessionTickler (
	[p_id] [int] IDENTITY(1,1) NOT NULL,
	[participantGUID] [varchar](50) NOT NULL,
	[pid] [int] NOT NULL,
	[firstname] [varchar](256) NULL,
	[lastname] [varchar](256) NULL,
	[middlename] [varchar](256) NULL,
	[acrostic] [int] NULL,
	[randomGroupGUID] [varchar](50) NULL,
	[randomGroupCode] [varchar](50) NULL,
	[randomGroupDescription] [varchar](50) NULL,
	[siteID] [int] NULL,
	[siteName] [varchar](256) NULL,
	[siteGUID] [varchar](256) NULL,
	[d_session] [datetime] NULL
); 


/* ---------------------------
ac_mtr_frm_progress

A table for endurance data
that can be shared by other apps.
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_frm_progress', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_frm_progress;
END
CREATE TABLE ac_mtr_frm_progress (
	 fp_step int NULL
	,fp_participantGUID varchar(50) NOT NULL
	,fp_sessdayid DATETIME NOT NULL
);


/* ---------------------------
frm_EETL

A table for endurance data
that can be shared by other apps.
 ---------------------------- */
IF OBJECT_ID( N'frm_EETL', N'U') IS NOT NULL
BEGIN
	DROP TABLE frm_EETL;
END
CREATE TABLE frm_EETL (
	[rec_id]           int IDENTITY(1,1) NOT NULL,
	[recordthread]     varchar(50) NOT NULL DEFAULT (newid()),
	[d_inserted]       datetime NOT NULL DEFAULT (getdate()),
	[insertedBy]       varchar(50) NOT NULL,
	[deleted]          int NULL,
	[deleteReason]     varchar(max) NULL,
	[participantGUID]  varchar(50) NULL,
	[visitGUID]        varchar(50) NULL,
	[d_visit]          date NULL,
	[staffID]          varchar(10) NULL,
	[dayofwk]          int NULL,
	[stdywk]           int NULL,
	[weight]           numeric(18,0) NULL,
	[Hrworking]        int NULL,
	
	[m10_exhr]         int NULL,
	[m10_exoth1]       int NULL,
	[m10_exoth2]       int NULL,
	[m10_exprctgrade]  numeric(18,0) NULL,
	[m10_exrpm]        int NULL,
	[m10_exspeed]      numeric(18,0) NULL,
	[m10_exwatres]     int NULL,
	
	[m15_exhr]         int NULL,
	[m15_exoth1]       int NULL,
	[m15_exoth2]       int NULL,
	[m15_exprctgrade]  numeric(18,0) NULL,
	[m15_exrpm]        int NULL,
	[m15_exspeed]      numeric(18,0) NULL,
	[m15_exwatres]     int NULL,
	
	[m20_exhr]         int NULL,
	[m20_exoth1]       int NULL,
	[m20_exoth2]       int NULL,
	[m20_exOthafct]    int NULL,
	[m20_exprctgrade]  numeric(18,0) NULL,
	[m20_exrpe]        int NULL,
	[m20_exrpm]        int NULL,
	[m20_exspeed]      numeric(18,0) NULL,
	[m20_exwatres]     int NULL,
	
	[m25_exhr]         int NULL,
	[m25_exoth1]       int NULL,
	[m25_exoth2]       int NULL,
	[m25_exprctgrade]  numeric(18,0) NULL,
	[m25_exrpm]        int NULL,
	[m25_exspeed]      numeric(18,0) NULL,
	[m25_exwatres]     int NULL,
	[m30_exhr]         int NULL,
	[m30_exoth1]       int NULL,
	[m30_exoth2]       int NULL,
	[m30_exprctgrade]  numeric(18,0) NULL,
	[m30_exrpm]        int NULL,
	[m30_exspeed]      numeric(18,0) NULL,
	[m30_exwatres]     int NULL,
	[m35_exhr]         int NULL,
	[m35_exoth1]       int NULL,
	[m35_exoth2]       int NULL,
	[m35_exprctgrade]  numeric(18,0) NULL,
	[m35_exrpm]        int NULL,
	[m35_exspeed]      numeric(18,0) NULL,
	[m35_exwatres]     int NULL,
	[m40_exhr]         int NULL,
	[m40_exoth1]       int NULL,
	[m40_exoth2]       int NULL,
	[m40_exprctgrade]  numeric(18,0) NULL,
	[m40_exspeed]      numeric(18,0) NULL,
	[m40_exwatres]     int NULL,
	[m40_exrpm]        int NULL,
	[m45_exhr]         int NULL,
	[m45_exoth1]       int NULL,
	[m45_exoth2]       int NULL,
	[m45_exOthafct]    int NULL,
	[m45_exprctgrade]  numeric(18,0) NULL,
	[m45_exrpe]        int NULL,
	[m45_exrpm]        int NULL,
	[m45_exspeed]      numeric(18,0) NULL,
	[m45_exwatres]     int NULL,
	
	[m5_exhr]          int NULL,
	[m5_exoth1]        int NULL,
	[m5_exoth2]        int NULL,
	[m5_exprctgrade]   numeric(18,0) NULL,
	[m5_exrpm]         int NULL,
	[m5_exspeed]       numeric(18,0) NULL,
	[m5_exwatres]      int NULL,
	
	/*Recovery column*/
	[m3_rechr]         int NULL,
	[m3_recoth1]       int NULL,
	[m3_recoth2]       int NULL,
	[m3_recprctgrade]  numeric(18,0) NULL,
	[m3_recrpm]        int NULL,
	[m3_recspeed]      numeric(18,0) NULL,
	[m3_recwatres]     int NULL,
	
	[mchntype]         int NULL,
	[MthlyBPDia]       int NULL,
	[MthlyBPSys]       int NULL,
	[nomchntype]       varchar(max) NULL,
	
	[nxtsesn_dt]       date NULL,
	[othMchn1]         varchar(max) NULL,
	[othMchn2]         varchar(max) NULL,
	[reasnmisd]        int NULL,
	[Sessionmisd]      int NULL,
	[Sp_mchntype]      varchar(max) NULL,
	[sp_reasnmisd]     varchar(max) NULL,
	[trgthr1]          int NULL,
	[trgthr2]          int NULL,
	[typedata]         int NULL,
	[wrmup_hr]         int NULL,
	[wrmup_oth1]       int NULL,
	[wrmup_oth2]       int NULL,
	[wrmup_othafct]    int NULL,
	[wrmup_prctgrade]  numeric(18,0) NULL,
	[wrmup_rpe]        int NULL,
	[wrmup_rpm]        int NULL,
	[wrmup_speed]      numeric(18,0) NULL,
	[wrmup_watres]     int NULL,
	[breaks]           int NULL
	,[stopped] int NULL
	,[stoppedsp] varchar(max) NULL,
	,[stoppedhr] int NULL
	,[stoppedrpe] int NULL
	,[stoppedOthafct] int NULL
);


/* ---------------------------
frm_RETL

A table for resistance data
that can be shared by other apps.
 ---------------------------- */
IF OBJECT_ID( N'frm_RETL', N'U') IS NOT NULL
BEGIN
	DROP TABLE frm_RETL;
END
CREATE TABLE frm_RETL (
	[rec_id]          int IDENTITY(1,1) NOT NULL,
	[recordthread]    varchar(50) NOT NULL DEFAULT (newid()),
	[d_inserted]      datetime NOT NULL DEFAULT (getdate()),
	[insertedBy]      varchar(50) NOT NULL,
	[dayofwk] [int] NULL,
	[stdywk] [int] NULL,
	[typedata] [int] NULL,
	[weight] [numeric](18, 0) NULL,
	[deleted] [int] NULL,
	[deleteReason] [varchar](max) NULL,
	[participantGUID] [varchar](50) NULL,
	[visitGUID] [varchar](50) NULL,
	[d_visit] [date] NULL,
	[staffID] [varchar](10) NULL,
	[abdominalcrunch] [int] NULL,
	[abdominalcrunchRep1] [int] NULL,
	[abdominalcrunchRep2] [int] NULL,
	[abdominalcrunchRep3] [int] NULL,
	[abdominalcrunchWt1] [int] NULL,
	[abdominalcrunchWt2] [int] NULL,
	[abdominalcrunchWt3] [int] NULL,
	[bicepcurl] [int] NULL,
	[bicepcurlRep1] [int] NULL,
	[bicepcurlRep2] [int] NULL,
	[bicepcurlRep3] [int] NULL,
	[bicepcurlWt1] [int] NULL,
	[bicepcurlWt2] [int] NULL,
	[bicepcurlWt3] [int] NULL,
	[bodypart] [int] NULL,
	[bodyweight] [int] NULL,
	[bp1set1] [int] NULL,
	[bp1set2] [int] NULL,
	[bp1set3] [int] NULL,
	[bp2set1] [int] NULL,
	[bp2set2] [int] NULL,
	[bp2set3] [int] NULL,
	[breaks] [int] NULL,
	[calfpress] [int] NULL,
	[calfpressRep1] [int] NULL,
	[calfpressRep2] [int] NULL,
	[calfpressRep3] [int] NULL,
	[calfpressWt1] [int] NULL,
	[calfpressWt2] [int] NULL,
	[calfpressWt3] [int] NULL,
	[chest2] [int] NULL,
	[chest2Rep1] [int] NULL,
	[chest2Rep2] [int] NULL,
	[chest2Rep3] [int] NULL,
	[chest2Wt1] [int] NULL,
	[chest2Wt2] [int] NULL,
	[chest2Wt3] [int] NULL,
	[chestpress] [int] NULL,
	[chestpressRep1] [int] NULL,
	[chestpressRep2] [int] NULL,
	[chestpressRep3] [int] NULL,
	[chestpressWt1] [int] NULL,
	[chestpressWt2] [int] NULL,
	[chestpressWt3] [int] NULL,
	[dumbbellsquat] [int] NULL,
	[dumbbellsquatRep1] [int] NULL,
	[dumbbellsquatRep2] [int] NULL,
	[dumbbellsquatRep3] [int] NULL,
	[dumbbellsquatWt1] [int] NULL,
	[dumbbellsquatWt2] [int] NULL,
	[dumbbellsquatWt3] [int] NULL,
	[Hrworking] [int] NULL,
	[kneeextension] [int] NULL,
	[kneeextensionRep1] [int] NULL,
	[kneeextensionRep2] [int] NULL,
	[kneeextensionRep3] [int] NULL,
	[kneeextensionWt1] [int] NULL,
	[kneeextensionWt2] [int] NULL,
	[kneeextensionWt3] [int] NULL,
	[legcurl] [int] NULL,
	[legcurlRep1] [int] NULL,
	[legcurlRep2] [int] NULL,
	[legcurlRep3] [int] NULL,
	[legcurlWt1] [int] NULL,
	[legcurlWt2] [int] NULL,
	[legcurlWt3] [int] NULL,
	[legpress] [int] NULL,
	[legpressRep1] [int] NULL,
	[legpressRep2] [int] NULL,
	[legpressRep3] [int] NULL,
	[legpressWt1] [int] NULL,
	[legpressWt2] [int] NULL,
	[legpressWt3] [int] NULL,
	[MthlyBPDia] [int] NULL,
	[mthlybpsys] [int] NULL,
	[nxtsesn_dt] [date] NULL,
	[othMchn1] [varchar](max) NULL,
	[othMchn2] [varchar](max) NULL,
	[overheadpress] [int] NULL,
	[overheadpressRep1] [int] NULL,
	[overheadpressRep2] [int] NULL,
	[overheadpressRep3] [int] NULL,
	[overheadpressWt1] [int] NULL,
	[overheadpressWt2] [int] NULL,
	[overheadpressWt3] [int] NULL,
	[pulldown] [int] NULL,
	[pulldownRep1] [int] NULL,
	[pulldownRep2] [int] NULL,
	[pulldownRep3] [int] NULL,
	[pulldownWt1] [int] NULL,
	[pulldownWt2] [int] NULL,
	[pulldownWt3] [int] NULL,
	[reasnmisd] [int] NULL,
	[recstrcomplete] [int] NULL,
	[seatedrow] [int] NULL,
	[seatedrowRep1] [int] NULL,
	[seatedrowRep2] [int] NULL,
	[seatedrowRep3] [int] NULL,
	[seatedrowWt1] [int] NULL,
	[seatedrowWt2] [int] NULL,
	[seatedrowWt3] [int] NULL,
	[Sessionmisd] [int] NULL,
	[shoulder2] [int] NULL,
	[shoulder2Rep1] [int] NULL,
	[shoulder2Rep2] [int] NULL,
	[shoulder2Rep3] [int] NULL,
	[shoulder2Wt1] [int] NULL,
	[shoulder2Wt2] [int] NULL,
	[shoulder2Wt3] [int] NULL,
	[sp_reasnmisd] [varchar](max) NULL,
	[triceppress] [int] NULL,
	[triceppressRep1] [int] NULL,
	[triceppressRep2] [int] NULL,
	[triceppressRep3] [int] NULL,
	[triceppressWt1] [int] NULL,
	[triceppressWt2] [int] NULL,
	[triceppressWt3] [int] NULL,
	[wrmup_hr] [int] NULL,
	[wrmup_oth1] [int] NULL,
	[wrmup_oth2] [int] NULL,
	[wrmup_prctgrade] [numeric](18, 0) NULL,
	[wrmup_rpm] [int] NULL,
	[wrmup_speed] [numeric](18, 0) NULL,
	[wrmup_watres] [int] NULL,
	[wrmup_rpe] [int] NULL,
	[wrmup_othafct] [int] NULL,
	[modleg] [int] NULL,
	[modlegRep1] [int] NULL,
	[modlegRep2] [int] NULL,
	[modlegRep3] [int] NULL,
	[modlegWt1] [int] NULL,
	[modlegWt2] [int] NULL,
	[modlegWt3] [int] NULL
	,[stopped] int NULL
	,[stoppedsp] varchar(max) NULL
	,[stoppedhr] int NULL
	,[stoppedrpe] int NULL
	,[stoppedOthafct] int NULL
);



/* ---------------------------
ac_mtr_iv_metrics

Take a list of who used what
to get the app filled out.

 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_iv_metrics', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_iv_metrics;
END
CREATE TABLE ac_mtr_iv_metrics (
	 mt_id int IDENTITY(1,1) NOT NULL
	,mt_recordthread VARCHAR(64)
	,mt_daysession VARCHAR(64)
	,mt_staffguid VARCHAR(50)
	,mt_datetime DATE
);
 
 
 /* ---------------------------
ac_mtr_premature_sessions

Take note of who stopped the study
early.

 pm_id int IDENTITY(1,1) NOT NULL - 
,pm_breaks INT                    - Number of breaks taken
,pm_guid VARCHAR(64)              - GUID of person who stopped early 
,pm_dayofwk INT                   - Day that the person stopped early
,pm_week INT                      - Week that the person stopped early
,pm_time DATE                     - The time the user stopped
,pm_sessionStopReason VARCHAR(32000) - Why? 
,pm_heartrate INT                 - Heart rate when stopping
,pm_rpe INT                       - RPE
,pm_affect INT                    - Affect
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_premature_sessions', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_premature_sessions;
END
CREATE TABLE ac_mtr_premature_sessions (
	 pm_id int IDENTITY(1,1) NOT NULL
	,pm_breaks INT
	,pm_guid VARCHAR(64)
	,pm_dayofwk INT
	,pm_week INT
	,pm_time DATE
	,pm_sessionStopReason VARCHAR(64)
	,pm_heartrate INT
	,pm_rpe INT
	,pm_affect INT
);
 

 /* ---------------------------
ac_mtr_session_metadata

Track a site's session data for
the day.

 sm_id int IDENTITY(1,1) 
,sm_ivid VARCHAR(64)
,sm_siteid VARCHAR(64)
,sm_datetimestarted DATE
,sm_dayofweek INT        
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_session_metadata', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_session_metadata;
END
CREATE TABLE ac_mtr_session_metadata (
	 sm_id int IDENTITY(1,1) NOT NULL
	,sm_sessdayid VARCHAR(50) NOT NULL DEFAULT (newid())
	,sm_siteid VARCHAR(64)
	,sm_datetimestarted DATETIME NOT NULL
	,sm_dayofweek INT
	,sm_dayofmonth INT
	,sm_month INT
	,sm_year INT
);
 	
 
 /* ---------------------------
ac_mtr_session_staff_selected

When a staff member logs in and
chooses participants, they get
listed here.

 ss_id int IDENTITY(1,1)  - Unique ID
,ss_ivid VARCHAR(64)      - JOIN against sm_ivid in ac_mtr_session_metadata
,ss_staffid VARCHAR(64)   - Staff member logged in
,ss_participantrecordkey  - The key used to identify which participants are in the selected table
,ss_datelastaccessed DATE - Date last accessed by staff
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_session_staff_selected', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_session_staff_selected;
END
CREATE TABLE ac_mtr_session_staff_selected (
	 ss_id int IDENTITY(1,1) NOT NULL
	,ss_sessdayid VARCHAR(64)
	,ss_staffguid VARCHAR(50)
	,ss_staffsessionid VARCHAR(64)
	,ss_participantrecordkey VARCHAR(64) NOT NULL DEFAULT (newid())
	,ss_datelastaccessed DATETIME NOT NULL DEFAULT (getdate())
);
  

/* ---------------------------
ac_mtr_session_participants_selected

When a partcipant is chosen,
a record of that choice will be
recorded here.

 sp_id int IDENTITY(1,1) NOT NULL
,sp_ivid VARCHAR(64)
,sp_participantrecordkey VARCHAR(64)
,sp_participantGUID VARCHAR(64)
,sp_participantRecordThread DATE
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_session_participants_selected', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_session_participants_selected;
END
CREATE TABLE ac_mtr_session_participants_selected (
	 sp_id int IDENTITY(1,1) NOT NULL
	,sp_sessdayid VARCHAR(64)
	,sp_participantrecordkey VARCHAR(64)
	,sp_participantGUID VARCHAR(64)
	,sp_participantRecordThread VARCHAR(64)
);
 
 
 /* ---------------------------
ac_mtr_session_participant_data_tracker

-

 spdt_id int IDENTITY(1,1) NOT NULL
,spdt_sessdayid VARCHAR( 50 )
,spdt_check_in_completed BIT
,spdt_recovery_completed BIT
,spdt_exercise_parameter INTEGER
,spdt_exercise_list VARCHAR(1024)
,spdt_exercise_last_completed INTEGER
,spdt_week_chosen INTEGER
,spdt_last_interventionist_guid VARCHAR(50)
,spdt_user_guid VARCHAR(50)
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_session_participant_data_tracker', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_session_participant_data_tracker;
END
CREATE TABLE ac_mtr_session_participant_data_tracker 
(
	 spdt_id int IDENTITY(1,1) NOT NULL
	,spdt_sessdayid VARCHAR( 50 )
	,spdt_check_in_completed BIT
	,spdt_recovery_completed BIT
	,spdt_exercise_parameter INTEGER
	,spdt_exercise_list VARCHAR(1024)
	,spdt_exercise_last_completed INTEGER
	,spdt_week_chosen INTEGER
	,spdt_last_interventionist_guid VARCHAR(50)
	,spdt_user_guid VARCHAR(50)
); 
 
 

/* ---------------------------
ac_mtr_test_staff

Some test staff to see how overlapping
people would work.

 ts_id int IDENTITY(1,1) NOT NULL    - unique id
,ts_staffid VARCHAR(64)              - staff id
,ts_firstname VARCHAR(1024)          - 
,ts_middlename VARCHAR(1024)         -
,ts_lastname VARCHAR(1024)           -
,ts_siteid VARCHAR(64)               - where do they belong?
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_test_staff', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_test_staff;
END
CREATE TABLE ac_mtr_test_staff (
	 ts_id int IDENTITY(1,1) NOT NULL
	,ts_staffguid VARCHAR(50)
	,ts_firstname VARCHAR(1024)
	,ts_middlename VARCHAR(1024)
	,ts_lastname VARCHAR(1024)
	,ts_siteid VARCHAR(64)
);

/* ---------------------------
ParticipantNotes

New participant notes table to
more accurately match what is 
going on.

 [recID]            int IDENTITY(1,1) NOT NULL
,[noteGUID]         varchar(50) NOT NULL DEFAULT (newid())
,[participantGUID]  varchar(50) NULL
,[noteText]         varchar(max) NULL
,[noteCategory]     int NULL
,[noteDate]         datetime NULL
,[d_inserted]       datetime NOT NULL DEFAULT (getdate())
,[insertedby]       varchar(50) NULL
,[deleted]          int NULL
,[deletedby]        varchar(50) NULL
,[d_deleted]        datetime NULL
 ---------------------------- */
IF OBJECT_ID( N'ParticipantNotes', N'U') IS NOT NULL
BEGIN
	DROP TABLE ParticipantNotes;
END
CREATE TABLE ParticipantNotes (
	 [recID]            int IDENTITY(1,1) NOT NULL
	,[noteGUID]         varchar(50) NOT NULL DEFAULT (newid())
	,[participantGUID]  varchar(50) NULL
	,[noteText]         varchar(max) NULL
	,[noteCategory]     int NULL
	,[noteDate]         datetime NULL
	,[d_inserted]       datetime NOT NULL DEFAULT (getdate())
	,[insertedby]       varchar(50) NULL
	,[deleted]          int NULL
	,[deletedby]        varchar(50) NULL
	,[d_deleted]        datetime NULL
);


/* ---------------------------
ac_mtr_session_interventionist_assignment 

-

 [csd_id] int IDENTITY(1,1) NOT NULL
,[csd_daily_session_id] VARCHAR(64)
,[csd_interventionist_guid] VARCHAR(64)
,[csd_participant_guid] VARCHAR(64)
 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_session_interventionist_assignment', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_session_interventionist_assignment ;
END
CREATE TABLE ac_mtr_session_interventionist_assignment (
	 [csd_id] int IDENTITY(1,1) NOT NULL
	,[csd_daily_session_id] VARCHAR(64)
	,[csd_interventionist_guid] VARCHAR(64)
	,[csd_participant_guid] VARCHAR(64)
);

/* ---------------------------
ac_mtr_frm_labels 

-

 ---------------------------- */
IF OBJECT_ID( N'ac_mtr_frm_labels', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_frm_labels;
END
CREATE TABLE ac_mtr_frm_labels (
	 parttype INT NOT NULL
	,prefix VARCHAR(64) NOT NULL
	,pname VARCHAR(512) NOT NULL
	,urlparam INT NOT NULL
	,class INT NULL
);

INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'wrmup_', 0,  'Warm-Up' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm5_ex' , 5,  '<5m'  , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm10_ex', 10, '<10m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm15_ex', 15, '<15m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm20_ex', 20, '<20m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm25_ex', 25, '<25m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm30_ex', 30, '<30m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm35_ex', 35, '<35m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm40_ex', 40, '<40m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm45_ex', 45, '<45m' , 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 0,  'm3_rec', 50, '3<super>rd</super> Minute Recovery' , 0 );


INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'wrmup_'         , 0, '5 Minute Warmup', 0 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'legpress'       , 1, 'Leg Press', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'modleg'         , 2, 'Modified Leg Press', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'pulldown'       , 3, 'Pulldown', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'legcurl'        , 4, 'Leg Curl', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'seatedrow'      , 5, 'Seated Row', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'kneeextension'  , 6, 'Knee Extension', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'bicepcurl'      , 7, 'Biceps Curl', 1 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'chestpress'     , 8, 'Chest Press', 2 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'chest2'         , 9, 'Chest ##2', 2 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'abdominalcrunch', 10, 'Abdominal Crunch', 2 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'overheadpress'  , 11, 'Overhead Press', 2 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'calfpress'      , 12, 'Calf Press', 2 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'shoulder2'      , 13, 'Non-Press Shoulder Exercise', 2 );
INSERT INTO ac_mtr_frm_labels VALUES ( 1,  'triceppress'    , 14, 'Tricep Push-Down', 2 );


IF @BUILD_EQUIPMENT_LOG = 1
BEGIN
	/*For test mode, I also have to create the 
	equipmentLog*/ 
	IF OBJECT_ID( N'equipmentTracking', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTracking;
	END
	CREATE TABLE equipmentTracking (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[siteGUID] [varchar](50) NULL,
		[equipmentGUID] [varchar](50) NULL,
		[settingGUID] [varchar](50) NULL
	);

	 
	IF OBJECT_ID( N'equipmentTrackingEquipment', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingEquipment;
	END
	CREATE TABLE equipmentTrackingEquipment (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[siteGUID] [varchar](50) NULL,
		[machineGUID] [varchar](50) NULL,
		[equipmentGUID] [varchar](50) NULL,
		[exerciseGUID] [varchar](50) NULL,
		[active] [int] NULL,
		[interventionGUID] [varchar](50) NULL,
		[versionText] [varchar](max) NULL,
		[dateVersionChanged] [datetime] NULL
	); 

	IF OBJECT_ID( N'equipmentTrackingExercises', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingExercises;
	END
	CREATE TABLE equipmentTrackingExercises (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[exerciseGUID] [varchar](50) NULL,
		[exerciseDescription] [varchar](max) NULL,
		[exerciseOrder] [int] NULL,
		[formVariableName] [varchar](max) NULL
	); 


	IF OBJECT_ID( N'equipmentTrackingInterventions', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingInterventions;
	END
	CREATE TABLE equipmentTrackingInterventions (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[interventionGUID] [varchar](50) NULL,
		[interventionDescription] [varchar](max) NULL
	); 


	IF OBJECT_ID( N'equipmentTrackingMachines', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingMachines;
	END
	CREATE TABLE equipmentTrackingMachines (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[machineGUID] [varchar](50) NULL,
		[manufacturerGUID] [varchar](50) NULL,
		[modelGUID] [varchar](50) NULL
	);

	IF OBJECT_ID( N'equipmentTrackingManufacturers', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingManufacturers;
	END
	CREATE TABLE equipmentTrackingManufacturers (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[manufacturerGUID] [varchar](50) NULL,
		[manufacturerDescription] [varchar](max) NULL
	) ;


	IF OBJECT_ID( N'equipmentTrackingModels', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingModels;
	END
	CREATE TABLE equipmentTrackingModels (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[modelGUID] [varchar](50) NULL,
		[modelDescription] [varchar](max) NULL
	);


	IF OBJECT_ID( N'equipmentTrackingSettings', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingSettings;
	END
	CREATE TABLE equipmentTrackingSettings (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[settingGUID] [varchar](50) NULL,
		[settingDescription] [varchar](max) NULL
	); 


	IF OBJECT_ID( N'equipmentTrackingVersions', N'U') IS NOT NULL
	BEGIN
		DROP TABLE equipmentTrackingVersions;
	END
	CREATE TABLE equipmentTrackingVersions (
		[recID] [int] IDENTITY(1,1) NOT NULL,
		[d_inserted] [datetime] NULL,
		[insertedBy] [varchar](50) NULL,
		[deleted] [int] NULL,
		[deletedBy] [varchar](50) NULL,
		[d_deleted] [datetime] NULL,
		[deleteReason] [varchar](max) NULL,
		[versionGUID] [varchar](50) NULL,
		[versionDescription] [varchar](max) NULL
	); 
END;
GO
