<!--- 
update.cfm
----------

Will try keeping all the update code here.  It's much easier to do that with the write back module.


Deserialize JSON and store values in the proper places...


Values received here will be saved to one of the following tables.

*ac_mtr_dlog          - Log of exercises done.
*ac_mtr_exercise_log  - Log of current participants exercise progress.
*ac_mtr_patientstatus - Log of patient's current health (track per day?).

--->
<!---
<cfif !StructKeyExists( form, "this" )> 
	<cfscript>
	rain="";if(isDefined("form")) for ( x in form ) rain &= x & " => '" & form[x] & "'; "; 	
	</cfscript>
	<cfcontent type="application/json"><cfoutput>
		{ "status": 1, "message": "#rain#" }
	</cfoutput></cfcontent>
	<cfabort>
--->

<cfif !isDefined( "form" ) || StructIsEmpty( form )>
	<cfcontent type="application/json">
	{ "status": 0, "message": "This resource does not currently answer to request types other than POST." }
	</cfcontent>
	<cfabort>

<cfelse>
	<cfif #form.this# eq "check-in-complete"> 
		<!--- Update the members of a group over XHR --->
		<cfscript>
		model = { status = 0, message = "", array = [], malformed_field = 0, invalid_method = 0, list = "" };

		if ( !StructKeyExists( form, "transact_id" ) || !StructKeyExists( form, "staffer_id" ) )
			model.malformed_field = 1;
		if ( !StructKeyExists( form, "list" ) )
			model.no_list = 1;
		else {
			model.id = form.transact_id;
			model.no_list = 0;
			model.list = form.list;
		}
	
	/*	
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
	*/

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


		<cfcontent type="application/json"><cfoutput>{ "status": #model.status#, "message": "New check-in session started successfully." }</cfoutput></cfcontent>
		<cfabort>


	<cfelseif #form.this# eq "log"> 
		<cfcontent type="application/json">
		{ "status": 0, "message": "Resource 'log' is not quite finished yet." }
		</cfcontent>
		<cfabort>


	<cfelseif #form.this# eq "exercise"> 
		<cfif !StructKeyExists( form, "value" )> 
			<!--- This handles INSERTing and UPDATEing the database. --->
			<cfset w = CreateObject("component", "components.writeback").Server(
				listen   = "POST"
			 ,ds       = "#data.source#"
			 ,table    = "ac_mtr_exercise_log"
			 ,using    = "SQLServer"
			 ,insertOn = '!checkFor( where = "sess_id = :sess_id", predicate = "##form.truana##" )'
			 ,insertStmt = "INSERT INTO ac_mtr_exercise_log VALUES ( '##form.truana##', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0 )"
			 ,where    = { clause = "el_sess_id = :sess_id", predicate = { sess_id = "##form.truana##" }}
			 ,only     = [ "comp1", "comp2", "dt1", "bt1" ]
			)>
		</cfif>

	<cfelseif #form.this# eq "status"> 
		<cfif !StructKeyExists( form, "value" )> 
			<!--- This handles INSERTing and UPDATEing the database. --->
			<cfset w = CreateObject("component", "components.writeback").Server(
				listen   = "POST"
			 ,ds       = "#data.source#"
			 ,table    = "ac_mtr_checkinstatus"
			 ,using    = "SQLServer"
			 ,insertOn = '!checkFor( where = "sess_id = :sess_id", predicate = "##form.truana##" )'
			 ,insertStmt = "INSERT INTO ac_mtr_checkinstatus VALUES ( 0, '##form.truana##', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0 )"
			 ,where    = { clause = "sess_id = :sess_id", predicate = { sess_id = "##form.truana##" }}
			 ,only     = [ "comp1", "comp2", "dt1", "bt1" ]
			)>
		</cfif>

	<cfelse>
		<cfcontent type="application/json">
		{ "status": 0, "message": "Invalid Resource '#url.this#' requested." }
		</cfcontent>
		<cfabort>
	</cfif>
</cfif>
