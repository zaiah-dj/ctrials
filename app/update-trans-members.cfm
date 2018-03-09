<!--- Update the members of a group over XHR --->
<cfscript>
model = {};
model.status = 0;
model.message = "";
model.array = [];
model.malformed_field = 0;
model.invalid_method = 0;
model.list = "";

//Check POST first
if ( !StructIsEmpty( form ) ) {
	if ( !StructKeyExists( form, "transact_id" ) || !StructKeyExists( form, "staffer_id" ) )
		model.malformed_field = 1;
	if ( !StructKeyExists( form, "list" ) )
		model.no_list = 1;
	else {
		model.id = form.transact_id;
		model.no_list = 0;
		model.list = form.list;
	}
}
//Then GET
else if ( !StructIsEmpty( url ) ) {
	if ( !StructKeyExists( url, "transact_id" ) || !StructKeyExists( url, "staffer_id" ) )
		model.malformed_field = 1;
	if ( !StructKeyExists( url, "list" ) ) 
		model.no_list = 1;
	else {
		model.id = url.transact_id;
		model.no_list = 0;
		model.list = url.list;
	}
}
else {
	model.invalid_method = 1;
}


if ( model.invalid_method ) {
	model.status = 500;
	model.message = "Invalid method requested.";
	model.listing = "";
}
else if ( model.no_list ) {
	model.status = 500;
	model.message = "No list of members specified.  Can't update participant list.";
	model.listing = "";
}
else if ( model.malformed_field ) {
	model.status = 500;
	model.message = "Failed to write due to missing fields 'TRANSACT_ID' or 'STAFFER_ID'";
	model.listing = "";
}
else {
	model.status = 200;
	model.message = "OK";
	model.listing = list;
}
</cfscript>


<cfif model.status eq 200>
	<!--- Write all the model.list to database --->
	<cfloop list="#model.list#" index="listing">
	<cfquery name="writer2" datasource=#data.source#>
	INSERT INTO 
		ac_mtr_participant_transaction_members
	vALUES (
		<cfqueryparam value = "#model.id#" CFSQLTYPE="cf_sql_int">,
		<cfqueryparam value = "#listing#" CFSQLTYPE="cf_sql_nvarchar">
	); 

	</cfquery>
	</cfloop>
</cfif>
