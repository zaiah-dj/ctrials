/* ----------------------------------------------------*
 * index.js
 * --------
 *
 * This is an attempt to write JS without a framework.
 * Old school GUIs did the same thing, so why not try 
 * it here?
 * ----------------------------------------------------*/

//For check-in
var local_data = {};


//Bad way to go about it, but use a global and get things done
var fw = { arr:[], index:0 };


//Bad global
var activatedOPT = 0;


// printf (str, ....) - Works like the C version that you know and love.
function printf(str) {
	//Split on %[format strings]
	//Check for same number of arguments
}


function checkAtSubmit( ev ) {
	//Check that all ranges have been touched 
}


function allowDrop(ev) {
	ev.preventDefault();
}


function addFormattedWin( str, cback ) {
	db = document.createElement( "div" );
	db.style.width = "100%";
	db.style.height = "100%";
	db.style.position = "absolute";
	db.style.top = "0px";
	db.style.left = "0px";
	db.style.display = "block";
	db.style.zIndex = "99";
	db.style.backgroundColor = "rgba(0,0,255,0.3)";

	node = document.createElement( "div" );
	node.className = "pop-up";
	node.style.zIndex = "99";
	//node.id = "addedwindow";

	//	
	xout = document.createElement( "div" );
	xout.style.width = "100%";
	xout.style.height = "50px";

	//
	span = document.createElement( "span" );
	span.style.textAlign = "right"; 
	span.className = "close"; 
	span.innerHTML = "&times;";	
	span.addEventListener( "click", function (ev) {
		ev.preventDefault();
		db.parentElement.removeChild( db );
	});
	
	//Add it
	xout.appendChild( span );

	//This closes the window
	//node.innerHTML += "&times;";
	box = document.createElement( "textarea" );
	box.style.width = "100%";
	box.style.height = "80%";	

	//Add a button
	butt = document.createElement( "button" );
	butt.innerHTML = "Save!";
	butt.style.width = "50%";
	butt.style.left = "10px";
	butt.style.height = "30px";
	butt.style.marginTop = "10px";
	butt.addEventListener( "click", cback( box ) );

	//Add a clickable X
	//innerNode.innerHTML = str;
	//.appendChild( xout );
	node.appendChild( xout );
	node.appendChild( box );
	node.appendChild( butt );
	//shadenode.appendChild( node );
	//document.body.appendChild( shadenode );
	db.appendChild( node );
	document.body.appendChild( db );
	//document.body.appendChild( node );
}


