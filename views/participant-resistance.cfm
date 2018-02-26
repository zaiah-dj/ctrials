<cfoutput>
<div class="part-div">

	<!--- 
	<input type="checkbox">
	<div style="margin-bottom: 20px;">
		<h3>Choose an Exercise Type</h3>
		<select name="">
			<option value="0">Choose One</option>
			<option value="1">Leg Presses</option>
			<option value="2">Leg Curls</option>
			<option value="3">Leg Extensions</option>
			<option value="3">Seated Calf</option>
			<option value="3">Bicep Curls</option>
			<option value="3">Tricep Presses</option>
			<option value="3">Chest Presses</option>
			<option value="3">Seated Rows</option>
		</select> 
	</div>
	--->

	<!--- Choose between 'pounds' and 'kilograms' --->
	<table class="table">
		<tr>
			<td>
			Exercise Type
			</td>
			<td>
			<select name="">
				<option value="0">Choose One</option>
				<option value="1">Leg Presses</option>
				<option value="2">Leg Curls</option>
				<option value="3">Leg Extensions</option>
				<option value="3">Seated Calf</option>
				<option value="3">Bicep Curls</option>
				<option value="3">Tricep Presses</option>
				<option value="3">Chest Presses</option>
				<option value="3">Seated Rows</option>
			</select> 
			</td>
		</tr>

		<tr>
			<td>Units</td>
			<td>
				<!--- Use a custom radio / checkbox to select either --->
				<select name="">
					<option value="0">Pounds</option>
					<option value="1">Kilograms</option>
				</select>
			</td>	
		</tr>
	</table>

	<div>
		<table class="table">

			<thead>
				<th></th>
				<th>Repetitions</th>
				<th>Weight Lifted</th>
			</thead>

			<tbody>
				<!--- Global Things --->
				<tr>
					<td>Set 1</td>
					<td>
						<input type="number" size="2" name="">
					</td>
					<td>
						<input type="number" size="2" name="">
					</td>
				</tr>

				<tr>
					<td>Set 2</td>
					<td>
						<input type="number" size="2" name="">
					</td>
					<td>
						<input type="number" size="2" name="">
					</td>
				</tr>

				<tr>
					<td>Set 3</td>
					<td>
						<input type="number" size="2" name="">
					</td>
					<td>
						<input type="number" size="2" name="">
					</td>
				</tr>
			</tbody>

		</table>
	</div>

</div>
</cfoutput>
