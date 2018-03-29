<cfquery name="exercises" datasource=#data.source#>
SELECT et_name FROM ac_mtr_re_exercise_list
</cfquery>

<cfquery name="machines" datasource=#data.source#>
SELECT et_name FROM ac_mtr_ee_machine_list
</cfquery>

<cfquery name="fail_reasons" datasource=#data.source#>
SELECT et_name FROM ac_mtr_fail_visit_reasons
</cfquery>


<!--- Grab the blood pressure here. --->
<cfquery name="pbp" datasource=#data.source#>
SELECT * FROM 
	ac_mtr_bloodpressure
WHERE
	bp_pid = #part_list.p_pid#
</cfquery>

<!--- Get other important info --->
