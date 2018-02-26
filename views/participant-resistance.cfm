<style type="text/css">
/* **************************************** *
 * **************************************** *
 * **************************************** *
   SLIDER 

 * **************************************** *
 * **************************************** *
 * **************************************** */

/*Slider*/
.slidecontainer {
    width: 100%; /* Width of the outside container */
}

/* The slider itself */
.slider {
    -webkit-appearance: none;  /* Override default CSS styles */
    appearance: none;
    width: 100%; /* Full-width */
    height: 25px; /* Specified height */
    background: #d3d3d3; /* Grey background */
    outline: none; /* Remove outline */
    opacity: 0.7; /* Set transparency (for mouse-over effects on hover) */
    -webkit-transition: .2s; /* 0.2 seconds transition on hover */
    transition: opacity .2s;
}

/* Mouse-over effects */
.slider:hover {
    opacity: 1; /* Fully shown on mouse-over */
}

/* The slider handle (use -webkit- (Chrome, Opera, Safari, Edge) and -moz- (Firefox) to override default look) */ 
.slider::-webkit-slider-thumb {
    -webkit-appearance: none; /* Override default look */
    appearance: none;
    width: 25px; /* Set a specific slider handle width */
    height: 25px; /* Slider handle height */
    background: #4CAF50; /* Green background */
    cursor: pointer; /* Cursor on hover */
}

.slider::-moz-range-thumb {
    width: 25px; /* Set a specific slider handle width */
    height: 25px; /* Slider handle height */
    background: #4CAF50; /* Green background */
    cursor: pointer; /* Cursor on hover */
}

.cc {
	display: inline-block;
	font-size: 1.3em;
	border: 2px solid green;
}

.catch {
	margin-left: 10px;
	margin-right: 5px;
	width: 50px;
}

.journ {
	border: 2px solid black;
}

ul.inner-nav li {
	width: auto;
	padding: 10px;
}
</style>


<script type="text/javascript">
//Add all controls
document.addEventListener( "DOMContentLoaded", function (ev)
{
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
	console.log( a ); 
});
</script>


<cfoutput>
<div class="part-div">

	<!--- Choose between 'pounds' and 'kilograms' --->
	<table class="table">
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


	<cfscript>
	//Probably will be a database... but doesn't have to
	exercises = [
		"Leg Presses",
		"Leg Curls",
		"Leg Extensions",
		"Seated Calf",
		"Bicep Curls",
		"Tricep Presses",
		"Chest Presses",
		"Seated Rows"
	];
	</cfscript>

	<ul class="inner-nav">
	<cfloop array = "#exercises#" index = "exercise">
		<li>#exercise#</li>	
	</cfloop>
	</ul>

	<cfloop array = "#exercises#" index = "exercise">
		<table class="table table-striped participant-entry">
			<thead>
				<th>Exercise</th>
				<th>Set ##</th>
				<th>Repetitions<br /><small>(50 lb max)</small></th>
				<th>Weight Lifted<br /><small>(300 lb max)</small></th>
			</thead>

			<tbody>
				<!--- Global Things --->
				<tr>
					<td rowspan="4">#exercise#</td>
				</tr>

				<cfloop list="1,2,3" index="listy">
				<tr>
					<td>Set #listy#</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="50" class="slider" value="0" defaultvalue="0" name="#Replace( LCase( exercise ), " ", "_" )#_field">
							</div>
							<div class="catch cc col-sm-2">0</div>
						</div>
					</td>

					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="0" max="300" class="slider" value="0" defaultvalue="0">
							</div>
							<div class="catch cc col-sm-2">0</div> lb
						</div>
					</td>
				</tr>
			</cfloop>
			</tbody>
		</table>
	</cfloop>

</div>
</cfoutput>
