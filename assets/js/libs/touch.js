/*touch.js*/
// a callback handler for errors during XHR
function tsOnError ( responseText ) {
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
