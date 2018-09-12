<cfoutput>
<div class="container-body">
	<input type="hidden" name="pid" value="#url.id#">

	<table class="table table-striped participant-entry">
		<!--- Only show if the participant is resistance based --->
		<tr>
			<td>Recovery / Stretching Completed</td>
			<td>
				<div class="clabel">
					No	
					<input type=radio name=recovery value="0" checked></input>
					<span class="checkmark"></span>
				</div>
				<div class="clabel">
					Yes	
					<input type=radio name=recovery value="1"></input>
					<span class="checkmark"></span>
				</div>
				<div class="clabel">
					Not Done	
					<input type=radio name=recovery value="2"></input>
					<span class="checkmark"></span>
				</div>
			</td>
		</tr>

		<tr>
			<td>How many breaks were taken during exercise?</td>
			<td>
				<div class="clabel">
					0
					<input type=radio name=breaksTaken value="0" checked></input>
					<span class="checkmark"></span>
				</div>
				<div class="clabel">
					1
					<input type=radio name=breaksTaken value="1"></input>
					<span class="checkmark"></span>
				</div>
				<div class="clabel">
					More than 1
					<input type=radio name=breaksTaken value=">1"></input>
					<span class="checkmark"></span>
				</div>
			</td>
		</tr>

		<tr>
			<td>Was the session stopped early?</td>
			<td>
				<div class="clabel">
					No	
					<input type=radio name=sessionStoppedEarly value="0" #iif(aborted, DE(''), DE('checked'))#></input>
					<span class="checkmark"></span>
				</div>
				<div class="clabel">
					Yes	
					<input id=sessStop type=radio name=sessionStoppedEarly value="1" #iif(aborted, DE('checked'), DE(''))#></input>
					<span class="checkmark"></span>
				</div>
			</td>
		</tr>
	<!---	
		<tr class="hiddenActivate">
			<td>Last #lastIndicator# was</td>
			<td><!---#lastExerciseName#---></td>
		</tr>
	--->	
		<tr class="hiddenActivate">
			<td>Specify reason stopped early:</td>
			<td>
				<button class="modal-activate">Add Reason</button>
				<input type=hidden id=reasonStoppedEarly name="reasonStoppedEarly"></input>
			</td>
		</tr>

		<tr class="hiddenActivate">
			<td>Record the Heart Rate, RPE and Affect here if stopped early</td>
			<td>
				<table class="innard"> 
				<tr>
					<td class="thin">HR:</td>
					<td>
						<div class="row">
							<div class="cc col-sm-7">
								<input type="range" min="70" max="220" class="slider" value="50" name="recoveryHR">
							</div>
							<div class="catch cc col-sm-1">0</div>
							<div class="col-sm-1">BPM</div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="thin">RPE:</td>
					<td>
						<div class="row">
							<div class="cc col-sm-7">
								<input type="range" min="6" max="20" class="slider" value="50" name="recoveryRPE">
							</div>
							<div class="catch cc col-sm-1">0</div>
							<div class="col-sm-1">%</div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="thin">Affect:</td>
					<td>
						<div class="row">
							<div class="cc col-sm-7">
								<input type="range" min="-5" max="5" class="slider" value="50" name="recoveryAffect">
							</div>
							<div class="catch cc col-sm-1">0</div>
							<div class="col-sm-1"></div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
						</div>
					</td>
				</tr>
				</table>
			</td>
		</tr>
		</div>
	</table>
	<div class="addl">
		<input type="hidden" name="this" value="recovery">
		<input type="hidden" name="sess_id" value="#session.ivId#">
		<input type="hidden" name="pid" value="#cs.participantId#">
		<input type="hidden" name="dayofwk" value="#session.currentDayOfWeek#">
		<input type="hidden" name="stdywk" value="#sc.week#">
		<input type="hidden" name="insBy" value="#sgid#">
	<cfif aborted>
		<input type="hidden" name="lastExercisePrefix" value="#lastExercisePrefix#">
	</cfif>
	</div>
	<input id="sendPageVals" type="submit" value="Finish!" style="width: 200px;color:white;"></input>
</div>
</cfoutput>
