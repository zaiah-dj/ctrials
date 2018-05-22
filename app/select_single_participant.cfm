<!--- 

//Name
participant.cfm

//Info
Contains all the participant data.
Right now, it's just some fake thing.

//Old query
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

--->
<cfscript>
if ( isDefined("url.id") ) {
	myPid=url.id;
	part = ezdb.exec(
		string = "SELECT * FROM 
			#data.data.participants# 
		WHERE 
			participantGUID = :pid" 
	 ,bindArgs = { pid = currentId }
	);
}
</cfscript>
