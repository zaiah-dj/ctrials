<!--- resistance.cfm --->
<cfscript>
//Probably will be a database... but doesn't have to
exercises = [
	"Leg Presses"
];
/*
ex = [
	"Leg Curls",
	"Leg Extensions",
	"Seated Calf",
	"Bicep Curls",
	"Tricep Presses",
	"Chest Presses",
	"Seated Rows"
];
*/
</cfscript>

<!--- ... --->
<cfset AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
	location = link( "update.cfm" ) 
 ,querySelector = "input[ name=comp1 ], input[ name=comp2 ]" 
 ,event = "blur"
 ,callback = "input[ name=comp1 ], input[ name=comp2 ]" 
)>

<cfoutput>
	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#

	<!--- Choose between 'pounds' and 'kilograms' --->
	<table class="table">
		<tr>
			<td class="title">Units</td>
			<td>
				<!--- Use a custom radio / checkbox to select either --->
				<select name="">
					<option value="0">Pounds</option>
					<option value="1">Kilograms</option>
				</select>
			</td>	
		</tr>
	</table>


	<!--- Let's see all of these in a list --->
	<ul class="inner-nav">
	<cfloop array = "#exercises#" index = "exercise">
		<li>#exercise#</li>	
	</cfloop>
	</ul>


	<cfloop array = "#exercises#" index = "exercise">
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
					<td class="title" rowspan="4">#exercise#</td>
				</tr>

				<cfloop list="1,2,3" index="listy">
				<tr>
					<td>Set #listy#</td>
					<td>
						<div class="row">
							<div class="col-sm-8">
								<input type="range" min="0" max="50" class="slider" value="0" defaultvalue="0" name="#Replace( LCase( exercise ), " ", "_" )#_field">
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
</cfoutput>