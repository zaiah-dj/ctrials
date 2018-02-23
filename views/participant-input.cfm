<style type="text/css">
ul.participant-info-nav li {
	display: inline-block; width: 200px;	
	text-align: center;
	transition: 
		background-color 0.2s,
		color 0.2s;
	;
}

ul.participant-info-nav li:hover {
	background-color: green;	
	color: white;	
}


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




/* **************************************** *
 * **************************************** *
 * **************************************** *
   MODAL 

 * **************************************** *
 * **************************************** *
 * **************************************** */

/* The Modal (background) */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content/Box */
.modal-content {
    background-color: #fefefe;
    margin: 15% auto; /* 15% from the top and centered */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button */
.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

/* **************************************** *
 * **************************************** *
 * **************************************** *
   BAR 

 * **************************************** *
 * **************************************** *
 * **************************************** */
.barOuter {
    width: 100%;
    background-color: #aaa;
}

.barInner {
    width: 1%;
    height: 30px;
    background-color: green;
}

/* **************************************** *
 * **************************************** *
 * **************************************** *
   MODAL FORM 

 * **************************************** *
 * **************************************** *
 * **************************************** */
.modal-content textarea
{
	width: 100%;
	height: 200px;
	font-size: 1.2em;
}
</style>

<script type="text/javascript">
document.addEventListener( "DOMContentLoaded", function (ev) {
// Get the modal
var modal = document.getElementById('myModal');

// Get the button that opens the modal
var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks on the button, open the modal 
btn.onclick = function() {
    modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
    modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
});
</script>

<!---
<cfset EXTYPE = 0> <!--- Control --->
<cfset EXTYPE = 1> <!--- EE --->
<cfset EXTYPE = 2> <!--- RE --->
--->
<cfset EXTYPE = 3> <!--- Test of all types --->

<cfoutput>
<table class="table">
	<tr>
		<td>Today''s Date</td>
		<td>#DateFormat( Now())#</td>
	</tr>

	<tr>
		<td>Exercise Type</td>

	<cfif EXTYPE eq 0>
		<td>Control</td>
	</tr>

	<cfelseif EXTYPE eq 1>
		<td>Endurance</td>
	</tr>

	<cfelseif EXTYPE eq 2>
		<td>Resistance</td>
	</tr>

	<tr>
		<td>Slider Value</td>
		<td>
			<input id="ex1" data-slider-id='ex1Slider' type="text" data-slider-min="0" data-slider-max="20" data-slider-step="1" data-slider-value="14"/>
		</td>
	</tr>

<!---
--->
	<cfelseif EXTYPE eq 3>
		<td>Nothing at all.</td>
	</tr>

	<tr>
		<td>HTML5 Slider Value</td>
		<td>
			<!---
			min = 0  ; minimum value
			max = 0  ; maximum value
			val = 10 ; default value
				--->
			<input type="range" min="0" max="20" class="slider" value="10">
		</td>
	</tr>


	<tr>
		<td>Modal Pop-Up Value</td>
		<td> 
			<button id="myBtn">Edit Me</button>
		</td>

		<div id="myModal" class="modal">
			<div class="modal-content">
				<span class="close">&times;</span>
				<p>Text in the modal</p>
				<textarea name="myTextArea"></textarea>
			</div>	
		</div>
	</tr>

	<tr>
		<td>Bar</td>
		<td>
			<div class="barOuter">
				<div class="barInner"></div>
			</div>
		</td>
	</tr>

<!---
	<cfelseif EXTYPE eq 4>
	<tr>
		<td>Bootstrap Slider Value</td>
		<td>
			<input id="ex1" data-slider-id='ex1Slider' type="text" data-slider-min="0" data-slider-max="20" data-slider-step="1" data-slider-value="14"/>
		</td>
	</tr>
--->
	</cfif>
</table>
</cfoutput>
