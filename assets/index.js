/* ----------------------------------------------------*
index.js
--------

All Javascript needed for the motrpac intervention
tracking app goes here.

Windows that are added will be prefixed with "js-", and
can be styled via CSS.

 * ----------------------------------------------------*/

//Is this a fully touch capable device?
var TOUCHABLE=0;
//Debug window
var debug = { on: 0, c: null, p: null, style: 0/*0=window, 1=console*/ }; 

var inc = 0;
//For check-in
var local_data = {};
//Bad way to go about it, but use a global and get things done
var fw = { arr:[], index:0 };
//Bad global
var activatedOPT = 0;
//All template references will go here
var TEMPLATES = {};
//Recovery question state holder
var RECOVERY_STATE = 0;
//All things that need state tracked can go here for now...
var STATE_TRACKER = {};
//Document was touched
var docWasTouched = 0;
//All endpoints go here for easy editing in the future
const apibase = "/ctrials";
const api = {
	"updateNote":	apibase + "/update-note.cfm"
 ,"updateGeneral": apibase + "/update.cfm"
 ,"completedDays": apibase + "/completed-days-results.cfm"
 ,"notes": apibase + "/notes.cfm"
};

/* ----------------------------------------------------*
 * Routex( args )
 *
 * This function is meant to run after a page has been 
 * fully loaded.  
 *
 * The argument [args] points to a JSON structure 
 * containing maps of route names, event listeners and 
 * callback functions.
 * ----------------------------------------------------*/
function Routex ( args ) {
	var local = {};

	if ( !args ) {
		return;
	}

	//Only for development
	local.dev = 1;

	//Verbose
	local.verbose = args.verbose || 0;

	//Split the URL	
	local.locationArray = location.href.split( "/" ) ;

	//Get the user's current location within the application.
	local.currentLocation = ( local.locationArray[ local.locationArray.length - 1 ] == "" ) 
		? "/" : local.locationArray[ local.locationArray.length - 1 ];

	//Check for routes in args
	local.routes = args.routes || {};

	return {
		init: function ( ) {
			//Loop through the elements in the route specified.
			//	( VERBOSE ) ? console.log( "Loading handlers for route '" + loc + "'" ) : 0;
			for ( r in local.routes ) {
				if ( local.currentLocation.indexOf( r ) > -1 ) {
					for ( t in local.routes[ r ] ) {
						tt = local.routes[ r ][ t ];
						try {
							//Find the DOM elements This call will only fail if the syntax of the selector was wrong.
							//TODO: Would it be helpful to let the dev know that this has occurred and on which index?
							if ( tt.domSelector != "document" )
								dom = [].slice.call( document.querySelectorAll( tt.domSelector ) );
							else if ( tt.domSelector == "document" ) {
								dom = []; dom[0] = document;
							}

							( local.verbose ) ? console.log( "Binding to '" + tt.domSelector + "'.  Element references below:" ) : 0;
							( local.verbose ) ? console.log( dom ) : 0;
						}
						catch ( e ) {
							//TODO: Handle SYNTAX_ERR using e.name 
							console.log( e.message );
						}
					
						//Apply attributes first
						//TODO: This is a bad idea because removal needs to also work. 
						//There's another key and subsequently an overcomplicated data structure.
						if ( tt.attr ) {
							//handle strings and common things like 'required' or 'checked'
							for ( d in dom ) {
								for ( key in tt.attr ) {
									( local.verbose ) ? console.log( "Setting key '" + key + "' to '" + tt.attr[ key ] + "'" + " on element " + tt.domSelector + "(" + d + ")"  ) : 0;
									dom[d].setAttribute( key, tt.attr[ key ] );
								} 	
							} 	
						}

						//Bind function(s) to event
						if ( typeof tt.f === 'function' && typeof tt.event === 'string' ) {
							( local.verbose ) ? console.log( "Binding single function " + tt.f.name + " \n\n" ) : 0;
							for ( d in dom ) { 
								( local.verbose ) ? dom[ d ].addEventListener( tt.event, (function(fname) { f = fname; return function(ev){console.log("Calling " + f); }})(tt.f.name) ) : 0;
								dom[ d ].addEventListener( tt.event, tt.f ); 
							}
						}
						else if ( typeof tt.f === 'object' && typeof tt.event === 'string' ) {
							( local.verbose ) ? console.log( "Binding multiple functions" ) : 0;
							for ( d in dom ) {
								for ( ff in tt.f ) {
									( local.verbose ) ? dom[d].addEventListener( tt.event, whatFunct.bind( null, tt.f[ff].name ) ) : 0;
									dom[d].addEventListener( tt.event, tt.f[ ff ] ); 
								}
							}
							( local.verbose ) ? console.log( "\n\n" ) : 0;
						}
					}
				}
			}
		}
	}
}


/* ------------------------------------ *
function allowDrop(ev)

...
 * ------------------------------------ */
function allowDrop(ev) {
	ev.preventDefault();
	//console.log( "allow drop" );
}


/* ------------------------------------ *
function addFrameworkWin( elChain ) 

Create a new with attributes specified in
attChain and containing elements specified
in elChain.

An example:
ref = addFrameworkWin( { className: "juice" }, [
	{ input: { 
			size: 132,
			type: "text",
			eventListener: { event: "blur", callback: blur_funct }
		}
	},
	{ div: {
			innerHTML: "Click in my input field and see magic!"
		}
	}
]);

HTML will look like:
<div class="juice">
	<input type="text">
	<div>Click in my input field and see magic!</div>
</div>

 * ------------------------------------ */
