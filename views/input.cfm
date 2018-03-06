<cfif 0 eq 1>
<style type="text/css">
	#_cycle, #_treadmill { display: none; }
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

<cfelseif 0 eq 1>

<style type="text/css">
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
				//alert( "New value is: " + ev.target.value );
			} );
		}
		console.log( a ); 
	});
</script>
</cfif>

<!--- Keep this the simplest possible template in the universe --->
<div class="part-div">

	<!--- Include control --->
	<cfif #part.participant_exercise# eq "0">
		<cfinclude template="participant-stubs/control.cfm">

	<!--- Include endurance --->
	<cfelseif #part.participant_exercise# eq "1">
		<cfinclude template="participant-stubs/endurance.cfm">

	<!--- Include resistance --->
	<cfelseif part.participant_exercise eq "2">
		<cfinclude template="participant-stubs/resistance.cfm">
	</cfif>
	
</div>