function saveParticipantNote ( el ) {
	box = el;	
	return function (ev) {
		ev.preventDefault();
		//Get the partGUID, Session ID, and user notes
		pd = [].slice.call( document.querySelectorAll("input[name=ps_pid]") );
		sd = [].slice.call( document.querySelectorAll("input[name=ps_sid]") );
		noteValue = box.value ;

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
					console.log( this.responseText );
					parsed = JSON.parse( this.responseText );
					var par = [].slice.call( 
						document.querySelectorAll("ul.participant-notes") );
					var li = document.createElement( "li" );
					li.innerHTML = noteValue;
					par[0].appendChild( li ); 

					//Finally, get rid of the big box
					//node.parentElement.style.display = "none";
					node.parentElement.removeChild( node );
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
}



function saveParticipantEarlyStopReason ( el ) {
	box = el;	
	return function (ev) {
		ev.preventDefault();
		document.querySelector( "#reasonStoppedEarly" ).value = box.value;  
		//console.log( document.querySelector( "#reasonStoppedEarly" ).value ); 
		node.parentElement.removeChild( node );
	}
}



function addWin( str ) {
	node = document.createElement( "div" );
	innerNode = document.createElement( "div" );
	node.style.width = "200px";
	node.style.height = "50%";
	node.style.padding = "5px";
	node.style.position = "fixed";
	node.style.top = "25%";
	node.style.marginLeft = "-100px";
	node.style.left = "50%";
	node.style.zIndex = "99";
	node.style.backgroundColor = "#aaa";
	node.id = "addedwindow";

	butt = document.createElement( "button" );
	butt.innerHTML = "Click Me!";
	butt.style.width = "100%";
	butt.style.height = "30px";
	butt.addEventListener( "click", function (ev) {
		ev.preventDefault();
		node.parentElement.removeChild( node );
	});
	
	innerNode.innerHTML = str;
	node.appendChild( butt );
	node.appendChild( innerNode );
	document.body.appendChild( node );
}


function drag(ev, optArg) {
	if ( optArg ) {
		//( isDebugPresent ) ? console.log( "swipe complete..." ) : 0;
		return;
	}
	else {
		//( isDebugPresent ) ? console.log( "drag complete..." ) : 0;
		//ev.dataTransfer.setData("text", ev.target.id);
		fw[fw.index] = prepareParticipantNode( ev.target );
	}
}


//
function prepareParticipantNode ( el ) {
	return { 
		id: el.children[1].innerHTML
	 ,name: el.children[0].innerHTML.split( " (" )[0]
	 ,pid: el.children[0].innerHTML.match(/([0-9].*)/)[1].replace(")","")
	 ,ref: el
	 ,className: el.className
	};
}


//
function createParticipantNode( el ) {
	//Add a new node otherwise
	node = document.createElement( "li" );
	node.className =  el.className + "-dropped";//"endurance-class-dropped"; 
	divL = document.createElement( "div" );
	divL.className = "left";
	divR = document.createElement( "div" );
	divR.className = "right";

	//console.log( el.string.replace(/([0-9].*)/,"").replace(" (","") );
	//console.log( el.id);
	//console.log( el.string.match(/([0-9].*)/)[1].replace(")","") );

	span1 = document.createElement( "span" );
	span1.innerHTML = el.name; //el.string.replace(/([0-9].*)/,"").replace(" (","");
	span2 = document.createElement( "span" );
	span2.innerHTML = el.id;
	span3 = document.createElement( "span" );

	//span3.innerHTML = " (" + el.string.match(/([0-9].*)/)[1].replace(")","")  + ")";
	span3.innerHTML = " (" + el.pid + ")";
	divL.appendChild( span1 ); 
	divL.appendChild( span2 ); 
	divL.appendChild( span3 ); 
	ahref = document.createElement( "a" );
	ahref.className = "release"; 
	ahref.innerHTML = "Release"; 
	ahref.addEventListener( "click", releaseParticipant );
	divR.appendChild( ahref );
	node.appendChild( divL );
	node.appendChild( divR );
	return node;
}


//...
function drop(ev) {
	//var isDebugPresent = document.getElementById( "cfdebug" );
	//No default
	ev.preventDefault();

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
	node = createParticipantNode( fw[fw.index] );
	ev.target.children[0].appendChild( node ); 
	
	//Remove the original element
	ce = fw[ fw.index ].ref;
	ce.parentElement.removeChild( ce ); 
}


//Filter search when trying to narrow down participants
function searchParticipants ( ev ) {
	vv = [].slice.call( document.querySelectorAll( "ul.part-drop-list li" ) );
	for ( i=0; i < vv.length; i++ ) {
		nod =         vv[i].children[0].parentElement;
		key = String( vv[i].children[0].innerHTML );
		val = ev.target.value;
		nod.style.display = ( key.toLowerCase().indexOf( val.toLowerCase() ) == -1 ) ? "none" : "block"; 
	}
}


//
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


//Just update the thing
function updateTickler( ev ) {
	//Save the reference somewhere
	//console.log( ev );
}


//Update box values when slider changes
function updateNeighborBox ( ev ) {
	//Save the reference somewhere
	ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
}


//Handle the update of values by clicking on + and - boxes
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
	if ( ev.target.innerHTML == '-' )
		aav.innerHTML = (( forceNum - 1 ) < min ) ? aav.innerHTML : --( aav.innerHTML ); 
	else if ( ev.target.innerHTML == '+' ) {
		aav.innerHTML = (( forceNum + 1 ) <= max ) ? ++( aav.innerHTML ) : aav.innerHTML; 
	} 
	
	//aav.innerHTML = ( ev.target.innerHTML == '-' ) ? --( aav.innerHTML ) : ++( aav.innerHTML );
	ev.target.parentElement.parentElement.querySelector("input").value = aav.innerHTML;
}


//Handles fetching and serializing participant results from previous weeks 
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


//Save notes
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
		console.log( "nothing is here, guy" );
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
	xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update-note.cfm", true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( 
		"note=" + noteValue + 
		"&pid=" + pidValue +
		"&sid=" + sidValue 
	);

}


