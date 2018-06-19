<cfoutput>
<div class="container-body">
	<div class="footer">
	</div>
	<form name="checkInForm" action="#link( 'check-in.cfm?id=#url.id#' )#" method="POST">
		<table class="table">
			<tbody>
				<tr>
					<td class="title">Did Patient Miss Visit?</td>
					<td>
						<select name="missedReason"> 
							<option selected value=0>No</option>	
						<cfloop query = missedReasons.results>
							<option value=#et_id#>Yes - #et_name#</option>	
						</cfloop>
						</select>
					</td>
				</tr>

				<tr>
					<td class="title">Study Week</td>
					<td>
						<cfset sc=1>
						<select name="ps_week" required>
						<cfloop from=1 to=14 index = "d">
							<cfif #currentWeek# eq #d#>
							<option selected value=#d#>Week #d#</option>	
							<cfelse>
							<option value=#d#>Week #d#</option>	
							</cfif>
						</cfloop>
						</select>
					</td>
				</tr>

				<tr>
					<td class="title">Exercise Session</td>
					<td>
						<input type="hidden" name="ps_day" value="#currentDay#"></input>
						<!---
						<button class="incrementor">See Previous Week Results</button>
						--->
						<a class="modal-activate" href="#link('modal-results.cfm?id=#currentId#&all=true')#">All Previous Results</a>
						<div class="modal">
							<div class="modal-content">
								<span class="close">&times;</span>
								<p>Previous Weeks</p>
								<div id="feed">
									<cfset week=#currentWeek#>
									<cfset day=#currentDay#>
									<cfinclude template="../app/ajax_display_previous.cfm">
									<cfinclude template="modal-results.cfm">
								</div>	
							</div>
						</div>
						<ul class="dasch">
						<cfset daynum = 1>
						<cfloop list = "Mon,Tue,Wed,Thu,Fri,Sat" item = "day">
							<li <cfif currentDayName eq LCase( day )>class="selected"</cfif>>	
								#day#
								<br />
								<cfif 0>
								<a class="modal-activate" href="#link('modal-results.cfm?id=#currentId#&day=#daynum#&week=#currentWeek#')#">See Results</a>
								</cfif>
							<div class="modal">
								<div class="modal-content">
									<span class="close">&times;</span>
									<h3>Previous Weeks</h3>
									<div id="feed">
										<cfset week=#currentWeek#>
										<cfset day=#daynum#>
										<cfinclude template="../app/ajax_display_previous.cfm">
										<cfinclude template="modal-results.cfm">
									</div>	
								</div>
							</div>
							</li>
							<cfset daynum++>
						</cfloop>
						</ul>
					</td>
				</tr>

				<tr>
					<td class="title">Next Scheduled Visit</td>
					<td>
						<input type="date" name="ps_next_sched" value="#model.nextSchedVisit#" required>
						<div>( e.g. 01/01/1991 )</div>
					</td>
				</tr>

				<tr>
					<td class="title">Blood Pressure</td>
					<td>

					<!--- Figure blood pressure --->
					<cfset sys_bp=#iif( model.currentBpSystolic lt 60, 80, model.currentBpSystolic )#>
					<cfset dia_bp=#iif( model.currentBpDiastolic lt 50, 80, model.currentBpDiastolic )#>

					<cfif !model.needsNewBp>
						<span class=huge>#sys_bp#</span> / <span class=huge>#dia_bp#</span>
						<i>(*No further readings need to be taken at this time)</i>
						<input type="hidden" value="#model.currentBpSystolic#" name="bp_systolic">
						<input type="hidden" value="#model.currentBpDiastolic#" name="bp_diastolic">

					<cfelse>
						<div>
						<span class=huge>#model.currentBpSystolic#</span> / <span class=huge>#model.currentBpDiastolic#</span>
						<span style="text-align: right;">
							A new blood pressure reading is required for this participant.
						</span>

						<div> 
							<div class="row">
								<div class="cc col-sm-8">
									<!---<span class="sameline">Systolic</span>--->
									<input type="range" min="#model.minBPS#" max="#model.maxBPS#" class="slider" name="bp_systolic" value="#sys_bp#" required>
								</div>
								<div class="catch cc col-sm-1"><span>#sys_bp#</span><span> mmHg</span></div>
								<div class="col-sm-1">
									<button class="incrementor">+</button>
									<button class="incrementor">-</button>
								</div>
							</div>
							<br />
						</div>

						<div>
							<div class="row">
								<div class="cc col-sm-8">
									<!---<span class="sameline">Diastolic</span>--->
									<input type="range" min="#model.minBPD#" max="#model.maxBPD#" class="slider" name="bp_diastolic" value="#dia_bp#" required>
								</div>
								<div class="catch cc col-sm-1"><span>#dia_bp#</span><span> mmHg</span></div>
								<div class="col-sm-1">
									<button class="incrementor">+</button>
									<button class="incrementor">-</button>
								</div>
							</div>
						</div>
					</cfif>
					</td>
				</tr>

				<tr>
					<td class="title">Target Heart Rate</td>
					<td>
						<cfif model.targetHeartRate>
						#model.targetHeartRate# BPM
						(Variance allowed between 
							#model.targetHeartRate - (model.targetHeartRate * 0.05)# and 
							#model.targetHeartRate + (model.targetHeartRate * 0.05)# BPM )
						<cfelse>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="300" class="slider" name="ps_thr" value="0" required>
							</div>
							<div class="catch cc col-sm-1"><span>0</span><span> bpm</span></div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
						</div>
						</cfif>
					</td>
				</tr>

				<tr>
					<td class="title">Weight</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="300" class="slider" name="ps_weight" value="#model.weight#" required>
							</div>
							<div class="catch cc col-sm-1"><span>#iif(model.weight eq "",0,model.weight)#</span><span> lb</span></div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
						</div>
					</td>
				</tr>

				<tr>
					<td class="title">#iif( ListContains(ENDURANCE, part_list.results.randomGroupCode), DE("Machine Selection"),DE("Exercise Selection"))#</td>
					<td>
						<cfif ListContains(ENDURANCE, part_list.results.randomGroupCode)>
							<cfloop query=#Q.machines.results#> 
							<div class="clabel">
								#et_name#<!---<label>#et_name#</label>--->
								<cfif #model.machineValue# eq "#et_name#">
								<input type="radio" name="ps_machine_value" value="#et_name#" required checked>
								<cfelse>
								<input type="radio" name="ps_machine_value" value="#et_name#" required>
								</cfif>
								<span class="checkmark"></span>
								<br />
							</div>
							</cfloop>
						<cfelse>
							<cfset el=ListToArray( ValueList( Q.exercises.results.et_name, "," ))>
							<div class="clabel">
								<cfloop from=1 to=4 index=i>#el[i]#<cfif i neq 4>, </cfif></cfloop>
								<input type="radio" name="exset" value="5" required><br />
								<span class="checkmark"></span>
							</div>
							<div class="clabel">
								<cfloop from=5 to=8 index=i>#el[i]#<cfif i neq 8>, </cfif></cfloop>
								<input type="radio" name="exset" value="6" required>
								<span class="checkmark"></span>
							</div>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="title">Participant Notes</td>
					<td>
						<button class="modal-activate">Add New Note</button>
						<div id="myModal" class="modal">
							<div class="modal-content">
								<span class="close">&times;</span>
								<p>Participant Notes</p>
								<textarea name="ps_notes"></textarea>
								<button class="inc-button" id="ps_note_save">Save</button>
							</div>	
						</div>
						<!---<textarea class="modal-activate" name="ps_notes"></textarea>--->
						<ul class="participant-notes">
						<cfloop query=pNotes.results>
							<li>#DateTimeFormat(note_datetime_added,"mm/dd/yy")# - #note_text#</li>
						</cfloop>
						</ul>
					</td>
				</tr>

			</tbody>
		</table>

		<input type="hidden" name="ps_pid" value="#currentId#">
		<input type="submit" value="Next!"></input>
	</form>
</div> <!--- container-body --->
</cfoutput>
