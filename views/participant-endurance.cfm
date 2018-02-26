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

textarea.width {
	width: 100%;
	height: 150px;
	font-size: 1.2em;
}
</style>


<script type="text/javascript">
//Add all controls
document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//********************************************************** 
	//******      CONTROL SLIDERS                        *******
	//********************************************************** 
	//var a = Array.prototype.slice.call( document.querySelectorAll( "table.participant-entry" ) );
	var a = Array.prototype.slice.call( document.querySelectorAll( "input[ type=range ]" ) );
	for ( ii=0; ii<a.length; ii++ ) {
		//Get that nice slider effect going
		a[ii].addEventListener( "input", function (ev) {
			ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
		} );

		//This allows this to fire and save when the user is done
		a[ii].addEventListener( "change", function (ev) {
			//ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
		} );
	}
	//console.log( a ); 


	//********************************************************** 
	//******      CONTROL EXERCISE DETAILS               *******
	//********************************************************** 
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
						<!---
							<input type="number" size="2" name="rpm">
						--->
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="5" max="80" class="slider" value="0" defaultvalue="0" name="rpm">
							</div>
							<div class="catch cc col-sm-2">0</div> MPH 
						</div>
					</td>
				</tr>

				<tr>
					<td>Watts or Resistance</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="80" class="slider" value="0" defaultvalue="0" name="resistance">
							</div>
							<div class="catch cc col-sm-2">0</div> Units of Resistance 
						</div>
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
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="80" class="slider" value="0" defaultvalue="0" name="speed">
							</div>
							<div class="catch cc col-sm-2">0</div> MPH 
						</div>
					</td>
				</tr>
				<tr>
					<td>% Grade *</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="1" max="100" class="slider" value="0" defaultvalue="0" name="grade">
							</div>
							<div class="catch cc col-sm-2">0</div> % 
						</div>
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
					<div class="row">
						<div class="cc col-sm-8">
							<input type="range" min="30" max="200" class="slider" value="0" defaultvalue="0" name="heart_rate">
						</div>
						<div class="catch cc col-sm-2">0</div> BPM
					</div>
				</td>
			</tr>

			<tr>
				<td>Blood Pressure**</td>
				<td>
					<!--- 10 / 23 bp --->
					<div class="row">
						<div class="cc col-sm-4">
							<!---	
							<input type="range" min="12" max="120" class="slider" value="0" defaultvalue="0" name="sys_bp">
							--->
							<input type="number" min="12" max="120" class="slider" value="0" defaultvalue="0" name="sys_bp">
						</div>
						<div class="catch cc col-sm-1">/</div>
						<div class="cc col-sm-4">
							<!---	
							<input type="range" min="12" max="120" class="slider" value="0" defaultvalue="0" name="dia_bp">
							--->
							<input type="number" min="12" max="120" class="slider" value="0" defaultvalue="0" name="dia_bp">
						</div>
						<div class="catch cc col-sm-2">0</div>
					</div>
				</td>
			</tr>

			<tr>
				<td>Rating of Perceived Exertion***</td>
				<td>
					<!--- Agree on a number system? --->
					<div class="row">
						<div class="cc col-sm-8">
							<input type="range" min="1" max="5" class="slider" value="0" defaultvalue="0" name="ex_rating">
						</div>
						<div class="catch cc col-sm-2">0</div>
					</div>
					<br />
	
					<!--- Modal should pop up on click / touch, but the value should show up here --->
					<textarea class="width" name="rating_pe_textarea"></textarea>
					
				</td>
			</tr>

			<tr>
				<td>Other (Affect?)****</td>
				<td>

					<!--- Modal should pop up on click / touch, but the value should show up here --->
					<textarea class="width" name="other_textarea"></textarea>
					
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
