<cfif part.participant_exercise lt 3>

<cfscript>
/*
fields = [
	{ name = "Study Week", type = "drop", eval = "<cfloop from=1 to=4 index=d><option value=#d#>Day #d#</option></cfloop>" }
, { name = "Exercise Session", type =   
];
*/
</cfscript>

<cfoutput>
	<div class="container-body">
		<style type="text/css">
		.cc { display: inline-block;}
		.w200 { width: 20%; }
		.w100 { width: 10%; }
		.w050 { width: 10%; }
		</style>

		<form name="checkInForm" action="#link( 'check-in-complete.cfm' )#" method="POST">
		<table class="table">
			<tbody>

				<tr>
					<td class="title">Study Week</td>
					<td>
						<cfset sc=1>
						<select name="ps_day">
						<cfloop from=1 to=4 index = "d">
							<option value=#d#>Day #d#</option>	
						</cfloop>
						</select>
					</td>
				</tr>

				<tr>
					<td class="title">Exercise Session</td>
					<td>
						<cfset sc=1>
						<cfset today = LCase( DateTimeFormat( Now(), "EEE" ))>
						<ul class="dasch">
						<cfloop list = "Mon,Tue,Wed,Thu,Fri,Sat" item = "day">
							<cfif today eq LCase( day )>
							<li class="selected">#day#</li>	
							<cfelse>
							<li>#day#</li>	
							</cfif>
						</cfloop>
						</ul>
					</td>
				</tr>

				<tr>
					<td class="title">Next Scheduled Visit</td>
					<td>
						<input type="date" name="ps_next_sched">
						<div>( e.g. 01/01/1991 )</div>
					</td>
				</tr>

				<tr>
					<td class="title">Blood Pressure</td>
					<td>
						<span class=huge>180</span> / <span class=huge>90</span>
						<i>(*No further readings need to be taken at this time)</i>
						<div>
						<div>
							<label class="sameline">Systolic</label>
							<div class="cc w200">
								<input type="range" min="90" max="180" class="slider" value="0" name="sys">
							</div>
							<div class="cc w100">0</div>
						</div>
						</div><br />
						<div>
							<label class="sameline">Diastolic</label>
							<div class="cc w200">
								<input type="range" min="90" max="180" class="slider" value="0" name="dia">
							</div>
							<div class="cc w100">0</div>
						</div>
					</td>
				</tr>

				<tr>
					<td class="title">Weight</td>
					<td>
						<span class=huge>180</span> lbs 
						<div class="cc w200">
							<input type="range" min="50" max="300" class="slider" value="0" name="ps_weight">
						</div>
						<div class="cc w100">0</div>
					</td>
				</tr>

				<tr>
					<td class="title">Heart Rate</td>
					<td>
						<div class="cc w050">
							<span class=huge>180</span>
						</div>
						<div class="cc w200">
							<input type="range" min="90" max="180" class="slider" value="0" name="heart_rate_min">
						</div>
						<div class="cc w100">0</div>
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
							<cfset el=ListToArray( ValueList( exercises.et_name, "," ))>
							<ul>
								<li>
									<label><cfloop from=1 to=4 index=i>#el[i]#<cfif i neq 4>, </cfif></cfloop></label>
									<input type="radio" name="exset" value="5"><br />
								</li>
								<li>
									<label><cfloop from=5 to=8 index=i>#el[i]#<cfif i neq 8>, </cfif></cfloop></label>
									<input type="radio" name="exset" value="6">
								</li>
							</ul>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="title">Participant Notes</td>
					<td>
						<textarea name="ps_notes"></textarea>
					</td>
				</tr>

			</tbody>
		</table>

		<input type="hidden" name="ps_pid" value="#url.id#">
		<input type="submit" value="Next!"></input>
		</form>
	</div>
</cfoutput>
</cfif>