//Handle user sessions
function saveSessionUsers (ev) {
	//Cancel default
	ev.preventDefault();

	//Serialize all the data
	vv=[];
	vals = [].slice.call(document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" )); 
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
	xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update.cfm", true );
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


//Update exercise session list
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
	var l = "/motrpac/web/secure/dataentry/iv/" 
		+ "completed-days-results.cfm" 
		+ "?pid=" + pid 
		+ "&week=" + ev.target.value ;

	//Send a request and replace the field
	var x = new XMLHttpRequest();
	//console.log( l );
	
	x.open( "GET", l , false); 
	x.send();
	q.innerHTML = x.responseText;	
}


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


function releaseParticipant ( ev ) {
	ev.preventDefault();

	//Find the ID of the participant selected
	par = ev.target.parentElement.parentElement;

	//Assemble a POST request with the ID and other info
	f = document.getElementById( "wash-id" );
	
	//Keep all the things
	var thisGuy = { 
		id: par.querySelector( "span:nth-child(2)" ).innerHTML
	, string: par.querySelector( "span:nth-child(1)" ).innerHTML
	, className: par.className.replace( "-dropped", "" )
	, acrostic: par.querySelector( "span:nth-child(3)" ).innerHTML //.replace(" (","").replace(")","")
	};

	//....
	payload = [
		 "interventionist_id=" + f.interventionist_id.value  
		,"transact_id=" + f.transact_id.value 
		,"sessday_id=" + f.sessday_id.value 
		,"pid=" + thisGuy.id
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
	xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update.cfm", true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( payload );

	//Add the other element to the other side
	node = document.createElement( "li" );
	node.innerHTML = thisGuy.string + " (" + thisGuy.acrostic + ")";
	node.className =  thisGuy.className;

	//Would add to the bottom of the list, but it needs to be at the top
	a = document.querySelector( "ul.part-drop-list li:nth-child(1)" );
	console.log( a );
	a.parentElement.insertBefore( node, a );

	//Return false
	return false;
}


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


//
function sendPageValCallback ( ev ) {
	//Define some holding spots.
	tv={}, av=[]; 

	//Get all the values
	mv=[].slice.call( document.querySelectorAll( '.slider, .toggler-input, input[type=radio], select, #reasonStoppedEarly' ) );

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
	x.open( 'POST', '/motrpac/web/secure/dataentry/iv/update.cfm', false );
	x.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
	x.send(Vals);
}


// a callback handler for errors during XHR
function tsOnError ( responseText ) {
	console.log( responseText );
}


//Touch controls
function touchStart (ev, passedName) {
	//Disable the standard ability to select the touched object
	ev.preventDefault();

	try {
		//Short name for the stuff I'm concerned with
		pp = prepareParticipantNode( ev.target );

		//Get the total number of fingers touching the screen
		fingerCount = ev.touches.length;

		// since we're looking for a swipe (single finger) and not a gesture (multiple fingers),
		// check that only one finger was used
		if ( fingerCount > 1 ) 
			touchCancel(ev);
		else {
			//Always check against drop list and make sure the duplicate entries aren't getting in
			aa = [].slice.call( document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" ) ); 
			if ( aa.length > 0 ) {
				for ( i=0; i<aa.length; i++) {
					if ( aa[i].innerHTML == pp.id ) {
						console.log( "Looks like this id is already here, stopping request..." );
						return;
					}
				}
			}
		  node = createParticipantNode( pp );
			targ = document.querySelector( ".listing-drop ul" ) 
			targ.appendChild( node );
			ev.target.parentElement.removeChild( ev.target );
		}
	}
	catch (err) {
		addWin( err );
	}
}


//Touch cancel
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

function tm (ev, pn) {
	ev.preventDefault();
	if ( ev.touches.length == 1 ) {
		curX = ev.touches[0].pageX;
		curY = ev.touches[0].pageY;
		//LOG( "X: " + curX + ", Y: " + curY );
	} else {
		touchCancel(ev);
	}
}

function touchEnd (ev, pn) {
	;
}


function generateModalCheckIn( ev ) {
	ev.preventDefault();
	addFormattedWin( " ", saveParticipantNote ) 
}

function generateModalRecovery( ev ) {
	ev.preventDefault();
	addFormattedWin( " ", saveParticipantEarlyStopReason ) 
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
		addWin( err );
	}
}


function hih () {
	addFormattedWin( "yomama" ); 
}


function bootstrapMakeModal ( ev ) {
	ev.preventDefault();
	addFormattedWin( "yomama", function () { ; } ); 

//document.getElementsByClassName("modal")[0].modal();
//$( "#myModal" ).modal();

/*	
	var xhr=XMLHttpRequest();
	xhr.onreadystatechange = function (ev) { 
	}
	xhr.open( "GET", "/motrpac/web/secure/dataentry/iv/assets/templates/modal.html", true );
*/
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
Router = {
	"check-in": [
		//In JS however, I have to use JSON for an object, meaning that I have to specify the key for each "column" I want.  This is a lot of typing... 
		{ domSelector: "input[ type=range ]" , event: "input"  , f: [ updateTickler, changeSliderNeighborValue ] }  
	 ,{ domSelector: "input[ type=submit ]", event: "click"   , f: checkAtSubmit }
	 ,{ domSelector: "select"              , event: "click"   , f: [ updateTickler ] }
	 ,{ domSelector: "#ps_note_save"       , event: "click"   , f: checkInSaveNote }
	 ,{ domSelector: ".modal-load"         , event: "click"   , f: getNextResults }
	 ,{ domSelector: ".modal-activate"     , event: "click"   , f: generateModalCheckIn }
	 ,{ domSelector: ".incrementor"        , event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: "select[name=ps_week]", event: "change"  , f: updateExerciseSession }
	 ,{ domSelector: ".params"             , event: "focus"   , f: activateOtherParamText }
	 ,{ domSelector: ".params"             , event: "blur"    , f: activateOtherParamText }
	 ,{ domSelector: ".view_more"          , event: "click"   , f: bootstrapMakeModal }
	]

	,"recovery": [
		{ domSelector: ".slider"            , event: "input"   , f: changeSliderNeighborValue } 
	 ,{ domSelector: ".incrementor"       , event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: ".modal-activate"    , event: "click"   , f: generateModalRecovery }
	 ,{ domSelector: "#participant_list li, .participant-info-nav li, #sendPageVals" , event: "click"   , f: [ sendPageValsChange, sendPageValCallback ] }
	]

	,"input": [
		{ domSelector: ".slider"            , event: "input"   , f: changeSliderNeighborValue } 
	 ,{ domSelector: ".incrementor"       , event: "click"   , f: updateNeighborBoxFromSI } ,{ domSelector: ".modal-activate"    , event: "click"   , f: makeModal } ,{ domSelector: "#participant_list li, .participant-info-nav li, .inner-selection li, #sendPageVals" , event: "click"   , f: [ sendPageValsChange, sendPageValCallback ] }
	]

	,"/":      [
		{ domSelector: ".part-drop-list li" , event: "dragstart"   , attr: { draggable: true }, f: drag }
	 ,{ domSelector: ".part-drop-list li" , event: "touchstart"  , attr: { checked:true, draggable: true }, f: touchStart }
	 ,{ domSelector: ".listing"           , event: "touchEnd"    , f: touchEnd }
	 ,{ domSelector: ".listing"           , event: "touchMove"   , f: tm }
	 ,{ domSelector: ".listing"           , event: "touchCancel" , f: touchCancel }
	 ,{ domSelector: "#wash-id"           , event: "click"       , f: saveSessionUsers }
	 ,{ domSelector: "#bigly-search"      , event: "keyup"       , f: searchParticipants }
	 ,{ domSelector: ".release"      , event: "click"       , f: releaseParticipant }
	]

	,"default":      [
		{ domSelector: ".part-drop-list li" , event: "dragstart"   , attr: { draggable: true }, f: [ drag ] }
	 ,{ domSelector: ".part-drop-list li" , event: "touchstart"  , attr: { checked:true, draggable: true }, f: [ touchStart ] }
	 ,{ domSelector: ".listing"           , event: "touchEnd"    , f: [ touchEnd ] }
	 ,{ domSelector: ".listing"           , event: "touchMove"   , f: [ tm ] }
	 ,{ domSelector: ".listing"           , event: "touchCancel" , f: [ touchCancel ] }
	 ,{ domSelector: "#wash-id"           , event: "click"       , f: saveSessionUsers }
	 ,{ domSelector: "#bigly-search"      , event: "keyup"       , f: searchParticipants }
	 ,{ domSelector: ".release"      , event: "click"       , f: releaseParticipant }
	]
};

inc = 0;

//main()
document.addEventListener("DOMContentLoaded", function(ev) {
	rx = new Routex( {routes:Router, verbose:1} );
	rx.init();

	str = [];
	for ( n in Router ) str.push( n ); 
	//addWin( str.join( "<br >" ) );
	
});
