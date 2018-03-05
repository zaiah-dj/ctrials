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
,participant_other_id varchar(64)
,participant_fname varchar(256)
,participant_mname varchar(256)
,participant_lname varchar(256)
,participant_age varchar(64)
,participant_randomization_string varchar(256)
,participant_date_of_randomization datetime
,participant_date_added datetime
,participant_date_modified datetime
,participant_avatar varchar(2048)
,participant_notes varchar(max)
,participant_initial_weight varchar(max)
,participant_initial_height varchar(max)
);


/*
 ----------------------------
ac_mtr_participants

A list of the participants (probably coming from somewhere else, but plug this in later)
This is looped through when building a list of participants to search through.
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_participant_addl', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_participant_addl;
END
CREATE TABLE ac_mtr_participant_addl 
(
participant_addl_id INT IDENTITY(1,1) NOT NULL 
,participant_addl_other_id varchar(64)
,participant_addl_fname varchar(256)
,participant_addl_mname varchar(256)
,participant_addl_lname varchar(256)
,participant_addl_age varchar(64)
,participant_addl_randomization_string varchar(256)
,participant_addl_date_of_randomization datetime
,participant_addl_date_added datetime
,participant_addl_date_modified datetime
,participant_addl_avatar varchar(2048)
,participant_addl_notes varchar(max)
,participant_addl_initial_weight varchar(max)
,participant_addl_initial_height varchar(max)
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
IF OBJECT_ID( N'ac_mtr_exercisetypes', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_exercisetypes;
END
CREATE TABLE ac_mtr_exercisetypes 
(
et_id INT IDENTITY(1,1) NOT NULL
,et_name varchar(256)
,et_description varchar(max)
);

/*
 ----------------------------
app_activity_log

Log application activity :)
 ----------------------------
*/


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
ac_mtr_log_control

Logs data specific to the 
control group.

What condition is the patient
in during the visit?

lc_id            Log control ID
lc_parent_id     Parent study
lc_misc          ?
lc_notes         ?
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_log_control', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_log_control;
END
CREATE TABLE ac_mtr_log_control (
lcc_id INT IDENTITY(1,1) NOT NULL
,lcc_parent_id int
,lcc_misc varchar(256)
,lcc_notes varchar(max) 
)



/*
 ----------------------------
ac_mtr_log_cardio

Logs data specific to the 
cardio group.

lc_id                 Unique
lc_type               Which type of cardio was used? (another table for this)
lc_type_other         Could be a totally different type of cardio
lc_set_index          ?
lc_length_of_set      Length that exercise was done
lc_resistance_used    ?
lc_notes              notes...
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_log_cardio', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_log_cardio;
END
CREATE TABLE ac_mtr_log_cardio (
lc_id INT IDENTITY(1,1) NOT NULL
,lc_type int
,lc_type_other varchar(256) 
,lc_set_index int
,lc_length_of_set int
,lc_resistance_used int
,lc_notes varchar(max) 
)


/*
 ----------------------------
ac_mtr_log_strength

Logs data specific to the 
strength study.
 
id 					an identifier
,set_index int - which number set is this?
,repetitions int - how many repetitions were part of this set
,weight_used int - how much weight was used
,notes varchar(max)  - anything of note happen?

ls_id                   Unique ID of this particular exercise
ls_parent_id            Parent is the dlog_id
ls_set_index            Strength training usually involves sets, so log the number here 
ls_repetitions          How many repetitions did the participant do?
ls_weight_used_lbs      How heavy (in lbs)
ls_weight_used_kgs      How heavy (in kgs)
ls_notes                Notes?  (a little excessive, but nobody cares)
 ----------------------------
*/
IF OBJECT_ID( N'ac_mtr_log_strength', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_log_strength;
END
CREATE TABLE ac_mtr_log_strength (
ls_id INT IDENTITY(1,1) NOT NULL
,ls_parent_id int
,ls_set_index int
,ls_repetitions int
,ls_weight_used_lbs int
,ls_weight_used_kgs int
,ls_notes varchar(max) 
)


/*
 ----------------------------
ac_mtr_patientstatus

What condition is the patient
in during the visit?

ps_id                 Unique
ps_before             Was this done before or after the exercises?
ps_weight             How heavy is patient at start?
ps_height             How tall is patient at start?
ps_fatigue            Approximate statement concerning the person's energy level
ps_vision             ...?
ps_stool              ...?
ps_hunger             ...?
ps_date_time_assessed When was the person assessed
ps_notes              notes...
 ----------------------------
 */
IF OBJECT_ID( N'ac_mtr_patientstatus', N'U') IS NOT NULL
BEGIN
	DROP TABLE ac_mtr_patientstatus;
END
CREATE TABLE ac_mtr_patientstatus (
 ps_id INT IDENTITY(1,1) NOT NULL
,ps_before bit
,ps_weight int
,ps_height int
,ps_fatigue int
,ps_vision int
,ps_stool int
,ps_hunger int
,ps_date_time_assessed datetime
,ps_notes varchar(max)
);


/*
 ----------------------------------
ac_mtr_participant_transaction_set

I'm so tired, I can't even think
of good table names...

p_uuid              Unique ID (all my tables have row id's)
p_transaction_id    A unique transaction ID, (which will be used only temporarily, but, yah, maybe I can recall)
p_staff_id          The staff member who will put in the data.
p_currentDatetime   Save the current date time


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
	,p_currentDateTime DATETIME
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

SET IDENTITY_INSERT ac_mtr_participant_transaction_members ON;
SET IDENTITY_INSERT ac_mtr_participant_transaction_set ON;
SET IDENTITY_INSERT ac_mtr_patientstatus ON;
SET IDENTITY_INSERT ac_mtr_log_strength ON;
SET IDENTITY_INSERT ac_mtr_log_cardio ON;
SET IDENTITY_INSERT ac_mtr_log_control ON;
SET IDENTITY_INSERT ac_mtr_dlog ON;
SET IDENTITY_INSERT ac_mtr_exercisetypes ON;
SET IDENTITY_INSERT ac_mtr_participant_addl ON;
SET IDENTITY_INSERT ac_mtr_participants ON;