function addFrameworkWin( elChain ) {
	//Create the background shade 
	shadenode = document.createElement( "div" );
	shadenode.className = "js-popup-underlay";
	shadenode.style.width = "100%";
	shadenode.style.height = "100%";
	shadenode.style.display = "block";
	shadenode.style.position = "absolute";
	shadenode.style.top = "0px";
	shadenode.style.left = "0px";
	shadenode.style.zIndex = "99";

	//Generate the window we'll actually work with
	node = document.createElement( "div" );
	node.className = "js-popup";
	node.style.zIndex = "99";
	//node.id = "addedwindow";

	//Generate a header
	xout = document.createElement( "div" );
	xout.className = "js-popup--header";
	xout.style.width = "100%";

	//Generate the 'X' to close the window
	span = document.createElement( "span" );
	span.className = "js-popup--close"; 
	span.innerHTML = "&times;";	
	span.addEventListener( "click", function (ev) {
		ev.preventDefault();
		shadenode.parentElement.removeChild( shadenode );
	});
	
	//Add it
	xout.appendChild( span );
	node.appendChild( xout );

	//Quick and dirty way to add more DOM elements to this window 
	for ( x=0; x<elChain.length; x++ ) {
		for ( y in elChain[x] ) {
			el = document.createElement( y );
			for ( z in elChain[x][y] ) {
				//do an indexOf, and match the full name
				if ( ["eventListener","innerHTML","value","id","className"].indexOf( z ) == -1 )
					el.style[ z ] = elChain[x][y][z];
				else if ( z == "eventListener" )
					el.addEventListener( elChain[x][y][z]["event"], elChain[x][y][z]["callback"] );
				else {
					el[ z ] = elChain[x][y][z];
				}
			}
			node.appendChild( el );
		}
	}

	//Add to the DOM
	shadenode.appendChild( node );
	document.body.appendChild( shadenode );
	return shadenode;
}


/* ------------------------------------ *
function saveParticipantNote( ev ) 

Save a participant note to an API endpoint.
 * ------------------------------------ */
function saveParticipantNote ( ev ) {
	ev.preventDefault();
	box = document.getElementById( "ta-inner" );

	//Get the partGUID, Session ID, and user notes
	var pd = [].slice.call( document.querySelectorAll("input[name=ps_pid]") );
	var sd = [].slice.call( document.querySelectorAll("input[name=ps_sid]") );
	noteValue = box.value ;
	
	//Also get the notes section of the text area...
	ref = [].slice.call( document.querySelectorAll( "ul.participant-notes" ) )[0];

	//If no note, don't save.
	if ( noteValue == "" ) {
		console.log( "No notes present." );
		return;
	}

	//Update the note field	
	var xhr = new XMLHttpRequest();	
	xhr.onreadystatechange = function (ev) { 
		if ( this.readyState == 4 && this.status == 200 ) {
			try {
				var li=null;
				//console.log( this.responseText );
				parsed = JSON.parse( this.responseText );
				//This handles cases in which no notes are present for the past two weeks.
				if ( li = ref.querySelector( "#noNotes" ) ) {
					li.removeAttribute( "id" ); 
					li.innerHTML = getDatestamp() + " - " + noteValue;
				}	
				else {
					(li = document.createElement( "li" )).innerHTML = getDatestamp() + " - " + noteValue;
					ref.insertBefore( li, ref.children[0] );
				}
				//TODO: This is not the greatest way to remove this box. 
				shadenode.parentElement.removeChild( shadenode );
			}
			catch (err) {
				console.log( err.message );console.log( this.responseText );
				return;
			}
		}
	}
	xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update-note.cfm", true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( 
		"note=" + noteValue + 
		"&pid=" + pd[0].value +
		"&sid=" + sd[0].value
	);
}



/* ------------------------------------ *
function getDatestamp(  ) {

Retrieve a properly formatted datestamp.

 * ------------------------------------ */
function getDatestamp ( ){
	var m, y, dd=new Date();
	return [
		(((m = dd.getMonth() + 1) < 10) ? "0" + m : m),
		dd.getDate(),
		(String( dd.getFullYear() ).slice( 2,4 ))
	].join( "/" );
	; 
}


/* ------------------------------------ *
function saveParticipantEarlyStopReason ( el ) {

Save a participant stop session early reason 
to an API endpoint.

 * ------------------------------------ */
function saveParticipantEarlyStopReason ( ev ) {
	ev.preventDefault();
	var t = document.getElementById( "ta-inner" );
	var r = document.getElementById( "reasonStoppedEarly" );
	var v = t.value;	
	var d = null;

	//Only add in case of 
	if ( (r.value = t.value) ) {
		r.value = t.value;
		//Show the textarea
		if ( (d = document.getElementById( "reasonShowUser" )) )
			d.innerHTML = r.value;
		else {
			d = document.createElement( "div" );
			d.id = "reasonShowUser";
			d.className = "js-showuserreason";
			d.innerHTML = r.value;
			var p = r.parentElement.appendChild( d );

			console.log( r.parentElement.querySelector( ".modal-activate" ) );
			r.parentElement.querySelector( ".modal-activate" ).innerHTML = "Edit Reason"; 
		}	
	}

	//Change text to 'Edit Reason'
	//Always get rid of the box
	shadenode.parentElement.removeChild( shadenode );
}


/* ------------------------------------ *
function drag(ev, optArg)

When the drag is started, create a node.
 * ------------------------------------ */
function drag (ev, optArg) {
	if ( optArg ) {
		//( isDebugPresent ) ? console.log( "swipe complete..." ) : 0;
		return;
	}
	else {
		//( isDebugPresent ) ? console.log( "drag complete..." ) : 0;
		//ev.dataTransfer.setData("text", ev.target.id);
		console.log( "drag started..." ); 
		fw[fw.index] = prepareParticipantNode( ev.target );
		//console.log( fw[ fw.index ] );
	}
}


/* ------------------------------------ *
function drop(ev)

Drop ...
 * ------------------------------------ */
