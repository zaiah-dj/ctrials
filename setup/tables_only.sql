/* ---------------------------
INTERVENTION TRACKING TABLES

First draft of SQL tables for
Intervention Tracking app.

Only works with SQL server
right now....
 ---------------------------- */




/* ---------------------------
ac_mtr_re_exercise_list

 ---------------------------- */
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

INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Leg Presses', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Leg Curls', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Leg Extensions', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Seated Calf', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Bicep Curls', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Tricep Presses', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Chest Presses', '' );
INSERT INTO ac_mtr_re_exercise_list VALUES ( 'Seated Rows', '' );



/* ---------------------------
ac_mtr_ee_machine_list

 ---------------------------- */
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

INSERT INTO ac_mtr_ee_machine_list VALUES ( 'Cycle', '' );
INSERT INTO ac_mtr_ee_machine_list VALUES ( 'Treadmill', '' );
INSERT INTO ac_mtr_ee_machine_list VALUES ( 'Other', '' );

/* ---------------------------
ac_mtr_fail_visit_reason

 ---------------------------- */
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
ac_mtr_exercise_log_master

Track all the exercise data.

 el_id INT IDENTITY(1,1) NOT NULL
,el_matchid INT
,el_type INT
,el_sess_id INT
,el_datetime DATETIME
,el_fail BIT 
,el_failreason VARCHAR(MAX)
,el_notes VARCHAR( MAX )
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_exercise_log_master', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_exercise_log_master;
END
CREATE TABLE ac_mtr_exercise_log_master (
	 el_id INT IDENTITY(1,1) NOT NULL
	,el_matchid INT  /*which log to look into?*/
	,el_type INT
	,el_sess_id INT
	,el_datetime DATETIME
	,el_fail BIT 
	,el_failreason VARCHAR(MAX)
	,el_notes VARCHAR( MAX )
 );

/*
 ----------------------------
ac_mtr_exercise_log_re

Track resistance exercise results.

 el_reid INT IDENTITY(1,1) NOT NULL
,el_re_pid INT
,el_re_ex_session_id INT 
,el_re_reps1 INT
,el_re_weight1 INT
,el_re_reps2 INT
,el_re_weight2 INT
,el_re_reps3 INT
,el_re_weight3 INT
,el_re_extype INT
,el_re_datetime DATETIME
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_exercise_log_re', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_exercise_log_re;
END
CREATE TABLE ac_mtr_exercise_log_re (
	 el_reid INT IDENTITY(1,1) NOT NULL
	,el_re_pid INT
	,el_re_ex_session_id INT 
	,el_re_reps1 INT
	,el_re_weight1 INT
	,el_re_reps2 INT
	,el_re_weight2 INT
	,el_re_reps3 INT
	,el_re_weight3 INT
	,el_re_extype INT
	,el_re_datetime DATETIME
);

/*
 ----------------------------
ac_mtr_exercise_log_ee

Track endurance exercise results.

 el_eeid INT IDENTITY(1,1) NOT NULL
,el_ee_pid INT
,el_ee_ex_session_id INT
,el_ee_equipment INT
,el_ee_timeblock INT
,el_ee_rpm INT
,el_ee_watts_resistance INT
,el_ee_speed INT
,el_ee_grade INT
,el_ee_perceived_exertion INT
,el_ee_datetime DATETIME
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_exercise_log_ee', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_exercise_log_ee;
END
CREATE TABLE ac_mtr_exercise_log_ee (
	 el_eeid INT IDENTITY(1,1) NOT NULL
	,el_ee_pid INT
	,el_ee_ex_session_id INT
	,el_ee_equipment INT
	,el_ee_timeblock INT
	,el_ee_rpm INT
	,el_ee_watts_resistance INT
	,el_ee_speed INT
	,el_ee_grade INT
	,el_ee_perceived_exertion INT
	,el_ee_datetime DATETIME
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
CREATE TABLE ac_mtr_checkinstatus (	
	 ps_id INT IDENTITY(1,1) NOT NULL
	,ps_pid int
	,ps_session_id INT
	,ps_before bit
	,ps_weight int
	,ps_day int
	,ps_next_sched datetime
	,ps_date_time_assessed datetime
	,ps_notes varchar(max)
);

/*
 ----------------------------
ac_mtr_bloodpressure

Get the blood pressure of a 
participant if needed.

 ----------------------------
 */
CREATE TABLE ac_mtr_bloodpressure (
	 bp_id INT IDENTITY(1,1) NOT NULL
	,bp_pid int
	,bp_systolic int
	,bp_diastolic int
	,bp_daterecorded DATETIME
	,bp_notes varchar(max)
);


