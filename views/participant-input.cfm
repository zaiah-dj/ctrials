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
