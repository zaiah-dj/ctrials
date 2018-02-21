<!--- 

participant.cfm

Contains all the participant data.
Right now, it's just some fake thing.

--->
<cfquery datasource=#data.source# name=part>
SELECT * FROM ac_mtr_participants 
WHERE participant_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">;
</cfquery>


<cfscript>
model = {};
model.participant_fname = "Antonio";
model.participant_mname = "Ramar";
model.active_tab = "Ramar";
model.participant_lname = "Collins";
model.participant_initial_weight = 176; 
model.participant_initial_height = 12 * 6 + 2; 
model.participant_avatar = "/assets/jc_avatar.jpg";
model.greeting = "Hello, there!";
model.addText = "And welcome to ColdMVC!";
</cfscript>
