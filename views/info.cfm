<cfscript>
f = [
/*
//fields that have been disabled
{ name = "DELETED", field = #willis.DELETED#, caption = "DELETED", text = "DELETED" },
{ name = "DELETEREASON", field = #willis.DELETEREASON#, caption = "DELETEREASON", text = "DELETEREASON" },
{ name = "DOMAINGUID", field = #willis.DOMAINGUID#, caption = "DOMAINGUID", text = "DOMAINGUID" },
{ name = "D_INSERTED", field = #willis.D_INSERTED#, caption = "D_INSERTED", text = "D_INSERTED" },
{ name = "D_VISIT", field = #willis.D_VISIT#, caption = "D_VISIT", text = "D_VISIT" },

{ name = "ACTIVE", field = #willis.ACTIVE#, caption = "ACTIVE", text = "ACTIVE" },
{ name = "LIVEALONE", field = #willis.LIVEALONE#, caption = "LIVEALONE", text = "LIVEALONE" },
{ name = "LIVES_CHILD", field = #willis.LIVES_CHILD#, caption = "LIVES_CHILD", text = "LIVES_CHILD" },
{ name = "LIVES_FRIEND", field = #willis.LIVES_FRIEND#, caption = "LIVES_FRIEND", text = "LIVES_FRIEND" },
{ name = "LIVES_OTH", field = #willis.LIVES_OTH#, caption = "LIVES_OTH", text = "LIVES_OTH" },
{ name = "LIVES_OTHREL", field = #willis.LIVES_OTHREL#, caption = "LIVES_OTHREL", text = "LIVES_OTHREL" },
{ name = "LIVES_OTHSP", field = #willis.LIVES_OTHSP#, caption = "LIVES_OTHSP", text = "LIVES_OTHSP" },
{ name = "LIVES_PAIDEMP", field = #willis.LIVES_PAIDEMP#, caption = "LIVES_PAIDEMP", text = "LIVES_PAIDEMP" },
{ name = "LIVES_REF", field = #willis.LIVES_REF#, caption = "LIVES_REF", text = "LIVES_REF" },
{ name = "LIVES_SPOUSE", field = #willis.LIVES_SPOUSE#, caption = "LIVES_SPOUSE", text = "LIVES_SPOUSE" },

{ name = "RACE_AA", field = #willis.RACE_AA#, caption = "RACE_AA", text = "RACE_AA" },
{ name = "RACE_ASIAN", field = #willis.RACE_ASIAN#, caption = "RACE_ASIAN", text = "RACE_ASIAN" },
{ name = "RACE_CAUC", field = #willis.RACE_CAUC#, caption = "RACE_CAUC", text = "RACE_CAUC" },
{ name = "RACE_NATAM", field = #willis.RACE_NATAM#, caption = "RACE_NATAM", text = "RACE_NATAM" },
{ name = "RACE_NATHAW", field = #willis.RACE_NATHAW#, caption = "RACE_NATHAW", text = "RACE_NATHAW" },
{ name = "RACE_OTH", field = #willis.RACE_OTH#, caption = "RACE_OTH", text = "RACE_OTH" },
{ name = "RACE_OTHSP", field = #willis.RACE_OTHSP#, caption = "RACE_OTHSP", text = "RACE_OTHSP" },
{ name = "RACE_REF", field = #willis.RACE_REF#, caption = "RACE_REF", text = "RACE_REF" },
{ name = "VISITGUID", field = #willis.VISITGUID#, caption = "VISITGUID", text = "VISITGUID" },
{ name = "RECORDTHREAD", field = #willis.RECORDTHREAD#, caption = "RECORDTHREAD", text = "RECORDTHREAD" },
{ name = "RANDOMGROUPGUID", field = #willis.RANDOMGROUPGUID#, caption = "RANDOMGROUPGUID", text = "RANDOMGROUPGUID" },
*/

/*...*/

/*...*/
{ designation = "Participant Info" },
{ name = "PR_FNAME", field = #willis.PR_FNAME#, caption = "PR_FNAME", text = "First Name" },
{ name = "PR_LNAME", field = #willis.PR_LNAME#, caption = "PR_LNAME", text = "Last Name" },
{ name = "PT_FNAME", field = #willis.PT_FNAME#, caption = "PT_FNAME", text = "First Name" },
{ name = "PT_MIDINIT", field = #willis.PT_MIDINIT#, caption = "PT_MIDINIT", text = "Middle Initial" },
{ name = "PT_LNAME", field = #willis.PT_LNAME#, caption = "PT_LNAME", text = "Last Name" },
{ name = "DOB", field = #willis.DOB#, caption = "DOB", text = "DOB" },
{ name = "GENDER", field = #willis.GENDER#, caption = "GENDER", text = "Gender" },
{ name = "HEIGHT", field = #willis.HEIGHT#, caption = "HEIGHT", text = "Height" },
{ name = "WEIGHT", field = #willis.WEIGHT#, caption = "WEIGHT", text = "Weight" },

{ designation = "Contact Info" },
{ name = "PT_CELLNA", field = #willis.PT_CELLNA#, caption = "PT_CELLNA", text = "PT_CELLNA" },
{ name = "PT_CELLNUM", field = #willis.PT_CELLNUM#, caption = "PT_CELLNUM", text = "PT_CELLNUM" },
{ name = "PT_CITY", field = #willis.PT_CITY#, caption = "PT_CITY", text = "Participant City" },
{ name = "PT_EMAIL", field = #willis.PT_EMAIL#, caption = "PT_EMAIL", text = "Participant Email" },
{ name = "PT_EMAILNA", field = #willis.PT_EMAILNA#, caption = "PT_EMAILNA", text = "PT_EMAILNA" },
{ name = "PT_HOMENA", field = #willis.PT_HOMENA#, caption = "PT_HOMENA", text = "PT_HOMENA" },
{ name = "PT_HOMENUM", field = #willis.PT_HOMENUM#, caption = "PT_HOMENUM", text = "Participant Home Tel." },
{ name = "PT_STATE", field = #willis.PT_STATE#, caption = "PT_STATE", text = "PT_STATE" },
{ name = "PT_STREET1", field = #willis.PT_STREET1#, caption = "PT_STREET1", text = "Participant Street Address 1" },
{ name = "PT_STREET2", field = #willis.PT_STREET2#, caption = "PT_STREET2", text = "Participant Street Address 2" },
{ name = "PT_ZIPCODE", field = #willis.PT_ZIPCODE#, caption = "PT_ZIPCODE", text = "Particiapnt Zip Code" },
{ name = "STATE", field = #willis.STATE#, caption = "STATE", text = "Participant State" },
{ name = "STATE_NA", field = #willis.STATE_NA#, caption = "STATE_NA", text = "STATE_NA" },
{ name = "STATE_REF", field = #willis.STATE_REF#, caption = "STATE_REF", text = "STATE_REF" },

{ designation = "Excess Info" },
{ name = "AUTOIMMUNE", field = #willis.AUTOIMMUNE#, caption = "AUTOIMMUNE", text = "Has autoimmune disorder?" },
{ name = "BONEDIS", field = #willis.BONEDIS#, caption = "BONEDIS", text = "Has bone disease?" },
{ name = "CHRONICINF", field = #willis.CHRONICINF#, caption = "CHRONICINF", text = "CHRONICINF" },
{ name = "CHRONICINFSP", field = #willis.CHRONICINFSP#, caption = "CHRONICINFSP", text = "CHRONICINFSP" },
{ name = "COMPLETEDBY", field = #willis.COMPLETEDBY#, caption = "COMPLETEDBY", text = "COMPLETEDBY" },
{ name = "CURRENTCIG", field = #willis.CURRENTCIG#, caption = "CURRENTCIG", text = "CURRENTCIG" },
{ name = "DONATED", field = #willis.DONATED#, caption = "DONATED", text = "Donated blood?" },
{ name = "DRINKS", field = #willis.DRINKS#, caption = "DRINKS", text = "Drinks?" },
/*{ name = "ELIGIBLE", field = #willis.ELIGIBLE#, caption = "ELIGIBLE", text = "Eligible for study?" },*/
/*{ name = "HOUSEHOLD", field = #willis.HOUSEHOLD#, caption = "HOUSEHOLD", text = "HOUSEHOLD" },
{ name = "IS_ELIGIBLE", field = #willis.IS_ELIGIBLE#, caption = "IS_ELIGIBLE", text = "IS_ELIGIBLE" },
{ name = "HOUSE_REF", field = #willis.HOUSE_REF#, caption = "HOUSE_REF", text = "HOUSE_REF" },*/
{ name = "HYPO_NODIAB", field = #willis.HYPO_NODIAB#, caption = "HYPO_NODIAB", text = "HYPO_NODIAB" },
{ name = "LASTGRADE", field = #willis.LASTGRADE#, caption = "LASTGRADE", text = "LASTGRADE" },
{ name = "INSERTEDBY", field = #willis.INSERTEDBY#, caption = "INSERTEDBY", text = "INSERTEDBY" },
{ name = "LASTGRADESP", field = #willis.LASTGRADESP#, caption = "LASTGRADESP", text = "LASTGRADESP" },
{ name = "LATINO", field = #willis.LATINO#, caption = "LATINO", text = "LATINO" },
{ name = "MARIJUANA", field = #willis.MARIJUANA#, caption = "MARIJUANA", text = "Smokes marijuana?" },
{ name = "MARITALSTAT", field = #willis.MARITALSTAT#, caption = "MARITALSTAT", text = "Marital Status" },
{ name = "OUTOFTOWN", field = #willis.OUTOFTOWN#, caption = "OUTOFTOWN", text = "OUTOFTOWN" },
{ name = "REC_ID", field = #willis.REC_ID#, caption = "REC_ID", text = "REC_ID" },
{ name = "SMOKECIG", field = #willis.SMOKECIG#, caption = "SMOKECIG", text = "Smokes cigarettes?" },
{ name = "TOBACCO", field = #willis.TOBACCO#, caption = "TOBACCO", text = "Uses tobacco?" },
{ name = "WORK", field = #willis.WORK#, caption = "WORK", text = "Work Schedule" },
{ name = "WORKHOURS", field = #willis.WORKHOURS#, caption = "WORKHOURS", text = "WORKHOURS" }
];
</cfscript>


<cfset c=0>
<cfoutput>
	<div class="container-body">
		<!--- participant --->
		<style type="text/css">
		div.holdThings { width: 200px; }

		h3.dogInThisFight
		{ display: inline-block; } 

		.collapsible { position: relative; float: right; top: 30px; right: 20px; }

		</style>

		<cfloop array = "#f#" item = "ff" >

		<cfif structKeyExists( ff, "designation" )>
			<cfif c++ gt 0> </tbody>
				</table>
			</div>
		</cfif>
		<h3 class="dogInThisFight">#ff.designation#</h3>
		<input type="checkbox" class="collapsible">
		<div>
		<table class="table">
			<tbody>
		<cfelse>
			<tr>
				<td class="title">#ff.text#</td>
				<td style="width: 70%">
					<cfif getMetadata( ff.field ).getTypeName() eq "java.lang.Integer">
						<cfif ff.field eq 0>No<cfelseif ff.field eq 1>Yes<cfelse>#ff.field#</cfif>
					<cfelse>
						#ff.field#
					</cfif>
				</td>
			</tr>
		</cfif>
		</cfloop>
		</table>
	</div>
</cfoutput>
