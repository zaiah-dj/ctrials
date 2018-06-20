<cfoutput>
<div class="container-body">
	<form name="checkInForm" action="#link( 'check-in.cfm?id=#url.id#' )#" method="POST">
		<table class="table">
			<tbody>
				<tr>
					<td colspan=2>
						<div style="width:50%;float:left;">
							<label class="title">Study Week</label>
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
						</div>	

						<div style="width:50%; float:right;">
							<label class="title">Exercise Session</label>
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

							<cfset daynum = 1>
							<div id="weekSession">
								<table class="inner"> 
									<tr><cfloop list = "Mon,Tue,Wed,Thu,Fri,Sat" item = "day"><th>#day#</th></cfloop></tr>
									<tr>
									<cfloop list = "Mon,Tue,Wed,Thu,Fri,Sat" item = "day">
										<td <cfif currentDayName eq LCase( day )>class="selected"</cfif>>	
											<cfif 0>
											<a class="modal-activate" href="#link('modal-results.cfm?id=#currentId#&day=#daynum#&week=#currentWeek#')#">See Results</a>
											<cfelse> -
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
										</td>
										<cfset daynum++>
									</cfloop>
									</tr>
								</table>
							</div>	
						</div>
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
					<td class="title">
					<cfif ListContains(ENDURANCE, currentParticipant.results.randomGroupCode)>
						Machine Selection
					<cfelse>
						Exercise Selection
					</cfif>
					</td>
					<td>
						<cfif ListContains(ENDURANCE, currentParticipant.results.randomGroupCode)>
							<div class="clabel">
								Cycle
								<input type="radio" name="param" value="1" required>
								<span class="checkmark"></span>
								<br />
							</div>
							<div class="clabel">
								Treadmill<!---<label>#et_name#</label>--->
								<input type="radio" name="param" value="2" required>
								<span class="checkmark"></span>
								<br />
							</div>
							<div class="clabel">
								Other<!---<label>#et_name#</label>--->
								<input type="radio" name="param" value="3" required>
								<span class="checkmark"></span>
								<br />
							</div>
						<cfelse>
							<cfset el=ListToArray( ValueList( Q.exercises.results.et_name, "," ))>
							<div class="clabel">
								Upper Body
<!---								<cfloop from=1 to=4 index=i>#el[i]#<cfif i neq 4>, </cfif></cfloop> --->
								<input type="radio" name="param" value="4" required><br />
								<span class="checkmark"></span>
							</div>
							<div class="clabel">
								Lower Body
<!---								<cfloop from=5 to=8 index=i>#el[i]#<cfif i neq 8>, </cfif></cfloop> --->
								<input type="radio" name="param" value="5" required>
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
