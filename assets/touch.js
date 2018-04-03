/*touch.js*/
//When you click stuff--this thing should save
document.addEventListener( "DOMContentLoaded", function (ev) 
{

	// a callback handler for errors during XHR
	function onError ( responseText ) {
		console.log( responseText );
	}

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
		evt.prevtDefault();
		if ( evt.touches.length == 1 ) {
			curX = evt.touches[0].pageX;
			curY = evt.touches[0].pageY;
LOG( "X: " + curX + ", Y: " + curY );
		} else {
			touchCancel(evt);
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
					try {
						parsed = JSON.parse( this.responseText );
					}
					catch (err) {
						console.log( err.message );
						console.log( this.responseText );
						return;
					}
					( parsed.status ) ? frm.submit() : onError( this.responseText );
				}
			};

			//What does the pbody look like
			payload = [
				 "staffer_id=" + this.staffer_id.value  
				,"transact_id=" + this.transact_id.value 
				,"list=" + this.list.value 
				,"this=startSession"
			].join( '&' );

			console.log( payload );

			// tHis is made all the more ugly because I'm using GETs when I should be using POSTs
			if ( 1 ) {
				xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update.cfm", true );
				xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
				xhr.send( payload );
				/* 
					"staffer_id=" + this.staffer_id.value +
					"&transact_id=" + this.transact_id.value +
					"&this=check-in-complete" +
					"&list=" + this.list.value
				);
				*/
			}
		}
		return;	
	});
});