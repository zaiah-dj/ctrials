/*
 ----------------------------
iv-first-draft.sql

First draft of SQL tables for
Intervention Tracking app.

Only works with SQL server
right now....
 ----------------------------
 */


/*
 ----------------------------
ac_mtr_participants

A list of the participants (probably coming from somewhere else, but plug this in later)
This is looped through when building a list of participants to search through.
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_participants', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_participants;
END
CREATE TABLE ac_mtr_participants
(
 participant_id INT IDENTITY(1,1) NOT NULL
,participant_fname varchar(256)
,participant_lname varchar(256)
,participant_mname varchar(256)
,participant_exercise INT NOT NULL
,participant_randomization_string VARCHAR(256)
,participant_initial_weight FLOAT NOT NULL
,participant_initial_height FLOAT NOT NULL
,participant_date_of_randomization DATETIME
,participant_avatar VARCHAR(max)
,participant_date_added DATETIME
,participant_date_modified DATETIME
,participant_notes VARCHAR(max)
);

/*
 ----------------------------
ac_mtr_exercisetypes

Different exercises can go 
here, depending on whether
or not we want to maintain
them here or in the app.
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_re_exercise_list', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_re_exercise_list;
END
CREATE TABLE ac_mtr_re_exercise_list 
(
et_id INT IDENTITY(1,1) NOT NULL
,et_name varchar(256)
,et_description varchar(max)
);

IF OBJECT_ID( N'ac_mtr_ee_machine_list', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_ee_machine_list;
END
CREATE TABLE ac_mtr_ee_machine_list 
(
et_id INT IDENTITY(1,1) NOT NULL
,et_name varchar(256)
,et_description varchar(max)
);

IF OBJECT_ID( N'ac_mtr_fail_visit_reasons', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_fail_visit_reasons;
END
CREATE TABLE ac_mtr_fail_visit_reasons 
(
et_id INT IDENTITY(1,1) NOT NULL
,et_name varchar(256)
,et_description varchar(max)
);



/*
 ----------------------------
ac_mtr_dlog

Daily log entries.

dlog_id										Unique ID of the log entry 
dlog_participant_id				Who does it belong to?
dlog_exercise_id int 			Unique ID of the exercise done
dlog_exercise_type int	  Which type of exercise is it?
dlog_date_time_completed  When was it completed? 
dlog_notes varchar(max)		Any special notes about this log entry?
dlog_difficulty int				?
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_dlog', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_dlog;
END
CREATE TABLE ac_mtr_dlog (
dlog_id INT IDENTITY(1,1) NOT NULL
,dlog_participant_id int
,dlog_exercise_id int
,dlog_exercise_type int
,dlog_length int
,dlog_date_time_completed datetime
,dlog_notes varchar(max)
,dlog_difficulty int
);



/*
 ----------------------------
ac_mtr_exercise_log

Logs all exercise data. Less
conditional programming is needed.
Hopefully...

el_id                      - Unique ID
el_length                  - How long has the session been going on
el_type                    - Type of exercise (re or ee, needed to diff)
el_sess_id                 - Session ID
el_participant_id          - part ID
el_re_reps                 - Repetitions in an re set
el_re_set_index            - Which set is/was the participant busy with?
el_re_weight_used_lbs      - What weight was used during this set
el_re_weight_used_kgs
el_re_equipment            - What equipment was used
el_ee_stage                - [cooldown, warmup, ... ]
el_ee_resistance_used      - 
el_ee_equipment
el_equipment_other
el_equipment_other_reason
el_ee_timeblock
el_datetime
el_notes

 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_exercise_log', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_exercise_log;
END
CREATE TABLE ac_mtr_exercise_log (
 el_id INT IDENTITY(1,1) NOT NULL
,el_type INT
,el_length INT
,el_sess_id INT
,el_participant_id INT
,el_re_reps INT
,el_re_set_index INT
,el_re_weight_used_lbs INT
,el_re_weight_used_kgs INT
,el_re_equipment INT
,el_ee_stage INT
,el_ee_resistance_used INT
,el_ee_equipment INT
,el_equipment_other VARCHAR(MAX)
,el_equipment_other_reason VARCHAR(MAX)
,el_ee_timeblock INT
,el_cc_fieldInt1 INT
,el_cc_fieldInt2 INT
,el_cc_fieldVarchar1 VARCHAR( MAX )
,el_cc_fieldVarchar2 VARCHAR( MAX )
,el_datetime DATETIME
,el_notes VARCHAR( MAX )
 );


/*
 ----------------------------
ac_mtr_checkinstatus

What condition is the patient
in during the visit?

ps_id                 Unique ID
ps_session_id         The session ID that this participant was tested during.
ps_before             Was this done before or after the exercises?
ps_weight             How heavy is patient at start?

ps_day                What day of the week were they looked at?
ps_date_time_assessed When was the person assessed
ps_droppedout         Did the participant opt out this time?
ps_dropout_reason     Why?
ps_notes              Other notes concerning the patient's condition.
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_checkinstatus', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_checkinstatus;
END
CREATE TABLE [dbo].[ac_mtr_checkinstatus](
	[ps_id] [int] IDENTITY(1,1) NOT NULL,
	[ps_session_id] [int] NULL,
	[ps_before] [bit] NULL,
	[ps_weight] [int] NULL,
	[ps_day] [int] NULL,
	[ps_next_sched] [datetime] NULL,
	[ps_date_time_assessed] [datetime] NULL,
	[ps_notes] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


CREATE TABLE ac_mtr_checkinstatus (
 ps_id INT IDENTITY(1,1) NOT NULL
,ps_pid int
,ps_session_id INT
,ps_before bit
,ps_weight int
,ps_day int
,ps_bp int
,ps_heartrate int
,ps_next_sched datetime
,ps_date_time_assessed datetime
,ps_notes varchar(max)
);


/*
 ----------------------------
	ac_mtr_dayplot
	
	This can be done via the 
	app engine, but I'm doing
	it here so the app can be
	more flexible.
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_dayplot', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_dayplot ;
END
CREATE TABLE ac_mtr_dayplot (
	dp_id INT
	,dp_day VARCHAR(4)
	,dp_longday VARCHAR(24)
);


/*
 ----------------------------
	ac_ex_choices

	temporary table to hold
	choices of exerciss	
 ----------------------------
 */
