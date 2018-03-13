<link rel="stylesheet" type="text/css" href="#link( 'assets/css/mobileSelect.css' )#">
<script src="#link( 'assets/js/mobileSelect.js' )#" type="text/javascript"></script>

<cfif part.participant_exercise lt 3>
<cfscript>
	values = [
/*
	//Cycle only
	 { label = "",           uom = "",    min = 5, max = 80, def = 0, step = 2, name = "rpm" }
	,{ label = "Watts/Resistance", 
															uom = "",    min = 0, max = 80, def = 0, step = 1, name = "resistance" }
	//Treadmill only
	,{ label = "Speed",         uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
	,{ label = "Percent Grade", uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
*/
	//All others
	{ label = ( #part.participant_exercise# eq 1 ) ? "Machine Selection" : "Exercise Selection",
		 uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
	];
/*
exercises = [
	"Leg Presses",
	"Leg Curls",
	"Leg Extensions",
	"Seated Calf",
	"Bicep Curls",
	"Tricep Presses",
	"Chest Presses",
	"Seated Rows"
];

machines = [
	"cycle",
	"treadmill",
	"other"
];
	//...
	fail_reasons = [
		"Illness/Health Problems",
		"Transportation Difficulties",
		"Cognitive difficulties",
		"In Nursing Home/Long-Term Care Facility",
		"Too Busy; Time and/or Work Conflict",
		"Caregiver Responsibilities",
		"Physician's Advice",
		"Problems with Muscles/Joints",
		"Forgot Appointment",
		"Moved out of area",
		"Traveling/On Vacation",
		"Personal Problems",
		"Unable to Contact/Locate",
		"Refused to Give Reason",
		"Withdrew from Study",
		"Withdrew Informed Consent",
		"Dissatisfied with Study",
		"Deceased",
		"Center Closed",
		"Other",
		"Unknown"
	];
*/
</cfscript>


<cfoutput>
<div class="part-div">

	<table class="table">
		<tbody>

			<tr>
				<td class="title">Study Week</td>
				<td>
					<cfset sc=1>
					<ul class="dasch">
					<cfloop from = 1 to=4 index = "reason">
						<li>Day #reason#</li>	
					</cfloop>
					</ul>
				</td>
			</tr>

			<tr>
				<td class="title">Exercise Session</td>
				<td>
					<cfset sc=1>
					<ul class="dasch">
					<cfloop list = "Mon,Tue,Wed,Thu,Fri,Sat,Sun" item = "day">
						<li>#day#</li>	
					</cfloop>
					</ul>
				</td>
			</tr>

			<tr>
				<td class="title">Next Scheduled Visit</td>
				<td>
					<input type="date" name="next_scheduled_visit">
					<div>01/01/1991</div>
				</td>
			</tr>

			<tr>
				<td class="title">Patient Could Not Continue</td>
				<td>
					<cfset sc=1>
					<select name="fail_reason">
						<option value="0">Choose a Reason</option>	
					<cfloop query = "fail_reasons"> 
						<option value="#sc++#">#et_name#</option>	
					</cfloop>
					</select>
				</td>
			</tr>

			<tr>
				<td class="title">Blood Pressure</td>
				<td>
					<input type="numeric" name="systolic_bp"> / 
					<input type="numeric" name="diastolic_bp">
					<div>
						Populate text here letting staff know if they need to take new BP or not.
					</div>
				</td>
			</tr>

			<tr>
				<td class="title">Heart Rate</td>
				<td>
					<input type="numeric" name="heart_rate_min"> to
					<input type="numeric" name="heart_rate_max"> BPM
				</td>
			</tr>

			<tr>
				<td class="title">#iif( part.participant_exercise eq 1, DE("Machine Selection"),DE("Exercise Selection"))#</td>
				<td>
					<cfif part.participant_exercise eq 1>
						<cfloop query=machines> 
							<label>#et_name#</label>
							<input type="radio" name="machine_value" value="#et_name#">
							<br />
						</cfloop>
					<cfelse>
						<ul>
						<cfloop query=exercises>
							<li><label>#et_name#</label>
							<input type="checkbox" value="#et_name#"></li>
						</cfloop>
						</ul>
					</cfif>
					</ul>
				</td>
			</tr>

		</tbody>
	</table>

</div>
</cfoutput>
</cfif>
