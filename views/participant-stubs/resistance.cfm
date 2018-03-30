<!--- resistance.cfm --->
<cfoutput>
	<!--- Show front-end initialization code --->
	<cfif data.debug eq 1>
		<cfset DebugClientCode = clijs.ClientDebug()>
	</cfif>

	<!--- Let's see all of these in a list --->
	<ul class="inner-selection">
	<cfloop query = "#reExList.results#"> 
		<a href="#link( 'input.cfm?id=#url.id#&extype=#et_id#' )#"><li #iif(type eq et_id, DE('class="selected"'),DE(''))#>#et_name#</li></a>
	</cfloop>
	</ul>

	<div class="selection">
	<cfloop query = "#reExSel.results#"> 
		<table class="table table-striped participant-entry">
			<thead>
				<th>Exercise</th> <!--- add a colspan --->
				<th>Set ##</th>
				<th>Repetitions<br /><small>(50 lb max)</small></th>
				<th>Weight Lifted<br /><small>(300 lb max)</small></th>
			</thead>

			<tbody>
				<!--- Global Things --->
				<tr>
					<td class="title" rowspan="7">#et_name#</td>
					<input type="hidden" value="1" name="el_re_extype">
				</tr>

				<cfloop list="1,2,3" index="listy">
				<tr>
					<td>Set #listy#</td>
					<td>
						<div class="row">
							<div class="col-sm-8">
								<input type="range" min="0" max="50" class="slider" value="0" defaultvalue="0" name="el_re_reps#listy#">
							</div>
							<div class="catch cc col-sm-2">0</div>
						</div>
					</td>
				</tr>

				<tr>
					<td>
						<div class="row">
							<div class="col-sm-8">
								<input type="range" min="0" max="300" class="slider" value="0" defaultvalue="0" name="el_re_weight#listy#">
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