IF OBJECT_ID( N'ac_ex_choices', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_ex_choices ;
END
CREATE TABLE ac_ex_choices (
	 ex_id INT
	,ex_designation VARCHAR(256)
);

/*
 ----------------------------------
ac_mtr_participant_transaction_set

I'm so tired, I can't even think
of good table names...
k
p_uuid              Unique ID (all my tables have row id's)
p_transaction_id    A unique transaction ID, (which will be used only temporarily, but, yah, maybe I can recall)
p_staff_id          The staff member who will put in the data.
p_expire_time       When should this be completely finished?
p_currentDatetime   Save the current date time
p_lastUpdateTime    Last updated when?


*If I save as I go, how do I get 
rid of stuff?  
Also, how do I recall??????????
More than likely the same session is used...
May need to modify...

----------------------------------
 */
IF OBJECT_ID( N'ac_mtr_participant_transaction_set', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_participant_transaction_set;
END
CREATE TABLE ac_mtr_participant_transaction_set
(
	 p_uuid INT IDENTITY(1,1) NOT NULL
	,p_transaction_id INT
	,p_staff_id INT
	,p_expires BIT
	,p_currentDateTime DATETIME
	,p_lastUpdateTime DATETIME
);

/*
----------------------------------
ac_mtr_participant_transaction_members

This might be a job for Redis.

With its key valuing...

p_uuid              Unique ID (all my tables have row id's)
p_transaction_id    Use the same transaction.
p_id                Save each ID here.
----------------------------------
 */
IF OBJECT_ID( N'ac_mtr_participant_transaction_members', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_participant_transaction_members;
END
CREATE TABLE ac_mtr_participant_transaction_members 
(
	p_uuid INT IDENTITY(1,1) NOT NULL
	,p_transaction_id INT
	,p_id INT
);


/*
----------------------------------
ac_mtr_days_tracker

Track the days that the participant is in.

With its key valuing...

dt_uuid              - Unique ID
dt_session           - Session that this set belonged to
dt_day_of_week       - Day of week that the participant is attending
dt_part_id           - Participant ID
dt_date_full         - What's the full date? (dunno if this is really needed)
dt_week_index        - Which week is the participant on?
dt_week_start        - A date that marks the start of the week ( can calculate from here )
dt_week_visit_index  - Which visit during the week is this?  ( 1 - 4 )
----------------------------------
 */
IF OBJECT_ID( N'ac_mtr_days_tracker', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_days_tracker;
END
CREATE TABLE ac_mtr_days_tracker 
(
 dt_uuid INT IDENTITY(1,1) NOT NULL
,dt_session_id INT
,dt_day_of_week INT /*Perhaps this should just be the day name?*/
,dt_participant_id INT
,dt_week_index INT
,dt_date_full DATETIME
,dt_week_visit_index INT
);

/*
SET IDENTITY_INSERT ac_mtr_participant_transaction_members ON;
SET IDENTITY_INSERT ac_mtr_participant_transaction_set ON;
SET IDENTITY_INSERT ac_mtr_patientstatus ON;
SET IDENTITY_INSERT ac_mtr_log_strength ON;
SET IDENTITY_INSERT ac_mtr_log_cardio ON;
SET IDENTITY_INSERT ac_mtr_log_control ON;
SET IDENTITY_INSERT ac_mtr_dlog ON;
SET IDENTITY_INSERT ac_mtr_exercisetypes ON;
SET IDENTITY_INSERT ac_mtr_participant_addl ON;
SET IDENTITY_INSERT ac_mtr_participants__ ON;
SET IDENTITY_INSERT ac_mtr_re_exercise_list ON;
SET IDENTITY_INSERT ac_mtr_ee_machine_list ON;
SET IDENTITY_INSERT ac_mtr_fail_visit_reasons ON;
*/

/*
----------------------------------
Prefill lots of this.
----------------------------------
 */
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Leg Presses', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Leg Curls', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Leg Extensions', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Seated Calf', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Bicep Curls', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Tricep Presses', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Chest Presses', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Seated Rows', '' );


INSERT INTO ac_mtr_ee_machine_list VALUES ( 'Cycle', '' );
INSERT INTO ac_mtr_ee_machine_list VALUES ( 'Treadmill', '' );
INSERT INTO ac_mtr_ee_machine_list VALUES ( 'Other', '' );

INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Illness/Health Problems', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Transportation Difficulties', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Cognitive difficulties', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'In Nursing Home/Long-Term Care Facility', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Too Busy; Time and/or Work Conflict', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Caregiver Responsibilities', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Physician''s Advice', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Problems with Muscles/Joints', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Forgot Appointment', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Moved out of area', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Traveling/On Vacation', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Personal Problems', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Unable to Contact/Locate', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Refused to Give Reason', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Withdrew from Study', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Withdrew Informed Consent', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Dissatisfied with Study', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Deceased', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Center Closed', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Other', '' );
INSERT INTO ac_mtr_fail_visit_reasons VALUES ( 'Unknown', '' );


INSERT INTO ac_mtr_participants VALUES ( 'Robert', 'Beasely', 'M', 1, '7999573dd86773e000769f8fc6ef81fb', 236.0, 72.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Wellesly', 'Chapel', 'Elliott', 2, 'ab021d4f2ca7eb3221780d843b6fbeab', 521.0, 96.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Durn', 'Furn', 'The', 1, '94d7d96ac3d24fc54e48764f6732ee55', 233.0, 52.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Durham', 'Bigly', 'O', 1, '8f78255f717c000fa9766c8689b4ac71', 211.0, 64.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Virginia', 'Tellurude', '', 1, 'cc6bd720fcf62888f03e9dfdbcdef5c6', 121.0, 74.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Gonzaga', 'Montroni', '', 1, 'f345f812e3ddbffc64f3cc08d2502e00', 111.0, 75.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Jim', 'Fashionista', '', 3, '46185b7fbe0d4e75d3120b0535930620', 186.0, 77.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Antonio', 'Collins', 'Ramar', 2, '93a64ab9cfc28478c77920463915aaed', 187.0, 81.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Fat', 'Man', '', 2, '8cea9cc559b44ad8ecb90d82a7ef4e1e', 154.0, 92.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Little', 'Boy', '', 2, '6e2ae3787cae27ca7a2593022ed6c37d', 164.0, 91.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Hiroshima', 'Marketplace', 'The', 1, 'd6b24c57606f6d3b6e8965901f2c44f0', 151.0, 78.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Heidi', 'Woe', 'Woe', 1, '82dede3a93b6adc7ce606ba94150d8a4', 123.0, 82.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Dell', 'Jackson', 'Michael', 1, '07ae127c83bbcb9a19352ff105cb523c', 187.0, 85.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Michael', 'Jackson', 'Joe', 1, 'f868352bd570bb498e498cbf80eaf412', 142.0, 86.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Smarty', 'Jopeep', '', 2, '6c99d53beba19432e329e98094eca59d', 156.0, 86.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Peter', 'Rabbit', '', 1, '126348853a241a13f5f626264409bbf5', 210.0, 81.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Wallets', 'Getstolen', 'Always', 2, '46830983eaf211822a2bd834cc4ee55d', 274.0, 72.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Jarius', 'Richardson', '', 1, 'acc51db689572c1c443c6ba9e95636de', 121.0, 46.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Avagard', 'Reva', '', 3, '7e227a123d9d520b7e63d4ef13de3f29', 96.0, 54.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
INSERT INTO ac_mtr_participants VALUES ( 'Dr', 'Monty', '', 3, '09f6cfc5d626c2c14dadc09c6aaac41d', 184.0, 87.0, 0, '/assets/jc_avatar.jpg', 0, 0 , '' );
