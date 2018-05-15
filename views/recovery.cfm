
<div class="container-body">

<table class="table table-striped participant-entry">
	<!--- Only show if the participant is resistance based --->
	<tr>
		<td>Recovery / Stretching Completed</td>
		<td>
			Y <input type=radio name=recovery value="0"></input><br />
			N<input type=radio name=recovery value="1"></input><br />
			Not Done<input type=radio name=recovery value=">1"></input>
		</td>
	</tr>

	<tr>
		<td>How many breaks were taken during exercise?</td>
		<td>
			0<input type=radio name=breaksTaken value="0"></input><br />
			1<input type=radio name=breaksTaken value="1"></input><br />
			>1<input type=radio name=breaksTaken value=">1"></input>
		</td>
	</tr>

</table>

	<input id="sendPageVals" type="submit" value="Finish!" style="width: 200px;color:white;"></input>
</div>