function drop(ev) {
	//var isDebugPresent = document.getElementById( "cfdebug" );
	ev.preventDefault();
	console.log( "drop finished..." ); 

	//Always check against drop list and make sure the duplicate entries aren't getting in
	aa = [].slice.call( document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" ) ); 

	//check what's in aa
	if ( aa.length > 0 ) {
		for ( i=0; i<aa.length; i++) {
			if ( aa[i].innerHTML == fw[fw.index].id ) {
				console.log( "Looks like this id is already here, stopping request..." );
				return;
			}
		}
	}

	//Create a new node
	node = createParticipantNode( fw[fw.index], 1 );
	ev.target.children[0].appendChild( node ); 
	
	//Remove the original element
	ce = fw[ fw.index ].ref;
	ce.parentElement.removeChild( ce ); 
}


/* ------------------------------------ *
function prepareParticipantNode ( el )

Prepare a participant node.
 * ------------------------------------ */
function prepareParticipantNode ( el ) {
	return {
		ref: el
	 ,id: el.querySelector( "span.pguid" ).innerHTML
	 ,pid: el.querySelector( "span.pid" ).innerHTML
	 ,name: el.querySelector( "span.name" ).innerHTML
	 ,acrostic: el.querySelector( "span.acrostic" ).innerHTML
	 ,className: el.className
	};
}


/* ------------------------------------ *
function createParticipantNode( el, rightSide )

Create a participant node suitable for
either viewing or releasing participants.
 * ------------------------------------ */
function createParticipantNode( el, rightSide ) {
	//Add all new nodes
	var node, divLeft, divRight, spanName, spanAcrostic, spanPguid;
	(node = document.createElement( "li" )).className = el.className + (( rightSide ) ? "-dropped" : "");
	(divLeft = document.createElement( "div" )).className = "left";
	(divRight = document.createElement( "div" )).className = "right";
	(spanName = document.createElement( "span" )).className = "name";
	(spanPid = document.createElement( "span" )).className = "pid";
	(spanAcrostic = document.createElement( "span" )).className = "acrostic";
	(spanPguid = document.createElement( "span" )).className = "pguid";

	//Set all of these references
	spanName.innerHTML = el.name;
	spanPguid.innerHTML = el.id;
	spanPid.innerHTML = el.pid;
	spanAcrostic.innerHTML = el.acrostic;

	//Set the left up first
	divLeft.appendChild( spanName );

	//Then the right (and yes, this is ridiculous)
	divRight.appendChild( document.createTextNode("PID: ") );
	divRight.appendChild( spanPid );
	divRight.appendChild( document.createElement("br") );
	divRight.appendChild( document.createTextNode("Acrostic: ") );
	divRight.appendChild( spanAcrostic );
	divRight.appendChild( spanPguid );

	//Only add release when it's on a specific side
	if ( rightSide ) {
		(relHref = document.createElement( "a" )).className = "release";
		relHref.innerHTML = "Release";
		relHref.addEventListener( "click", releaseParticipant );
		(spanRel = document.createElement( "span" )).className = "release-participant";
		spanRel.appendChild( relHref );
		divRight.appendChild( spanRel );
	}
	
	//Then the full node
	node.appendChild( divLeft );
	node.appendChild( divRight );
	return node;
}


/* ------------------------------------ *
function searchParticipants ( ev )

Filter search when trying to narrow down participants
 * ------------------------------------ */
function searchParticipants ( ev ) {
	vv = [].slice.call( document.querySelectorAll( "ul.part-drop-list li" ) );
	for ( i=0; i < vv.length; i++ ) {
		nod =         vv[i].children[0].parentElement;
		key = String( vv[i].children[0].innerHTML );
		val = ev.target.value;
		nod.style.display = ( key.toLowerCase().indexOf( val.toLowerCase() ) == -1 ) ? "none" : "block"; 
	}
}


/* ------------------------------------ *
function changeSliderNeighborValue ( ev )

Handle the update of values by clicking on + and - boxes
 * ------------------------------------ */
function changeSliderNeighborValue ( ev ) {
	//Change the whole value if the inner value has no nodes...
	//ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value; 

	//console.log( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes.length );
	var nodeset = ev.target.parentElement.parentElement.childNodes[ 3 ];

	if ( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes.length <= 1 ) 
		ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
	else {
		//console.log( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes[0].innerHTML = ev.target.value );
		ev.target.parentElement.parentElement.childNodes[ 3 ]
			.childNodes[0].innerHTML = ev.target.value;
	} 
}


//Update box values when slider changes
function updateNeighborBox ( ev ) {
	//Save the reference somewhere
	ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
}


/* ------------------------------------ *
function getNextResults(ev)

Handle the update of values by clicking on + and - boxes
 * ------------------------------------ */
function updateNeighborBoxFromSI (ev) {
	ev.preventDefault();
	aav = 0;

	//Just get the references
	if ( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes.length <= 1 )
		aav = ev.target.parentElement.parentElement.childNodes[3];
	else {
		aav = ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes[0];
	} 

	//Then get the limits
	min = ev.target.parentElement.parentElement.querySelector( "input[type=range]" ).min;
	max = ev.target.parentElement.parentElement.querySelector( "input[type=range]" ).max;

	//Now, make an adjustment to the field value.  Query the DOM for value limits.
	forceNum = Number( aav.innerHTML );
//console.log( ev.target.className );
	if ( ev.target.className.indexOf( "js-down" ) > -1 )
		aav.innerHTML = (( forceNum - 1 ) < min ) ? aav.innerHTML : --( aav.innerHTML ); 
	else if ( ev.target.className.indexOf("js-up") > -1 ) {
		aav.innerHTML = (( forceNum + 1 ) <= max ) ? ++( aav.innerHTML ) : aav.innerHTML; 
	} 
	
	//aav.innerHTML = ( ev.target.innerHTML == '-' ) ? --( aav.innerHTML ) : ++( aav.innerHTML );
	ev.target.parentElement.parentElement.querySelector("input").value = aav.innerHTML;
}


/* ------------------------------------ *
function getNextResults(ev)

Handles fetching and serializing 
participant results from previous weeks 
 * ------------------------------------ */
function getNextResults(ev) {
	ev.preventDefault();
	//Get all modal-load links, and set xhr for each.
	var xhr = new XMLHttpRequest();
	var doc = document.getElementById( "feed" );
	xhr.open( "GET", ev.target, false );
	xhr.send();
	doc.innerHTML = xhr.responseText;	
	var ia = [].slice.call( 
		document.querySelectorAll( ".modal-load" )); 

	//Remove all listeners on the page	
	for ( n in ia ) {
		ia[n].removeEventListener( "click", getNextResults );
	}

	//Re-add all listeners on the page.
	for ( n in ia ) {
		ia[n].addEventListener( "click", getNextResults );
	}
	return 1;
}


/* ------------------------------------ *
function checkInSaveNote ( ev )

Save notes.
 * ------------------------------------ */
function checkInSaveNote ( ev ) {
	ev.preventDefault();

	var pidDom = [].slice.call( 
		document.querySelectorAll("input[name=ps_pid]") );
		
	var sidDom = [].slice.call( 
		document.querySelectorAll("input[name=ps_sid]") );

	var note = [].slice.call( 
		document.querySelectorAll("textarea[name=ps_notes]") );

	var pidValue = pidDom[0]["value"];
	var sidValue = sidDom[0]["value"];
	var noteValue = note[0]["value"];
	var windowRef = ev.target.parentElement.parentElement;

	//Only save if content is there
	if ( noteValue == "" ) {
		//console.log( "nothing is here, guy" );
		console.log( ev.target.parentElement.parentElement );
		return;
	}

	var xhr = new XMLHttpRequest();	
	xhr.onreadystatechange = function (ev) { 
		if ( this.readyState == 4 && this.status == 200 ) {
			try {
				console.log( this.responseText );
				parsed = JSON.parse( this.responseText );
				var par = [].slice.call( 
					document.querySelectorAll("ul.participant-notes") );
				var li = document.createElement( "li" );
				li.innerHTML = noteValue;
				par[0].appendChild( li ); 
				windowRef.style.display = "none";
			}
			catch (err) {
				console.log( err.message );console.log( this.responseText );
				return;
			}
		}
	}
	xhr.open( "POST", api.updateNote , true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( 
		"note=" + noteValue + 
		"&pid=" + pidValue +
		"&sid=" + sidValue 
	);

}


/* ------------------------------------ *
function saveSessionUsers (ev)

Update exercise session list
 * ------------------------------------ */
function saveSessionUsers (ev) {
	//Cancel default
	ev.preventDefault();

	//Serialize all the data
	vv=[];
	vals = [].slice.call(document.querySelectorAll( ".listing-drop ul li span.pguid" )); 
	if ( vals.length > 0 ) {
		for ( i=0; i < vals.length; i++) vv[i] = vals[i].innerHTML; 
	}

	//Prepare a list from the users that have been selected. 
	this.list.value = vv.join(',');
	var frm = this, xhr = new XMLHttpRequest();

	//Read that XML	
	xhr.onreadystatechange = function () {
		if ( this.readyState == 4 && this.status == 200 ) {
			try {
				parsed = JSON.parse( this.responseText );
			}
			catch (err) {
				return;
			}
			( parsed.status ) ? frm.submit() : console.log("Error occurred: " +  this.responseText );
		}
	};

	//What does the pbody look like
	payload = [
		 "interventionist_id=" + this.interventionist_id.value  
		,"transact_id=" + this.transact_id.value 
		,"sessday_id=" + this.sessday_id.value 
		,"list=" + this.list.value 
		,"this=startSession"
	].join( '&' );

//console.log( payload );return;

	//Send a POST to the server
	xhr.open( "POST", api.updateGeneral, true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( payload );
/*console.log( payload );
	console.log( xhr.responseText );*/
	//ev.target.innerHTML = "Changes Saved!";
	return false;
};


//Simply change the value
function sendPageValsChange (ev) {
	console.log( ev.target );
	ev.target.value = "Changes Saved!";
}


//Simply lists what functions are being called with each listener.
function whatFunct( f ) {
	console.log( f );
}


//Update the entire list
unselected = 0;
function updateExerciseForm ( ev ) {
	var p = ev.target.parentElement.parentElement.parentElement;
	if ( !unselected ) {
		console.log( p );
		tr = p.querySelectorAll( "tr" );
		for ( n=1; n<tr.length; n++ ) tr[ n ].style.display = "none";
		unselected = 1;
	}
	else {
		for ( n=1; n<tr.length; n++ ) tr[ n ].style.display = "block";
		unselected = 0;
	}
}


/* ------------------------------------ *
function updateExerciseSession ( ev )

Update exercise session list

 * ------------------------------------ */
function updateExerciseSession ( ev ) {
	//Get the current PID
	var pid, ilocarr = location.href.split("?")[1].split("=");
	for ( n=0; n < ilocarr.length; n++ ) {
		if ( ilocarr[n] == "id" ) pid = ilocarr[n + 1];
	}
	
	//And finally get the field to change
	var p = ev.target.parentElement.parentElement.parentElement;
	var q = document.getElementById( "weekSession" );
	
	//Create the URL
	var l = api.completedDays + "?pid=" + pid + "&week=" + ev.target.value ;

	//Send a request and replace the field
	var x = new XMLHttpRequest();
	x.open( "GET", l , false); 
	x.send();
	q.innerHTML = x.responseText;	
}


/* ------------------------------------ *
function activateOtherParamText ( ev ) {

???

 * ------------------------------------ */
function activateOtherParamText ( ev ) {
	opt = [].slice.call( document.getElementsByClassName( "param-ta" ) );

	if ( ev.target.id == "activateOtherParamText" ) {
		if ( !activatedOPT ) {
			for ( div in opt ) {
				d = opt[ div ];
				if ( d.tagName == "LABEL" )
					d.style.height = "30px";
				else {
					d.style.height = "50px";
					d.style.border = "1px solid black";
				}
			}
			activatedOPT = 1;
		}
	}

	//When blurring I need to check where we are
	if ( ev.target.id == "" ) {
		if ( activatedOPT == 1 ) {
			for ( div in opt ) {
				d = opt[ div ];
				if ( d.tagName == "LABEL" )
					d.style.height = "0px";
				else {
					d.style.height = "0px";
					d.style.border = "0px solid black";
				}
			}
			activatedOPT = 0;
		}
	}
}


/* ------------------------------------ *
function releaseParticipant ( ev ) {

Release a participant back into the pool.

 * ------------------------------------ */
function releaseParticipant ( ev ) {
	ev.preventDefault();

	//Find the ID of the participant selected
	var par = ev.target.parentElement.parentElement.parentElement;
	var el = prepareParticipantNode( par );
	var f = document.getElementById( "wash-id" );

	//Replace class name, can't remember why
	el.className = el.className.replace( "-dropped", "" );
	
	//Assemble a POST request with the ID and other info
	payload = [
		 "interventionist_id=" + f.interventionist_id.value  
		,"transact_id=" + f.transact_id.value 
		,"sessday_id=" + f.sessday_id.value 
		,"pid=" + el.id
		,"this=releaseParticipant"
	].join( '&' );

	//Start a timer to acutally remove the element from the DOM
	setTimeout( function () { par.parentElement.removeChild( par ); }, 2000 );	

	//Remove the element from view
	par.style.height = "0px";
	par.style.padding = "0px";
	par.style.margin = "0px";

	//Create and prepare the XHR object
	var xhr = new XMLHttpRequest();	
	xhr.onreadystatechange = function (ev) { 
		if ( this.readyState == 4 && this.status == 200 ) {
			try
				{ console.log( this.responseText );parsed = JSON.parse( this.responseText ); }
			catch (err) {
				console.log( this.responseText );
				return;
			}
		}
	}

	//Send the POST request to server
	xhr.open( "POST", api.updateGeneral, true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( payload );

	//Would add to the bottom of the list, but it needs to be at the top
	var a=null, node = createParticipantNode( el, 0 );

	//Re-add the drag over functionality
	node.addEventListener( "dragstart", drag );
	node.addEventListener( "touchstart", touchStart );
	node.setAttribute( "draggable", true );

	if (a = document.querySelector( "ul.part-drop-list li:nth-child(1)" )) {
		a.parentElement.insertBefore( node, a );
	}
	else {
		a = document.querySelector( "ul.part-drop-list" ); 
		a.appendChild( node ); 
	}

	//node needs an event listener to control drag and drop again

	//Return false
	return false;
}


/* ------------------------------------ *
function redirectEngine ()

-
 * ------------------------------------ */
function redirectEngine() {
	//Define an object and split the URL
	local = {};
	local.locationArray = location.href.split( "/" ) ;
	va = local.locationArray[ local.locationArray.length - 1 ];
	qi = va.indexOf("?");
	queryStrings = {};
	qs = va.substr( qi + 1, va.length ).split( "&" );
	console.log( queryStrings );

	//Convert this to an object for easy access
	for ( i=0; i < qs.length; i++ ) {
		var id = qs[ i ].indexOf( "=" ), name = qs[i].substr( 0, id ); 
		queryStrings[name] = qs[i].substr( id+1, qs[i].length );
	}

	//Check for a query string and run this if so
	if ( queryStrings.err ) { 
		local.bg = document.createElement( "div" );
		local.bg.className = "errorBg";
		local.bg.style.zIndex = "99";

		//Create an element, give it focus
		local.div = document.createElement( "div" );
		local.div.className = "errorEngine";
		local.div.id = "errorEngine";
		local.div.style.zIndex = "99";
		local.div.innerHTML = decodeURI( queryStrings.err ).replace(/\+/g, " " );
	
		//...
		document.body.appendChild( local.bg );
		local.bg.appendChild( local.div );
		setTimeout( function () { 
			local.bg.style.backgroundColor = "rgba( 255, 255, 255, 0.1 )";
			local.div.style.height = "0%";	
			local.div.style.border = "0";	
			local.div.style.padding = "0";
			setTimeout( function () {	
				document.body.removeChild( local.bg ); 
			}, 300 );
		}, 2000 );
	}	
}


/* ------------------------------------ *
function sendPageValCallback ( ev ) {

-
 * ------------------------------------ */
function sendPageValCallback ( ev ) {
	//Define some holding spots.
	tv={}, av=[]; 

	//Get all the values
	mv=[].slice.call( document.querySelectorAll( 
		'.slider, .toggler-input, input[name=tfhr_time], input[type=radio], input[type=numeric], select, #reasonStoppedEarly' ) );

	//Get all the additional values
	tmp = [].slice.call( document.querySelectorAll('.addl input') );
	tmp.forEach( function (el) { mv.push( el ) } );

	//This simple loop is used to ensure I catch ALL form values, be they checkboxes or radios or not
	for (i=0; i < mv.length; i++) { 
		fName = mv[ i ].name ;
		ftype = mv[ i ].type.toLowerCase();

		//if (( ftype != "radio" ) && ( ftype != "checkbox" ) && ( ftype != "select-multiple" ))
		//Make sure to track the value of ALL form input types
		if ( ["radio","checkbox","select-multiple"].indexOf( ftype ) == -1 )
			av.push( fName + '=' + mv[i].value );
		else { 
			//Get values and add it to the list of values
			if ( !tv[ fName ] ) {
				tv[ fName ] = true;
				ivals = [];
				sel = ( ftype != "select-multiple" ) ? "input[name=" + fName + "]" : "select[name=" + fName + "] option"; 
				abc = [].slice.call( document.querySelectorAll( sel + ":checked" ) );
				abc.forEach( function(el) { ivals.push( el.value ) } );
				av.push( fName + '=' + ivals.join( ',' ) ); 
			}
		}
	}

	//Join and make a payload
	Vals = av.join( '&' ); 

	//Make XHR to server and you're done
	x = new XMLHttpRequest();
	x.onreadystatechange = function (ev) {
		if ( this.readyState == 4 && this.status == 200 ) {
			try {
				console.log( this.responseText );
				parsed = JSON.parse( this.responseText ); 
			}
			catch (err) {
				console.log( this.responseText );
				return;
			}
		}
	}
	x.open( 'POST', api.updateGeneral, false );
	x.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
	x.send(Vals);
}


/* ------------------------------------ *
function tsOnError ( responseText )

-
 * ------------------------------------ */
function tsOnError ( responseText ) {
	console.log( responseText );
}


/* ------------------------------------ *
function touchStart (ev, pn)

Track touches from the beginning.
 * ------------------------------------ */
function touchStart (ev, passedName) {
	//Disable the standard ability to select the touched object
	ev.preventDefault();
	try {
		//Short name for the stuff I'm concerned with
		pp = prepareParticipantNode( ev.currentTarget );

		// Check that only one finger was used
		if (( fingerCount = ev.touches.length ) > 1 ) 
			touchCancel(ev);
		else {
			//Always check against drop list and make sure the duplicate entries aren't getting in
			//aa = [].slice.call( document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" ) ); 
			aa = [].slice.call( document.querySelectorAll( ".listing-drop span.pguid" ) );
			if ( aa.length > 0 ) {
				for ( i=0; i<aa.length; i++) {
					if ( aa[i].innerHTML == pp.id ) {
						console.log( "Looks like this id is already here, stopping request..." );
						return;
					}
				}
			}
		  node = createParticipantNode( pp, 1 );
			targ = document.querySelector( ".listing-drop ul" );
			targ.appendChild( node );
			ev.currentTarget.parentElement.removeChild( ev.currentTarget );
		}
	}
	catch (err) {
		//Create a window display the exception
		db( JSON.stringify( ee ).replace(/,/g,",<br>") );
	}
}


/* ------------------------------------ *
function touchCancel (ev, pn)

Cancel touch on a screen.
 * ------------------------------------ */
						/*
function touchCancel (ev, pn) {
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
*/


/* ------------------------------------ *
function tm (ev, pn)

Create a modal for the checkin page.
 * ------------------------------------ */
/*function tm (ev, pn) {
	ev.preventDefault();
	if ( ev.touches.length == 1 ) {
		curX = ev.touches[0].pageX;
		curY = ev.touches[0].pageY;
		//LOG( "X: " + curX + ", Y: " + curY );
	} else {
		touchCancel(ev);
	}
}
*/




/* ------------------------------------ *
function generateModalCheckIn( ev )

Create a modal for the checkin page.
 * ------------------------------------ */
function generateModalCheckIn( ev ) {
	ev.preventDefault();
	//Add a new window with callback and extra elements
	var node = addFrameworkWin( [
		{ textarea: { 
				id: "ta-inner", 
				className: "js-popup--textarea"
		}}
	, { button: {
				innerHTML: "Save!"
		  , className: "submit"
		  , eventListener: { event:"click", callback:saveParticipantNote }
		}} 		
	]); 
	document.getElementById("ta-inner").focus();
}



/* ------------------------------------ *
function generateModalRecovery( ev ) {

Create a modal for the recovery page.
 * ------------------------------------ */
function generateModalRecovery( ev ) {
	ev.preventDefault();
	var node = addFrameworkWin( [
		{ textarea: { 
				id: "ta-inner" 
			, className: "js-popup--textarea"
		 	, innerHTML: document.getElementById("reasonStoppedEarly").value
		}}
	, { button: {
				innerHTML: "Save!"
		  , className: "submit"
			, eventListener: { event:"click", callback: saveParticipantEarlyStopReason }
		}} 		
	]); 
	document.getElementById("ta-inner").focus();
}


/* ------------------------------------ *
function generateViewAdditional( ev )

Create a modal with the previous 
results.
 * ------------------------------------ */
function generateViewAdditional( ev ) {
	ev.preventDefault();
	pd = [].slice.call( document.querySelectorAll("input[name=ps_pid]") );
	//make xhr request for the rest of the data
	xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function () {
		if ( this.readyState == 4 ) {
			a = JSON.parse( this.responseText );
			str = "<table>";
			a.RESULTS.DATA.map( function(aa) { str += "<tr><td>" + aa[3] + "</td><td>" + aa[5] + "</td></tr>"; } );
			str += "</table>";
			addFrameworkWin( [
				{ h5: { innerHTML: "Notes" } }
			 ,{ div: { 
				  className: "js-popup--table"
				 ,innerHTML: str 
				}}
			]);
		}
	}
	xhr.open( "POST", api.notes, true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send(
		"pid=" + pd[0].value +
		"&this=notes"
	);	
}


/* ------------------------------------ *
function unhideRecoveryQuestions (ev)

Unhide the recovery questions that only
show up when a session stops early.

 * ------------------------------------ */
function unhideRecoveryQuestions (ev) {
	var divs = [].slice.call( document.querySelectorAll( ".js-toggle-showhide" ) );
	divs.map( function (el) { el.classList.toggle( "js-hidden" ); } );	
}


/* ------------------------------------ *
function stateChangeUpdate( ev )

Change the state on adjacent text node
elements.
 * ------------------------------------ */
function stateChangeUpdate( ev ) {
	//Change the state of binary togglers
	st = STATE_TRACKER[ ev.target.name ] = ev.target.checked;
	ev.target.nextElementSibling.nextElementSibling.innerHTML = ( st ) ? "Yes" : "No"; 
	STATE_TRACKER[ ev.target.name ] = ( st ) ? 0 : 1; 
}


/* ------------------------------------ *
function updateTime( ev )

Change the state on adjacent text node
elements.
 * ------------------------------------ */
function updateTime( ev ) {
	ev.preventDefault();
	function padzero(i) { return (( i < 10 ) ? "0" + i : i) ; } 
	var node;
	var min=0, sec=0;
	var pd = [].slice.call( document.querySelectorAll("input[name=pid]") );
	var sd = [].slice.call( document.querySelectorAll("input[name=sess_id]") );

	//Set the current date, and put that in the box
	var dd = new Date();
	ev.target.nextElementSibling.value = padzero(dd.getHours()) + ":" + padzero(dd.getMinutes());
	ev.target.innerHTML = "Exercise Started!";

	//Create a little box called js-timer
	//( node = document.createElement( "div" ) ).innerHTML = "00:00";
	( node = document.createElement( "div" ) ).innerHTML = "00m:00s";
	node.className = "js-stopwatch";
	setInterval( function ( ev ) { 
		sec += ( sec == 60 ) ? -60 : 1;
		min += ( sec == 60 ) ? 1 : 0;
		node.innerHTML = [ padzero( min ),"m:",padzero( sec ),"s" ].join("");
	}, 1000 );
	ev.target.parentElement.appendChild( node );
}




/* ------------------------------------ *
function changeUp (ev)

Track and format 24-hour time
 * ------------------------------------ */
function changeUp (ev) {
	//Remove the node from view
	d = ev.target;

	//Add a listener that will handle visual formatting
	d.addEventListener( "keyup", function (ev) {
		if ( ev.target.value.length == 5 )
			ev.preventDefault();
		else if (( ev.target.value.length == 2 ) && (ev.target.value.indexOf( ":" ) == -1) ) {
			ev.preventDefault();
			ev.target.value += ":";
		}
	});

	//Finally, add a listener that will make our value something natural again
	d.addEventListener( "blur", function (ev) {
		//Check that the value is not less than 00:00 or greater than 23:59
		try {
			var hh = Number( ev.target.value.substring( 0, 2 ) );
			var mm = Number( ev.target.value.substring( 3, 5 ) );

			if ( ( hh < 0 || hh > 23 ) || ( mm < 0 || mm > 59 ) ) {
				console.log( "input range is off..." );//ALERTBOX
				ev.target.focus();
			}
			else if ( ev.target.value.length < 5 ) {
				console.log( "please input a 24-hour clock time of the format HH:mm" );//ALERTBOX
			} 
			else if ( isNaN(hh) || isNaN(mm) ) {
				console.log( "time range is not a number..." );//ALERTBOX
				ev.target.focus();
			}
			else {	 
				//Send the value back to server
			}
		}
		catch(e) {
			//also let the user know that the value is off...
			//ALERTBOX
			console.log( e );
		}
	});

	//Add the node where the old used to be
	//a.parentElement.appendChild( d );
	//d.focus();
}



function makeModal( ev ) {
	//console.log( ev.target.nextElementSibling );
	//console.log( "..." );
	ev.preventDefault();
	addFormattedWin( "yomama" ); 
return;


	try {
		//The thing pressed	
		var b = ev.target;
		//The actual window
		var m = ev.target.nextElementSibling;
		//The thing to close
		var c = ev.target.nextElementSibling.querySelector( ".close" );
		//console.log( b, m, c );

		//Select an onclick
		//Find an element that will allow me to hot load things
		b.onclick = function() {
			m.style.display = "block";
		}

		c.onclick = function() {
			m.style.display = "none";
		}
	}
	catch (err) {
		//Create a window display the exception that occurred.
		//addFrameworkWin({[ {div: { innerHTML: err } } ]});
	}
}


function slideMenu ( ev ) {
	ev.preventDefault();
	var id = ev.target.parentElement.id;
	var st = STATE_TRACKER[ id ];
	(a = document.querySelector( "." + id + "-window" )).style.display = (st) ? "none" : "block";
	STATE_TRACKER[ id ] = ( st ) ? 0 : 1; 
}



function slideMenuLogin( ev ) {
	ev.preventDefault();
	var id = ev.target.parentElement.id;
	var st = STATE_TRACKER[ id ];
	(a = document.querySelector( "." + id + "-window" )).style.display = (st) ? "none" : "block";
	STATE_TRACKER[ id ] = ( st ) ? 0 : 1; 
}


function slideMenuNavIcon( ev ) {
	ev.preventDefault();
console.log( ev.target.classList );
	ev.target.classList.toggle( "change" );
	var id = ev.target.id;
	var st = STATE_TRACKER[ id ];
	(a = document.querySelector( "." + id + "-window" )).style.display = (st) ? "none" : "block";
	STATE_TRACKER[ id ] = ( st ) ? 0 : 1; 
}

/* ------------------------------------ *
function wasDocTouched (ev)

Checks if the document was ACTUALLY
interacted with or not.  This is a 
simple way to detect whether or not
the user actually interacting with
important elements.
 * ------------------------------------ */
function wasDocTouched (ev) {
	ev.preventDefault();
	//Update the following global if things were touched.
	if ( !docWasTouched ) {
		document.querySelector( "input[name=pageUpdated]" ).value = 1;
		docWasTouched = 1;
	} 
}





/*
//The Router structure is key to make interfaces work.
//Can't wait for WASM
typedef Router {

	//What DOM selector is used to get these elements 
	const char *domSelector;

	//What event should I be listening for?
	const char *event;

	//Function (or functions) to use addEventListener with 
	void * (*f)( Object event )[];	

	//Was this particular element updated?	
	int hit;
	
} 
 */

function biz(ev) { ev.preventDefault(); alert( 'clicked' ); }

Router = {
	"check-in": [
		//In JS however, I have to use JSON for an object, meaning that I have to specify the key for each "column" I want.  This is a lot of typing... 
		{ domSelector: "input[ type=range ]" 
		, event: "input"   , f: changeSliderNeighborValue }  
	 ,{ domSelector: "#ps_note_save"       
		, event: "click"   , f: checkInSaveNote }
	 ,{ domSelector: ".modal-load"         
		, event: "click"   , f: getNextResults }
	 ,{ domSelector: ".modal-activate"     
		, event: "click"   , f: generateModalCheckIn }
	 ,{ domSelector: ".input-slider--incrementor"
		, event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: "select[name=ps_week]"
		, event: "change"  , f: updateExerciseSession }
	 ,{ domSelector: ".params"             
		, event: "focus"   , f: activateOtherParamText }
	 ,{ domSelector: ".params"             
		, event: "blur"    , f: activateOtherParamText }
	 ,{ domSelector: ".view_more"          
		, event: "click"   , f: generateViewAdditional }
	]

	,"recovery": [
		{ domSelector: ".slider"            
		, event: "input"   , f: changeSliderNeighborValue } 
	 ,{ domSelector: ".input-slider--incrementor"
		, event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: ".modal-activate"    
		, event: "click"   , f: generateModalRecovery }
	 ,{ domSelector: "#participant_list li, .participant-info-nav li, #sendPageVals" 
		, event: "click"   , f: [ sendPageValsChange, sendPageValCallback ] }
	 ,{ domSelector: "input[name=sessionStoppedEarly]"    
		, event: "change"  , f: unhideRecoveryQuestions }
	]

	,"input": [
		{ domSelector: ".slider"            
		, event: "input"   , f: [ wasDocTouched, changeSliderNeighborValue ] } 
	 ,{ domSelector: ".input-slider--incrementor"       
		, event: "click"   , f: [ wasDocTouched, updateNeighborBoxFromSI ] } 
	 ,{ domSelector: "#participant_list li, .participant-info-nav li, .inner-selection li, #sendPageVals" 
		, event: "click"   , f: [ sendPageValsChange, sendPageValCallback ] }
	 ,{ domSelector: ".stateChange"  
		, event: "click"   , f: updateTime } 
	 ,{ domSelector: "button.stateChange + input"  
		, event: "click"   , f: changeUp } 
	 ,{ domSelector: ".toggler-input"  
		, event: "change"  , f: stateChangeUpdate } 
	]

	,"/":      [
		{ domSelector: ".part-drop-list li" 
		, event: "dragstart"  , attr: { draggable: true }, f: drag }
 	 ,{ domSelector: ".part-drop-list li" 
		, event: "touchstart" , attr: { draggable: true }, f: touchStart }
	 /*,{ domSelector: ".listing"           
		, event: "touchmove"  , f: tm }
	 ,{ domSelector: ".listing"           
		, event: "touchcancel", f: touchCancel }*/
	 ,{ domSelector: "#wash-id"           
		, event: "click"      , f: saveSessionUsers }
	 ,{ domSelector: "#bigly-search"      
		, event: "keyup"      , f: searchParticipants }
	 ,{ domSelector: ".release"      
		, event: "click"      , f: releaseParticipant }
	 ,{ domSelector: ".bigly-right"       
		, event: "drop"       , f: drop }
	 ,{ domSelector: ".bigly-right"       
		, event: "dragover"   , f: allowDrop }
	]

	,"default":      [
		{ domSelector: ".part-drop-list li" 
		, event: "dragstart"  , attr: { draggable: true }, f: [ drag ] }
	 ,{ domSelector: ".part-drop-list li" 
		, event: "touchstart" , attr: { checked:true, draggable: true }, f: touchStart }
/*	 ,{ domSelector: ".listing"           
		, event: "touchmove"  , f: tm }
	 ,{ domSelector: ".listing"           
		, event: "touchcancel", f: touchCancel }*/
	 ,{ domSelector: "#wash-id"           
		, event: "click"      , f: saveSessionUsers }
	 ,{ domSelector: "#bigly-search"      
		, event: "keyup"      , f: searchParticipants }
	 ,{ domSelector: ".release"
		, event: "click"      , f: releaseParticipant }
	 ,{ domSelector: ".bigly-right"       
		, event: "drop"       , f: drop }
	 ,{ domSelector: ".bigly-right"       
		, event: "dragover"   , f: allowDrop }
	]
};

function db( text ) {
	var n;
	debug.c.appendChild( n = document.createElement( "li" )	);
	n.innerHTML = text;
}

//main()
document.addEventListener("DOMContentLoaded", function(ev) {
	(rx = new Routex({ routes:Router })).init();
	
	document.addEventListener("touchstart", function() { 
		TOUCHABLE=1; 
	});

	if ( debug.on ) {
		(debug.p = document.createElement("div")).className = "js-debug"; 
		debug.p.appendChild( ( debug.c = document.createElement("ul") ) );
		document.body.appendChild( debug.p );
		db( "Debug Window" );	
	}	

	//Initialize all global elements here, because Routex does not include a way to do this right now.
	document.querySelector( ".login"	).addEventListener( "click", slideMenu );
	document.querySelector( ".persistent-nav-icon"	).addEventListener( "click", slideMenu );
});
