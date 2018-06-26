<!--- Figure blood pressure --->
<!---<cfset checkIn.BPSystolic=#iif( checkIn.BPSystolic lt 60, 80, checkIn.BPSystolic )#>
<cfset checkIn.BPDiastolic=#iif( checkIn.BPDiastolic lt 50, 80, checkIn.BPDiastolic )#>--->
<cfset week=#sess.current.week#>
<cfset day=#sess.current.day#>
<cfset cid=#sess.current.participantId#>
<cfset prevResultsLink=link('modal-results.cfm?id=#sess.current.participantId#&all=true')>
<cfset links={}>
<cfset links.checkIn = link( 'check-in.cfm?id=#url.id#' )>
<cfset links.allPreviousResults = link('modal-results.cfm?id=#sess.current.participantId#&all=true')>

<cfoutput>
<div class="container-body">
	<form name="checkInForm" action="#links.checkIn#" method="POST">
		<table class="table">
			<tbody>
				<tr>
					<td colspan=2>
						<div style="width:50%;float:left;">
							<label class="title">Study Week</label>
							<select name="ps_week" required>
							<cfloop from=1 to=14 index = "w">
								<option #iif(sess.current.week eq w,DE("selected"),DE(""))# value=#w#>Week #w#</option>	
							</cfloop>
							</select>
						</div>	

						<div style="width:50%; float:right;">
							<label class="title">Exercise Session</label>
							<input type="hidden" name="ps_day" value="#sess.current.day#"></input>
		
							<!--- This is a link activating a modal window to see all previous results for the current participant --->
							<a class="modal-activate" href="#links.allPreviousResults#">All Previous Results</a>
							<div class="modal">
								<div class="modal-content">
									<span class="close">&times;</span>
									<p>Previous Weeks</p>
									<div id="feed">
										<cfinclude template="../app/api/display_previous.cfm">
										<cfinclude template="modal-results.cfm">
									</div>	
								</div>
							</div>

							<div id="weekSession">
								<table class="inner"> 
									<tr><cfloop list = "Mon,Tue,Wed,Thu,Fri,Sat" item = "day"><th>#day#</th></cfloop></tr>
									<tr>
									<!--- This loop generates links activating modal windows to see previous days' results within the current week --->
									<cfloop array=#checkIn.cdays# item="day">
										<td <cfif sess.current.dayName eq LCase( day )>class="selected"</cfif>>	
										<cfif not day>
											-
										<cfelse>
											<cfset day=#day#>
											<cfset links.individualResult = link('modal-results.cfm?id=#sess.current.participantId#&day=#day#&week=#sess.current.week#')>
											<a class="modal-activate" href="#links.individualResult#">See Results</a>
											<div class="modal">
												<div class="modal-content">
													<span class="close">&times;</span>
													<h3>Previous Weeks</h3>
													<div id="feed">
														<cfinclude template="../app/api/display_previous.cfm">
														<cfinclude template="modal-results.cfm">
													</div>	
												</div>
											</div>
										</cfif>
										</td>
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

					<cfif !checkIn.getNewBP>
						<span class=huge>#checkIn.BPSystolic#</span> / <span class=huge>#checkIn.BPDiastolic#</span> mmHg
						<i style="float:right;position:relative;top:8px;">(*New reading not needed for another #checkIn.BPDaysLeft# days)</i>

					<cfelse>
						<div>
						<span style="text-align: right;">
							A new blood pressure reading is required for this participant.
						</span>

						<div> 
							<div class="row">
								<div class="cc col-sm-8">
									<span style="top: -2px" class="sameline">Systolic</span>
									<input type="range" min="#checkIn.BPMinSystolic#" max="#checkIn.BPMaxSystolic#" class="slider" name="bp_systolic" value="#checkIn.BPSystolic#" required>
								</div>
								<div class="catch cc col-sm-1"><span>#checkIn.BPSystolic#</span><span> mmHg</span></div>
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
									<span style="top: -2px" class="sameline">Diastolic</span>
									<input type="range" min="#checkIn.BPMinDiastolic#" max="#checkIn.BPMaxDiastolic#" class="slider" name="bp_diastolic" value="#checkIn.BPDiastolic#" required>
								</div>
								<div class="catch cc col-sm-1"><span>#checkIn.BPDiastolic#</span><span> mmHg</span></div>
								<div class="col-sm-1">
									<button class="incrementor">+</button>
									<button class="incrementor">-</button>
								</div>
							</div>
						</div>
					</cfif>
					</td>
				</tr>

				<cfif ListContains(ENDURANCE, currentParticipant.results.randomGroupCode)>
				<tr>
					<td class="title">Target Heart Rate</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="300" class="slider" name="ps_thr" value="#checkIn.targetHR#" required>
							</div>
							<div class="catch cc col-sm-1"><span>#checkIn.targetHR#</span><span> bpm</span></div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
							<cfif checkIn.targetHR>
							<br />(*Variance allowed for currently selected heart rate is in between 
								#checkIn.targetHR - (checkIn.targetHR * 0.05)# and 
								#checkIn.targetHR + (checkIn.targetHR * 0.05)# BPM )
							</cfif>
						</div>
					</td>
				</tr>
				</cfif>

				<tr>
					<td class="title">Weight</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="300" class="slider" name="ps_weight" value="#checkIn.weight#" required>
							</div>
							<div class="catch cc col-sm-1"><span>#iif(checkIn.weight eq "",0,checkIn.weight)#</span><span> lb</span></div>
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
								<input type="radio" name="param" value="1" #iif(sess.current.exerciseParameter eq 1,DE("checked"),DE(""))# required>
								<span class="checkmark"></span>
								<br />
							</div>
							<div class="clabel">
								Treadmill
								<input type="radio" name="param" value="2"  #iif(sess.current.exerciseParameter eq 2,DE("checked"),DE(""))# required>
								<span class="checkmark"></span>
								<br />
							</div>
							<div class="clabel">
								Other
								<input type="radio" name="param" value="3"  #iif(sess.current.exerciseParameter eq 3,DE("checked"),DE(""))# required>
								<span class="checkmark"></span>
								<br />
							</div>
						<cfelse>
							<div class="clabel">
								Upper Body
								<input type="radio" name="param" value="4"  #iif(sess.current.exerciseParameter eq 4,DE("checked"),DE(""))# required>
								<br /><span class="checkmark"></span>
							</div>
							<div class="clabel">
								Lower Body
								<input type="radio" name="param" value="5" #iif(sess.current.exerciseParameter eq 5,DE("checked"),DE(""))# required>
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

		<input type="hidden" name="ps_pid" value="#sess.current.participantId#">
		<input type="submit" value="Next!"></input>
	</form>
</div> <!--- container-body --->
</cfoutput>
