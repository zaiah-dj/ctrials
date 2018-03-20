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
--->
	<cfscript>
	rain="";if(isDefined("form")) for ( x in form ) rain &= x & " => '" & form[x] & "'; "; 	
	</cfscript>
	<cfcontent type="application/json"><cfoutput>
		{ "status": 1, "message": "#rain#" }
	</cfoutput></cfcontent>
	<cfabort>

<!---

<cfelse>	
	<!---<cfif !StructKeyExists( form )>--->
	<cfif !isDefined( "form" )>
		<cfcontent type="application/json">
		{ "status": 0, "message": "This resource does not currently answer to request types other than POST." }
		</cfcontent>
		<cfabort>

	<cfelse>
		<cfif     #url.this# eq "log"> 
			<cfcontent type="application/json">
			{ "status": 0, "message": "Resource 'log' is not quite finished yet." }
			</cfcontent>
			<cfabort>

		<cfelseif #url.this# eq "exercise"> 
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

		<cfelseif #url.this# eq "status"> 
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
</cfif>
--->
