<cfquery name="exercises" datasource=#data.source#>
SELECT et_name FROM ac_mtr_re_exercise_list
</cfquery>

<cfquery name="machines" datasource=#data.source#>
SELECT et_name FROM ac_mtr_ee_machine_list
</cfquery>

<cfquery name="fail_reasons" datasource=#data.source#>
SELECT et_name FROM ac_mtr_fail_visit_reasons
</cfquery>