/*
 ----------------------------------
ac_mtr_participant_transaction_set

I'm so tired, I can't even think
of good table names...
k
p_uuid              Unique ID (all my tables have row id's)
p_transaction_id    A unique transaction ID, (which will be used only temporarily, but, yah, maybe I can recall)
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
CREATE TABLE ac_mtr_participant_transaction_set (
	 p_uuid INT IDENTITY(1,1) NOT NULL
	,p_transaction_id INT
	,p_expires BIT
	,p_currentDateTime DATETIME
	,p_lastUpdateTime DATETIME
);

/*
----------------------------------
ac_mtr_participant_transaction_staffs

Keep track of the staff members active a session.

p_uuid INT IDENTITY(1,1) NOT NULL
,p_transaction_id INT
,p_sdom INT
,p_sday INT
,p_sid INT
----------------------------------
 */
IF OBJECT_ID( N'ac_mtr_participant_transaction_staff', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_participant_transaction_staff;
END
CREATE TABLE ac_mtr_participant_transaction_staff 
(
	s_uuid INT IDENTITY(1,1) NOT NULL
	,s_transaction_id INT
	,s_sdom INT
	,s_sday INT
	,s_sid INT
);


/*
----------------------------------
ac_mtr_participant_transaction_members

This might be a job for Redis.

With its key valuing...

p_uuid INT IDENTITY(1,1) NOT NULL
,p_transaction_id INT
,p_pdom INT
,p_pday INT
,p_pid INT
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
	,p_pdom INT
	,p_pday INT
	,p_pid INT
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
 ----------------------------
ac_mtr_participants

A list of the participants 
(probably coming from somewhere 
else, but plug this in later)
This is looped through when 
building a list of participants 
to search through.
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_participants', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_participants;
END
CREATE TABLE ac_mtr_participants
(
	 p_id INT IDENTITY(1,1) NOT NULL
	,p_fname varchar(256)
	,p_lname varchar(256)
	,p_mname varchar(256)
	,p_exercise INT NOT NULL
	,p_randomization_string VARCHAR(256)
	,p_initial_weight FLOAT NOT NULL
	,p_initial_height FLOAT NOT NULL
	,p_date_of_randomization DATETIME
	,p_avatar VARCHAR(max)
	,p_date_added DATETIME
	,p_date_modified DATETIME
    ,p_targetheartrate INT
	,p_notes VARCHAR(max)
);

INSERT INTO ac_mtr_participants VALUES ( 'Robert', 'Beasely', 'M', 1, '7999573dd86773e000769f8fc6ef81fb', 236.0, 72.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 80, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Wellesly', 'Chapel', 'Elliott', 2, 'ab021d4f2ca7eb3221780d843b6fbeab', 521.0, 96.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 60, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Durn', 'Furn', 'The', 1, '94d7d96ac3d24fc54e48764f6732ee55', 233.0, 52.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 87, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Durham', 'Bigly', 'O', 1, '8f78255f717c000fa9766c8689b4ac71', 211.0, 64.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 81, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Virginia', 'Tellurude', '', 1, 'cc6bd720fcf62888f03e9dfdbcdef5c6', 121.0, 74.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 43, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Gonzaga', 'Montroni', '', 1, 'f345f812e3ddbffc64f3cc08d2502e00', 111.0, 75.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 67, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Jim', 'Fashionista', '', 3, '46185b7fbe0d4e75d3120b0535930620', 186.0, 77.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 79, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Antonio', 'Collins', 'Ramar', 2, '93a64ab9cfc28478c77920463915aaed', 187.0, 81.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 90, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Fat', 'Man', '', 2, '8cea9cc559b44ad8ecb90d82a7ef4e1e', 154.0, 92.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 94, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Little', 'Boy', '', 2, '6e2ae3787cae27ca7a2593022ed6c37d', 164.0, 91.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 82, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Hiroshima', 'Marketplace', 'The', 1, 'd6b24c57606f6d3b6e8965901f2c44f0', 151.0, 78.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 86, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Heidi', 'Woe', 'Woe', 1, '82dede3a93b6adc7ce606ba94150d8a4', 123.0, 82.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 56, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Dell', 'Jackson', 'Michael', 1, '07ae127c83bbcb9a19352ff105cb523c', 187.0, 85.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 74, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Michael', 'Jackson', 'Joe', 1, 'f868352bd570bb498e498cbf80eaf412', 142.0, 86.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 76, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Smarty', 'Jopeep', '', 2, '6c99d53beba19432e329e98094eca59d', 156.0, 86.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 88, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Peter', 'Rabbit', '', 1, '126348853a241a13f5f626264409bbf5', 210.0, 81.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 81, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Wallets', 'Getstolen', 'Always', 2, '46830983eaf211822a2bd834cc4ee55d', 274.0, 72.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 57, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Jarius', 'Richardson', '', 1, 'acc51db689572c1c443c6ba9e95636de', 121.0, 46.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 90, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Avagard', 'Reva', '', 3, '7e227a123d9d520b7e63d4ef13de3f29', 96.0, 54.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 87, '' );
INSERT INTO ac_mtr_participants VALUES ( 'Doctor', 'Monty', 'Julius', 3, '09f6cfc5d626c2c14dadc09c6aaac41d', 184.0, 87.0, 0, '/assets/jc_avatar.jpg', 0, 0 , 83, '' );


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

