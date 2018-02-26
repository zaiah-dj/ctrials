<style type="text/css">
ul.endurance li {
	text-align: center;
	width: 60px; 
	padding: 5px; 
	display: inline-block; 
	background-color: #333; 
	color: white;
	transition: background-color 0.2s, color 0.2s;
}
	
ul.endurance li:hover {
	background-color: cyan; 
	color: black; 
}	

#_cycle, #_treadmill {
	display: none;
}
</style>

<script type="text/javascript">
document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//
	var v = document.getElementById( "choose_mode" );
	v.addEventListener( "change", function (ev) {

		console.log( ev.target.value );	
		console.log( document.getElementById( "_cycle" ) ); 

		if ( ev.target.value == 1 ) 
		{
			document.getElementById( "_cycle" ).style.display = "block";
			document.getElementById( "_treadmill" ).style.display = "none";
		}
		else if ( ev.target.value == 2 )
		{
			document.getElementById( "_cycle" ).style.display = "none";
			document.getElementById( "_treadmill" ).style.display = "block";
		}
		else if ( ev.target.value == 3 )
		{
			document.getElementById( "_cycle" ).style.display = "none";
			document.getElementById( "_treadmill" ).style.display = "none";
		}
	});

});
</script>

<cfoutput>
<div class="part-div">
	<!--- Populate the exercise time range menu --->
	<cfscript>arry=[]; ii=1;for ( i = 5; i <= 60; i += 5 ) arry[ ii++ ]	= i - 4 & " - " & i;</cfscript>
	<ul class="inner-nav">
	<cfloop array=#arry# index=ind> <a href="##"><li>#ind#</li></a></cfloop>
	</ul>

	<table class="table">
		<tbody>
			<tr>
				<td>Exercise Type</td>
				<td>
				<select id="choose_mode" name="mode">
					<option value="0">Choose One</option>
					<option value="1">Cycle</option>
					<option value="2">Treadmill</option>
					<option value="3">Elliptical</option>
					<option value="4">Other</option>
				</select>
				</td>
			</tr>
		</tbody>
	</table>

	<div id="_cycle"> 
		<table class="table">
			<tbody>
				<tr>
					<td>RPM</td>
					<td>
						<input type="number" size="2" name="rpm">
					</td>
				</tr>

				<tr>
					<td>Watts or Resistance</td>
					<td>
						<input type="number" size="2" name="resistance">
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div id="_treadmill"> 
		<table class="table">
			<tbody>
				<tr>
					<td>Speed (MPH)</td>
					<td>
						<input type="number" size="2" name="speed">
					</td>
				</tr>
				<tr>
					<td>% Grade *</td>
					<td>
						<input type="number" size="2" name="grade">
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<table class="table">
		<tbody>
			<!--- Global Things --->
			<tr>
				<td>Heart Rate*</td>
				<td>
					<input type="number" size="2" name="heart_rate">
				</td>
			</tr>

			<tr>
				<td>Blood Pressure**</td>
				<td>
					<input type="number" size="2" name="sys_bp"> / <input type="number" width=2 name="sys_dp">
				</td>
			</tr>

			<tr>
				<td>Rating of Perceived Exertion***</td>
				<td>
					<input type="number" size="2" name="rating_pe">
				</td>
			</tr>

			<tr>
				<td>Other (Affect?)****</td>
				<td>
					<input type="number" size="2" name="other">
				</td>
			</tr>

			<tr>
				<td></td>
				<td>
					<input type="button" value="Reset">
					<input type="submit" value="Save">
				</td>
			</tr>

		</tbody>
	</table>
	
</div>
</cfoutput>
