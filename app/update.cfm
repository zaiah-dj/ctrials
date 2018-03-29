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
	<cfset cc = createObject("component", "components.checkFields")>
	
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


	<cfelseif ( #form.this# eq "endurance" ) or ( #form.this# eq "resistance" )> 
		<!--- If the check fails, die --->
		<cfif cc.checkFields( form, "sess_id", "pid" ).status eq false>
			<cfcontent type="application/json">
			{ "status": 0, "message": "Resource 'update' failed for resistance/endurance updates. (Required fields 'sess_id' and 'pid' not in request.)" }
			</cfcontent>
			<cfabort>
		</cfif>
	
		<!--- Choose exercise type --->
		<cfset erType = 0>
		<cfif #form.this# eq "endurance"> 
			<cfset erType = 1>
		<cfelseif #form.this# eq "resistance"> 
			<cfset erType = 2>
		</cfif>

		<!--- Generate a random id? --->
		<cfset erId = randnum( 9 )>

		<!--- Check fail reason --->
		<cfset failReason = "">
		<cfif StructKeyExists( form, "el_failreason" )>
			<cfset failReason = "#form.el_failreason#">
		</cfif>

		<!--- Check notes --->
		<cfset notes = "">
		<cfif StructKeyExists( form, "el_notes" )>
			<cfset notes = "#form.notes#">
		</cfif>

		<cfset check=0>

		<!--- Do one more check of the fields --->
		<cfif erType eq 1>
			<!--- Check fields: --->
			<cfset check=cc.checkFields( form, 
				"sess_id", "pid", 
				"el_ee_equipment", "el_ee_timeblock", "el_ee_rpm", 
				"el_ee_watts_resistance", "el_ee_speed", "el_ee_grade", 
				"el_ee_perceived_exertion" )>

		<cfelseif erType eq 2>
			<!--- Check fields: --->
			<cfset check=cc.checkFields( form, "sess_id", "pid", 
				"el_re_set_index", 
				"el_re_equipment", 
				"el_re_reps1", "el_re_weight1"
				"el_re_reps2", "el_re_weight2"
				"el_re_reps3", "el_re_weight3"
			)>

		</cfif>

		<!--- If the check fails, die --->
		<cfif #check.status# eq false>
			<cfcontent type="application/json"><cfoutput>
			{ "status": 0, 
				"message": "Resource 'update' failed for resistance/endurance updates. - #check.message# " }
			</cfoutput></cfcontent>
			<cfabort>
		</cfif>

		<cftry>
		<!--- Create a master record 
			 ,<cfqueryparam value="#DateFormat( Now(), "YYYY-MM-DD" )#" cfsqltype="cf_sql_datetime">
		--->
		<cfquery name = "insMaster" datasource="#data.source#">
			INSERT INTO ac_mtr_exercise_log_master VALUES (
				<cfqueryparam value="#erId#" cfsqltype="cf_sql_integer">
			 ,<cfqueryparam value="#erType#" cfsqltype="cf_sql_integer">
			 ,<cfqueryparam value="#form.sess_id#" cfsqltype="cf_sql_integer">
			 ,<cfqueryparam value="#DateFormat( Now(), "YYYY-MM-DD" )#" cfsqltype="cf_sql_datetime">
			 ,<cfqueryparam value="0" cfsqltype="cf_sql_bit">
			 ,<cfqueryparam value="#failReason#" cfsqltype="cf_sql_varchar">
			 ,<cfqueryparam value="#notes#" cfsqltype="cf_sql_varchar">
			);
		</cfquery>

		<cfcatch> 
			<cfcontent type="application/json"><cfoutput>
			{ "status": 0, 
				"message": "Resource 'update' failed on insMaster. - #cfcatch.message# - #cfcatch.detail# " }
			</cfoutput></cfcontent>
			<cfabort>
		</cfcatch>
		</cftry>


		<cftry>
			<cfif erType eq 1>
				<cfquery name = "exlog" datasource="#data.source#">
					INSERT INTO ac_mtr_exercise_log_ee VALUES (
						<cfqueryparam value="#pid#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.sess_id#" cfsqltype="cf_sql_integer">

					 ,<cfqueryparam value="#form.el_ee_equipment#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_ee_timeblock#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_ee_rpm#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_ee_watts_resistance#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_ee_speed#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_ee_grade#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_ee_perceived_exertion#" cfsqltype="cf_sql_integer">

					 ,<cfqueryparam value="#DateFormat( Now(), "YYYY-MM-DD" )#" cfsqltype="cf_sql_datetime">
					);
				</cfquery>

			<cfelseif erType eq 2>
				<!--- INSERT into ac_mtr_exercise_log_re --->
				<cfquery name = "exlog" datasource="#data.source#">
					INSERT INTO ac_mtr_exercise_log_re VALUES (
						<cfqueryparam value="#pid#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.sess_id#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_re_set_index#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_re_reps#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_re_weight#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#form.el_re_equipment#" cfsqltype="cf_sql_integer">
					 ,<cfqueryparam value="#DateFormat( Now(), "YYYY-MM-DD" )#" cfsqltype="cf_sql_datetime">
					);
				</cfquery>
			</cfif>	

		<cfcatch any="e"> 
			<cfcontent type="application/json"><cfoutput>
			{ "status": 0, 
				"message": "Update failed on 'exlog': #cfcatch.message# " }
			</cfoutput></cfcontent>
			<cfabort>
		</cfcatch>
		</cftry>

		<cfcontent type="application/json"><cfoutput>
		{ "status": 1, "message": "SUCCESS" }
		</cfoutput></cfcontent>
		<cfabort>



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
