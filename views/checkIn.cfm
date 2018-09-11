<cfoutput>




<div class="container-body">
	<table class="table checkin">
		<tbody>
			<tr>
				<td colspan=2>
					<div style="width:50%;float:left;">
						<label class="title">Study Week</label>
						<span class="huge">#sc.week#</span>
					</div>	
					<div style="width:50%;float:right;">
						<label class="title">Selected Day</label>
						<span class="huge">#sc.dayName#</span>
						<input name="scDay" type="hidden" value="#sc.day#">
					</div>	
				</td>
			</tr>

			<tr>
				<td class="title">Resting Blood Pressure</td>
				<td>#sc.BPSystolic# / #sc.BPDiastolic# mmHg</td>
			</tr>

		<cfif isEnd>
			<tr>
				<td class="title">Target Heart Rate</td>
				<td>#sc.hr1# - #sc.hr2#  bpm</td>
			</tr>
		</cfif>

			<tr>
				<td class="title">Weight</td>
				<td>#iif(sc.weight eq "",0,sc.weight)# lb</td>
			</tr>

			<cfif ListContains(const.ENDURANCE, currentParticipant.results.randomGroupCode)>
			<tr>
				<td class="title">Machine Selection</td>
				<td>
					<cfif sc.exerciseParameter eq 1>
						Cycle
					<cfelseif sc.exerciseParameter eq 2>
						Treadmill
					<cfelseif sc.exerciseParameter eq 3>
						Other
					</cfif>
				</td>
			</tr>

			<!--- Resistance --->
			<cfelseif ListContains(const.RESISTANCE, currentParticipant.results.randomGroupCode)>
			<tr>
				<td class="title">Exercise Selection</td>
				<td>
					<cfif sc.exerciseParameter eq 1>
						Hips, Thighs / Back, Biceps
					<cfelseif sc.exerciseParameter eq 2>
						Chest, shoulders, triceps, abdominals, calves	
					</cfif>
				</td>
			</tr>
			</cfif>

			<tr>
				<td class="title">Participant Notes</td>
				<td class="notes">
					<button class="modal-activate">Add New Note</button>
					<a class="view_more" href="/">View More</a>
					<ul class="participant-notes">
						<div></div>
					<cfloop query=cp.notes>
						<li>#DateTimeFormat(noteDate, "mm/dd/yy")# - #noteText#</li>
					</cfloop>
					</ul>
				</td>
			</tr>

		</tbody>
	</table>

	<input type="hidden" name="ps_pid" value="#cs.participantId#">
	<input type="hidden" name="ps_sid" value="#session.userguid#">
</div> <!--- container-body --->
</cfoutput>
