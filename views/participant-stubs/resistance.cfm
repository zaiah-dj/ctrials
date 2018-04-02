<!--- resistance.cfm --->
<cfoutput>
	<!--- Show front-end initialization code --->
	<cfif data.debug eq 1>
		<cfset DebugClientCode = clijs.ClientDebug()>
	</cfif>

	<!--- Let's see all of these in a list --->
	<ul class="inner-selection">
	<cfset cnt=0>
	<cfloop query = "#reExList.results#"> 
		<a href="#link( 'input.cfm?id=#url.id#&extype=#et_id#' )#"><li #iif(type eq et_id, DE('class="selected"'),DE(''))#>#et_name#</li></a>
		<cfif ++cnt eq 4>
			<br />
		</cfif> 
	</cfloop>
	</ul>

	<div class="selection">
		<table class="table table-striped participant-entry">
	<cfloop array="#values#" index="vv">
		<cfif #vv.label# neq "">
		<tr class="heading"><td><b>#vv.label#</b></td></tr>
		</cfif>
		<tr>
			<td>
				<div class="row">
					<div class="col-sm-7">
						<input type="range" min="#vv.min#" max="#vv.max#" class="slider" value="#vv.def#" defaultvalue="0" name="#vv.name#" step="#vv.step#">
					</div>
					<div class="catch cc col-sm-2">#vv.def#</div>
					<div class="col-sm-1">#vv.uom#</div>
				</div>
			</td>
		</tr>
		<cfif #vv.label# eq "">
		<tr></tr>	
		</cfif>
	</cfloop> 
		</table>
	</div>
<!---
		<tr>
			<td>
				<div class="row">
					<div class="col-sm-8">
						<input type="range" step="5" min="10" max="200" class="slider" value="0" defaultvalue="10" name="el_re_weight#listy#">
					</div>
					<div class="catch cc col-sm-2">0</div> lb
				</div>
			</td>
		</tr>
--->
<!---
		</cfloop> 
	</cfloop> 
--->
<!---
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
	--->

<!--- Real ugly front end initialization code --->
#AjaxClientInitCode#
</cfoutput>
