<!--- participant --->
<cfoutput query="part" >
<div class="participant-info">
	<h2>#part.participant_fname# #part.participant_lname#</h2>

	<h3>Patient Data</h3>
	<table class="table">
		<tbody>
			<tr>
				<td>Date of Birth</td>
				<td>-</td>
			</tr>
			<tr>
				<td>Weight</td>
				<td>#part.participant_initial_weight# lbs</td>
			</tr>
			<tr>
				<td>Height</td>
				<td>#part.participant_initial_height# in</td>
			</tr>
		</tbody>
	</table>
</div>
</cfoutput>
