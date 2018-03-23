<!--- save check-in data --->
<cfdump var = #session#>
<cfdump var = #form#>
<cfset sess_id = #session.iv_motrpac_transact_id#>

<cfquery name="updateT" datasource=#data.source#>
INSERT INTO 
	ac_mtr_checkinstatus
VALUES (
	<cfqueryparam value="#sess_id#" cfsqltype='cf_sql_varchar'>
	,1
	<cfqueryparam value="#form.weight#" cfsqltype='cf_sql_integer'>
	<cfqueryparam value="#form.recday#" cfsqltype='cf_sql_integer'>
	<cfqueryparam value="#form.next_scheduled_visit#" cfsqltype='cf_sql_datetime'>
	<cfqueryparam value="#DateTimeFormat( Now(), "YYYY-MM-DD" )#" cfsqltype='cf_sql_datetime'>
	<cfqueryparam value="#form.assessment_notes#" cfsqltype='cf_sql_varchar'>
);
</cfquery>

<cfabort>
<cfset w = CreateObject("component", "components.writeback").Server(
	listen   = "POST"
 ,ds       = "#data.source#"
 ,table    = "ac_mtr_checkinstatus"
 ,using    = "SQLServer"
 ,insertOn = '!checkFor( where = "sess_id = :sess_id", predicate = "##form.truana##" )'
 ,insertStmt = "INSERT INTO ac_mtr_checkinstatus VALUES ( '##form.truana##', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0 )"
 ,where    = { clause = "el_sess_id = :sess_id", predicate = { sess_id = "##form.truana##" }}
 ,only     = [ "comp1", "comp2", "dt1", "bt1" ]
)>
