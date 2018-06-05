
<div class="container-body">

<table class="table table-striped participant-entry">
	<!--- Only show if the participant is resistance based --->
	<tr>
		<td>Recovery / Stretching Completed</td>
		<td>
			<div class="clabel">
				Yes	
				<input type=radio name=recovery value="0"></input>
				<span class="checkmark"></span>
			</div>
			<div class="clabel">
				No	
				<input type=radio name=recovery value="1"></input>
				<span class="checkmark"></span>
			</div>
			<div class="clabel">
				Not Done	
				<input type=radio name=recovery value="1"></input>
				<span class="checkmark"></span>
			</div>
		</td>
	</tr>

	<tr>
		<td>How many breaks were taken during exercise?</td>
		<td>
			<div class="clabel">
				0
				<input type=radio name=breaksTaken value="0"></input>
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

	<cfif part_list.results.randomGroupCode eq ENDURANCE>
	<tr>
		<td>Was the session stopped early?</td>
		<td>
			<div class="clabel">
				0
				<input type=radio name=breaksTaken value="0"></input>
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
		<td>Specify reason stopped early:</td>
		<td>
			<textarea name=reasonStoppedEarly></textarea>
		</td>
	</tr>
	<tr>
		<td>Record the Heart Rate, RPE and Affect here if stopped early</td>
		<td>
			<tr>
				<td>HR:</td>
				<td>
					<input type=text name=hrStoppedEarly></input>
				</td>
			</tr>
			<tr>
				<td>RPE:</td>
				<td>
					<input type=text name=rpeStoppedEarly></input>
				</td>
			</tr>
			<tr>
				<td>Affect:</td>
				<td>
					<input type=text name=affectStoppedEarly></input>
				</td>
			</tr>
		</td>
	</tr>
	</cfif>
</table>

	<input id="sendPageVals" type="submit" value="Finish!" style="width: 200px;color:white;"></input>
</div>
