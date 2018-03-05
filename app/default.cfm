<!--- Let's Try the simplest possible things in the world --->
<cfquery datasource = "#data.source#" name = "part_list">
SELECT * FROM ac_mtr_participants;
</cfquery>

<cfset session.iv_motrpac_transact_id = "#randnum( 16 )#"> 
