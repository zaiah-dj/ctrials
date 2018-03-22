<!--- resistance.cfm --->
<cfquery name="reExList" datasource="#data.source#">
SELECT * FROM ac_mtr_re_exercise_list
</cfquery>

<cfif !isDefined( "url.extype" )>
	<cfset type = 1>
<cfelse>
	<cfset type = #url.extype#>
</cfif>

<cfquery name="reExSel" datasource="#data.source#">
SELECT * FROM ac_mtr_re_exercise_list WHERE et_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#type#">
</cfquery>

<!--- ... --->
<cfset AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
	location = link( "update.cfm" ) 
 ,querySelector = "input[ name=comp1 ], input[ name=comp2 ]" 
 ,event = "blur"
 ,callback = "input[ name=comp1 ], input[ name=comp2 ]" 
)>

<cfoutput>
	<!--- Let's see all of these in a list --->
	<ul class="inner-selection">
	<cfloop query = "#reExList#"> 
	<cfif type eq et_id> 
		<a href="#link( 'input.cfm?id=#url.id#' & '&extype=#et_id#' )#"><li class="selected">#et_name#</li></a>
	<cfelse> 
		<a href="#link( 'input.cfm?id=#url.id#' & '&extype=#et_id#' )#"><li>#et_name#</li></a>
	</cfif> 
	</cfloop>
	</ul>

	<div class="selection">
	<cfloop query = "reExSel"> 
		<table class="table table-striped participant-entry">
			<thead>
				<th>Exercise</th>
				<th>Set ##</th>
				<th>Repetitions<br /><small>(50 lb max)</small></th>
				<th>Weight Lifted<br /><small>(300 lb max)</small></th>
			</thead>

			<tbody>
				<!--- Global Things --->
				<tr>
					<td class="title" rowspan="4">#et_name#</td>
				</tr>

				<cfloop list="1,2,3" index="listy">
				<tr>
					<td>Set #listy#</td>
					<td>
						<div class="row">
							<div class="col-sm-8">
								<input type="range" min="0" max="50" class="slider" value="0" defaultvalue="0" name="#Replace( LCase( et_name ), " ", "_" )#_field">
							</div>
							<div class="catch cc col-sm-2">0</div>
						</div>
					</td>
					<td>
						<div class="row">
							<div class="col-sm-8">
								<input type="range" min="0" max="300" class="slider" value="0" defaultvalue="0">
							</div>
							<div class="catch cc col-sm-2">0</div> lb
						</div>
					</td>
				</tr>
			</cfloop>
			</tbody>
		</table>
	</cfloop>
	</div>

<!--- Real ugly front end initialization code --->
#AjaxClientInitCode#
</cfoutput>
