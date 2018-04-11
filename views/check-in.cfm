<cfif part.p_exercise lt 3>
<cfoutput>
	<div class="container-body">
	<div class="footer">
	</div>
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
						<!---
							<cfloop from=1 to=4 index = "d">
								<input type="radio" name="ps_day" value="#d#" required>Day #d#
							</cfloop>
							--->
						
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

						<!--- Figure blood pressure --->
						<cfset sys_bp=#iif( model.currentBpSystolic lt 60, 60, model.currentBpSystolic )#>
						<cfset dia_bp=#iif( model.currentBpDiastolic lt 60, 60, model.currentBpDiastolic )#>

						<cfif !model.needsNewBp>
							<span class=huge>#sys_bp#</span> / <span class=huge>#dia_bp#</span>
							<i>(*No further readings need to be taken at this time)</i>
							<input type="hidden" value="#model.currentBpSystolic#" name="bp_systolic">
							<input type="hidden" value="#model.currentBpDiastolic#" name="bp_diastolic">

						<cfelse>
							<div>
							<span class=huge>#model.currentBpSystolic#</span> / <span class=huge>#model.currentBpDiastolic#</span>
							<blink>A new blood pressure reading is required for this participant.</blink>

							<div> 
								<label class="sameline">Systolic</label>
								<div class="row">
									<div class="cc col-sm-7">
										<input type="range" min="60" max="300" class="slider" value="#sys_bp#" name="bp_systolic" required>
									</div>
									<div class="catch cc col-sm-1">#sys_bp#</div>
									<div class="col-sm-1">
										<button class="inc-button">+</button>
										<button class="inc-button">-</button>
									</div>
								</div>
							</div>

							<div>
								<label class="sameline">Diastolic</label>
								<div class="row">
									<div class="cc col-sm-7">
										<input type="range" min="60" max="300" class="slider" value="#dia_bp#" name="bp_diastolic" required>
									</div>
									<div class="catch cc col-sm-1">#dia_bp#</div>
									<div class="col-sm-1">
										<button class="inc-button">+</button>
										<button class="inc-button">-</button>
									</div>
								</div>
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
								<div class="clabel">
									#et_name#<!---<label>#et_name#</label>--->
									<input type="radio" name="machine_value" value="#et_name#" required>
									<span class="checkmark"></span>
									<br />
								</div>
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
	</div> <!--- container-body --->
	</div>
</cfoutput>
</cfif>
