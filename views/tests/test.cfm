<cfoutput>
<link rel="stylesheet" type="text/css" href="#link( "assets/css/mobileselect.css" )#">
<script src="#link( "assets/js/mobileselect.js" )#" type="text/javascript"></script>
</cfoutput>


<style type="text/css">
.ios-picker {
	background-color: yellow;
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


	var mobileSelect2 = new MobileSelect({
			trigger: '#ios-picker',
			title: 'My Picker Thingy',
			wheels: [
									{data:[
											{id:'1',value:'Sunday'},
											{id:'2',value:'Monday'},
											{id:'3',value:'Tuesday'},
											{id:'4',value:'Wednesday'},
											{id:'5',value:'Thursday'},
											{id:'6',value:'Friday'}
									]},
									{data:[
											{id:'1',value:'00:00'},
											{id:'2',value:'01:00'},
											{id:'3',value:'02:00'},
											{id:'4',value:'03:00'},
											{id:'5',value:'04:00'},
											{id:'6',value:'05:00'},
											{id:'7',value:'06:00'},
											{id:'8',value:'07:00'},
											{id:'9',value:'08:00'},
											{id:'10',value:'09:00'},
											{id:'11',value:'10:00'},
											{id:'12',value:'11:00'}
									]}
							],
			callback:function(indexArr, data){
					console.log(data); //Returns the selected json data
			}
	});


});
</script>

<!---
<cfset EXTYPE = 0> <!--- Control --->
<cfset EXTYPE = 1> <!--- EE --->
<cfset EXTYPE = 2> <!--- RE --->
<cfset EXTYPE = 3> <!--- Test of all types --->
--->

<cfoutput>
<div class="container-body">
	<table class="table">
		<tr>
			<td>Today''s Date</td>
			<td>#DateFormat( Now())#</td>
		</tr>

		<tr>
			<td>Slider Value</td>
			<td>
				<input id="ex1" data-slider-id='ex1Slider' type="text" data-slider-min="0" data-slider-max="20" data-slider-step="1" data-slider-value="14"/>
			</td>
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
				<div id="myModal" class="modal">
					<div class="modal-content">
						<span class="close">&times;</span>
						<p>Text in the modal</p>
						<textarea name="myTextArea"></textarea>
					</div>	
				</div>
			</td>
		</tr>

		<tr>
			<td>Bar</td>
			<td>
				<div class="barOuter">
					<div class="barInner"></div>
				</div>
			</td>
		</tr>

		<tr>
			<td>iOS Style Date Picker</td>
			<td>
				<div id="ios-picker" style="border:1px solid black;">
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
	</table>
</div>
</cfoutput>
