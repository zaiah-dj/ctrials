<!--- 

Deserialize JSON and store values in the proper places...


The values received will go in one of three tables:

ac_mtr_dlog          - Log of exercises done
ac_mtr_log_control   - PLACEHOLDER FOR CONTROL DATA
ac_mtr_log_cardio    - Log of cardio data 
ac_mtr_log_strength  - Log of strength data
ac_mtr_patientstatus - Log of patient's current health (track per day?)

--->
<cfset model = {}>
<cfif !StructKeyExists( form, "value" )> 
	<cfset model.status = 0>
	<cfset model.message = "No values specified for updating.">
<cfelse>
<cfoutput>
#form.id#<br />
#form.name#<br />
#form.value#<br />
#form.table#
</cfoutput>
<!---
	<cfset values = DeserializeJSON( form.value )>


<h2>values</h2>
<cfoutput>
#values.id#<br />
#values.name#<br />
#values.value#<br />
#values.table#
</cfoutput>
<cfabort>
--->
	<cfset model.status = 1>
	<cfset model.message = "SUCCESS">
</cfif>

