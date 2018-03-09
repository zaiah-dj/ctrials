<cfscript> 
model = {};
model.status = 0;
model.message = "";
model.array = [];
</cfscript>

	<cfif !isDefined( "form.transact_id" ) || !isDefined( "form.staffer_id" ) || !StructKeyExists( form, "transact_id" )>
		<cfset model.status=500>
		<cfset model.message="Failed to write due to missing fields 'TRANSACT_ID' or 'STAFFER_ID'">
		<cfset model.listing="">
		
	<cfelse>
		<cfloop list="#form.list#" index="listing">
		<cfquery name="writer2" datasource=#data.source#>
		INSERT INTO 
			ac_mtr_participant_transaction_members
		vALUES (
			#form.transact_id#,
			#listing#
		); 

		</cfquery>
		</cfloop>
		<cfset model.status=200>
		<cfset model.message="OK">
	</cfif>

<!--- GET --->
<cfelse>
	<cfif !isDefined( "url.transact_id" ) || !isDefined( "url.staffer_id" )>
		<cfset model.status=500>
		<cfset model.message="Failed to write due to missing fields 'TRANSACT_ID' or 'STAFFER_ID'">
	<cfelse>
		<cfset model.list=#url.list#>

		<cfloop list="#url.list#" index="listing">
		<cfquery name="writer2" datasource=#data.source#>
		INSERT INTO 
			ac_mtr_participant_transaction_members
		vALUES (
			<cfqueryparam value = "#url.transact_id#" CFSQLTYPE="cf_sql_int">,
			<cfqueryparam value = "#listing#" CFSQLTYPE="cf_sql_nvarchar">
		); 

		</cfquery>
		</cfloop>
		<cfset model.status=200>
		<cfset model.message="OK">

		<cfset session.iv_motrpac_transact_id = #url.transact_id#>
	</cfif>
</cfif>


<!--- Write a new list of members, this is an API resource --->
<cfquery name="writer2" datasource=#data.source#>
INSERT INTO 
	ac_mtr_participant_transaction_members
vALUES (
	<cfqueryparam value = "#url.transact_id#" CFSQLTYPE="cf_sql_int">,
	<cfqueryparam value = "#listing#" CFSQLTYPE="cf_sql_nvarchar">
); 

</cfquery>
