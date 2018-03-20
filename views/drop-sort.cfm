<cfset submit_link="#link( 'start-daily.cfm' )#">
<cfset linkish="#link( 'chosen.cfm' )#">
<style type="text/css">
.short-list { position: relative; border/*-bottom*/: 2px solid black; margin-bottom: 10px; width: 100%; }
.wash input[type=text] { display: none; }
.wash input[type=submit] { margin-top: 10px; font-size: 1.2em; background-color: #ccc; border-radius: 5px; -moz-border-radius: 5px; -gecko-border-radius: 5px; display: block; float: right; width: 100px; height: 50px; border: 0px; transition: background-color 0.2s; color 0.2s; }
.wash input[type=submit]:hover { background-color: cyan; color: white; }
.bigly input[type=search] { border: 0px; font-size: 1.5em; padding: 10px; }
.short-list ul li { width: 50px; display: inline-block; background: black; padding-left: 10px; }
.short-list ul li:hover { background: white; }
ul.part-drop-list li:hover { background-color: black; color: white; }
.part-div { overflow: hidden; }
</style>

<!--- A way to sort participants ahead of time --->
<script type="text/javascript">

//When you click stuff--this thing should save
document.addEventListener( "DOMContentLoaded", function (ev) 
{

	//Touch controls
	function ts (evt,passedName) {
		// disable the standard ability to select the touched object
		evt.preventDefault();
		// short name for the stuff I'm concerned with
		ec = evt.target.children;
		// get the total number of fingers touching the screen
		fingerCount = evt.touches.length;
		//See info
		//LOG( fingerCount );LOG( passedName );LOG( "STRING: " + ec[0].innerHTML );LOG( "ID: " + ec[1].innerHTML );
		pp = { id: evt.target.children[1].innerHTML, string: evt.target.children[0].innerHTML };

		// since we're looking for a swipe (single finger) and not a gesture (multiple fingers),
		// check that only one finger was used
		if ( fingerCount > 1 ) 
			touchCancel(evt);
		else {
			//Always check against drop list and make sure the duplicate entries aren't getting in
			aa = [].slice.call( document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" ) ); 
			LOG( pp.string );
			//check what's in aa
			if ( aa.length > 0 ) {
				for ( i=0; i<aa.length; i++) {
					if ( aa[i].innerHTML == pp.id ) {
						console.log( "Looks like this id is already here, stopping request..." );
						return;
					}
				}
			}

			//Add a new node otherwise
			node = document.createElement( "li" );
			span1 = document.createElement( "span" );
			span1.innerHTML = pp.string;
			span2 = document.createElement( "span" );
			span2.innerHTML = pp.id;
			node.appendChild( span1 ); 
			node.appendChild( span2 ); 
			LOG( document.querySelector( ".listing-drop ul" ) );
			targ = document.querySelector( ".listing-drop ul" ) 
			targ.appendChild( node );
		}
	}

	function tc(evt,pn) {
		// reset the variables back to default values
		fingerCount = 0;
		startX = 0;
		startY = 0;
		curX = 0;
		curY = 0;
		deltaX = 0;
		deltaY = 0;
		horzDiff = 0;
		vertDiff = 0;
		swipeLength = 0;
		swipeAngle = null;
		swipeDirection = null;
		triggerElementID = null;
	}

	function tm(evt,pn) {
		event.preventDefault();
		if ( event.touches.length == 1 ) {
			curX = event.touches[0].pageX;
			curY = event.touches[0].pageY;
LOG( "X: " + curX + ", Y: " + curY );
		} else {
			touchCancel(event);
		}
	}
 
	function te(evt,pn) {
		;
	}


	//Start listening out for touch events
	touchEl = [].slice.call( document.querySelectorAll( ".part-drop-list li" ) );
	if ( touchEl.length ) 
	{
		//Respond to touch and drag
		for ( i=0; i < touchEl.length; i++ ) 
		{
			el = touchEl[ i ];
			el.setAttribute( "draggable", true );
			el.addEventListener( "dragstart", drag ); 
			el.addEventListener( "touchstart", ts, true );
		}
	} 

	//Get .listing
	list = [].slice.call( document.querySelectorAll( ".listing" ) );
	for ( i=0; i<list.length; i++ ) {
		list[i].addEventListener( "touchEnd", te );
		list[i].addEventListener( "touchMove", tm );
		list[i].addEventListener( "touchCancel", tc );
	}

	//Sequence all JS data
	document.getElementById( "wash-id" ).addEventListener( "submit", function (ev) {
		ev.preventDefault();

		//Serialize all the data
		vv=[];
		vals = [].slice.call(document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" )); 

		if ( vals.length > 0 ) {
			for ( i=0; i < vals.length; i++) {
				vv[i] = vals[i].innerHTML; 
			}
		}
				
		//send a list back
		this.list.value = vv.join(',');

		//I'll never really submit this, I'll AJAX it instead	
		if ( 0 )
			this.submit();
		else {
			// So, let's see if that works
			var xhr = new XMLHttpRequest();
			var frm = this;

			//Read that XML	
			xhr.onreadystatechange = function () {
				if ( this.readyState == 4 && this.status == 200 ) {
					//console.log( this.responseText );
					parsed = JSON.parse( this.responseText );
					//console.log( parsed );
					if ( parsed.status == 200 ) {
						//JS Forwards us on... but this is not super safe...
						frm.submit(); //I'm only concerned with trans_id
						//window.location.replace( "<cfoutput>#link('chosen.cfm')#</cfoutput>" );	
					}
				}
			};

			// This is butt-ugly and should be done differently
			console.log( "opening connection to " + "<cfoutput>#submit_link#</cfoutput>" );

			//What does the pbody look like
			payload = [
				 "staffer_id=" + this.staffer_id.value  
				,"transact_id=" + this.transact_id.value 
				,"list=" + this.list.value 
			].join( '&' );

			console.log( payload );

			// tHis is made all the more ugly because I'm using GETs when I should be using POSTs
			if ( 0 ) {
				xhr.open( "POST", '<cfoutput>#submit_link#</cfoutput>', true );
				xhr.send( 
					"staffer_id=" + this.staffer_id.value +
					"&transact_id=" + this.transact_id.value +
					"&list=" + this.list.value
				);
			}
			else {
				xhr.open( "GET", '<cfoutput>#submit_link#</cfoutput>?' + payload , true );
				xhr.send( );
			}
		}
		return;	
	});
});
</script>


<cfoutput>
<cfif data.debug eq 1>
	<div class="debug2">#mySession# - #sessionStatus#</div>
</cfif>
<div class="part-div">
	<div class="bigly">

		<!--- Search for names --->
		<input type="search">

		<!--- Drag and drop --->
		<div class="listing">
		<ul class="part-drop-list">
			<cfloop query = "all_part_list">
				<li><!--- draggable="true" ondragstart="drag(event)" --->
					<span>#participant_fname# #participant_lname#</span>
					<span>#participant_id#</span>
				</li>	
			</cfloop>
		</ul>
		</div>

	</div>

	<div class="bigly" style="float: right;" ondrop="drop(event)" ondragover="allowDrop(event)">
		<div class="listing listing-drop">
			<ul> 
		<cfif sessionStatus eq 2>
			<cfloop query = "part_list">
				<li>
					<span>#participant_fname# #participant_lname#</span>
					<span>#participant_id#</span>
				</li>	
			</cfloop>
		</cfif>
			</ul>
		</div>
	</div>


	<!--- On submit, or next, do it. --->
	<form id="wash-id" method="POST" action="#linkish#" class="wash"> 
		<input type="text" name="staffer_id" value="#randnum( 8 )#"> 
		<input type="text" name="transact_id" value="#mySession#"> 
		<input type="text" name="list"> <!--- make a list here --->
		<input type="submit" value="Done!">
	</form>
</div>

</cfoutput>
