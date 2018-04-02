<cfif part.p_exercise lt 3>
<cfoutput>
	<div class="container-body">
		<form name="checkInForm" action="#link( 'check-in-complete.cfm' )#" method="POST">
			<table class="table">
				<tbody>
					<tr>
						<td class="title">Study Week</td>
						<td>
							<cfset sc=1>
							<select name="ps_week" required>
							<cfloop from=1 to=14 index = "d">
								<option value=#d#>Week #d#</option>	
							</cfloop>
							</select>
						</td>
					</tr>

					<tr>
						<td class="title">Exercise Session</td>
						<td>
							<cfloop from=1 to=4 index = "d">
								<input type="radio" name="ps_day" value="#d#" required>Day #d#
							</cfloop>
						
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
							<input type="date" name="ps_next_sched" value="#model.nextSchedVisit#">
							<div>( e.g. 01/01/1991 )</div>
						</td>
					</tr>

					<tr>
						<td class="title">Blood Pressure</td>
						<td>
						<cfif !model.needsNewBp>
							<span class=huge>180</span> / <span class=huge>90</span>
							<i>(*No further readings need to be taken at this time)</i>
							<input type="hidden" value="#model.currentBpSystolic#" name="bp_systolic">
							<input type="hidden" value="#model.currentBpDiastolic#" name="bp_diastolic">
						<cfelse>
							<div>
							<span class=huge>#model.currentBpSystolic#</span> / <span class=huge>#model.currentBpDiastolic#</span>
							<blink>A new blood pressure reading is required for this participant.</blink>
							<div>
								<label class="sameline">Systolic</label>
								<div class="cc w200">
									<input type="range" min="90" max="180" class="slider" value="#model.currentBpSystolic#" name="bp_systolic" required>
								</div>
								<div class="cc w100">0</div>
							</div>
							</div><br />
							<div>
								<label class="sameline">Diastolic</label>
								<div class="cc w200">
									<input type="range" min="90" max="180" class="slider" value="#model.currentBpDiastolic#" name="bp_diastolic" required>
								</div>
								<div class="cc w100">0</div>
							</div>
						</cfif>
						</td>
					</tr>

					<tr>
						<td class="title">Target Heart Rate</td>
						<td>
							#model.targetHeartRate# BPM
						</td>
					</tr>

					<tr>
						<td class="title">#iif( part.p_exercise eq 1, DE("Machine Selection"),DE("Exercise Selection"))#</td>
						<td>
							<cfif part.p_exercise eq 1>
								<cfloop query=#Q.machines.results#> 
									<label>#et_name#</label>
									<input type="radio" name="machine_value" value="#et_name#" required>
									<br />
								</cfloop>
							<cfelse>
								<cfset el=ListToArray( ValueList( Q.exercises.results.et_name, "," ))>
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
