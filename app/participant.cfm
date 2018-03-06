<!--- 

participant.cfm

Contains all the participant data.
Right now, it's just some fake thing.

--->
<cfquery datasource=#data.source# name=part>
SELECT * FROM ac_mtr_participants 
WHERE participant_id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">;
</cfquery>


<!--- Query for a lot of participant data 
(Consider using a view to speed things up)
--->
<cfquery datasource=#data.source# name=willis>
SELECT * FROM
( SELECT * FROM
	( SELECT * FROM
		( SELECT * FROM
			( SELECT * FROM
				/*Get eligibility*/
				( SELECT 
						participantGUID as e_participantGUID
						,randomGroupGUID
						,active
						,eligible as is_eligible	
					FROM Participants 
					WHERE eligible = 1 
				) AS g 
				INNER JOIN 
				( SELECT 
						*
					FROM frm_eligibility
				) AS e 
				ON e.participantGUID = g.e_participantGUID
			) AS ELIGIBLE_P

			INNER JOIN

			/*Get Basic Contact Info*/
			( SELECT 
					participantGUID as aduContact_participantGUID
					,pr_fname
					,pr_lname
					,pt_cellna
					,pt_cellnum
					,pt_city	
					,pt_email
					,pt_emailna
					,pt_fname
					,pt_homena
					,pt_homenum
					,pt_lname
					,pt_midinit
					,pt_state
					,pt_street1
					,pt_street2
					,pt_zipcode
				FROM frm_aduContact 
			) AS ADU
			ON ADU.aduContact_participantGUID = ELIGIBLE_P.participantGUID 
		) AS CONTACT

		INNER JOIN

		/*Get some other possibly related health information*/
		( SELECT
				participantGUID AS adude_participant_guid
				,currentcig
				,house_ref
				,household
				,lastgrade
				,lastgradesp
				,livealone
				,lives_child
				,lives_friend
				,lives_oth
				,lives_othrel
				,lives_othsp
				,lives_paidemp
				,lives_ref
				,lives_spouse
				,maritalstat
				,smokecig
				,state
				,state_na
				,state_ref
				,work
				,workhours
			FROM 
				frm_aduDemographics 
		) AS DEMOG
	ON DEMOG.adude_participant_guid = CONTACT.participantGUID
	) AS PB
	INNER JOIN
	( SELECT
			participantGUID as aduie_participant_id	
			,autoimmune
			,bonedis
			,chronicinf
			,chronicinfsp
			,donated
			,drinks
			,hypo_nodiab
			,marijuana
		FROM
			frm_ADUInclusionExclusion
		) AS ADUIE
	ON PB.participantGUID = ADUIE.aduie_participant_id	
) AS ALLPART
INNER JOIN
( SELECT 
		participantGUID as aduscr_participant_id	
		,dob
		,height
		,weight
		,latino
		,outoftown
		,race_AA
		,race_asian
		,race_cauc
		,race_natam
		,race_nathaw
		,race_oth
		,race_othsp
		,race_ref
		,tobacco
		,CASE gender
			WHEN 1 THEN 'Male' 
			WHEN 2 THEN 'Female'
		 END as gender 
	FROM 
		frm_ADUScreening 
) AS SCREEN
ON ALLPART.participantGUID = SCREEN.aduscr_participant_id
</cfquery>

<!---
<cfdump var = #willis#>
<cfabort>
--->

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


<!--- Do different things depending on the randomized exercise type --->
