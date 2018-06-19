// An example Javascript implementation (w/o Angular or Vue) might look something like this...

/* ----------------------------------------------------*
 * index.js
 * --------
 *
 * This is an attempt to write JS without a framework.
 * Old school GUIs did the same thing, so why not try 
 * it here?
 * ----------------------------------------------------*/

// For check-in
var local_data = {};

// Be really chatty
var VERBOSE = 1;


// printf (str, ....) - Works like the C version that you know and love.
function printf(str) {
	//Split on %[format strings]
	//Check for same number of arguments
}

function checkAtSubmit( ev ) {
	//Check that all ranges have been touched 
}


function changeSliderNeighborValue ( ev ) {
	//Change the whole value if the inner value has no nodes...
	//ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value; 

	//console.log( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes.length );
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
	//console.log( "clicked" );
	//console.log( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes.length );
	if ( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes.length <= 1 ) {
		aav = ev.target.parentElement.parentElement.childNodes[3];
		//ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
	}
	else {
		//console.log( ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes[0].innerHTML = ev.target.value );
		//ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes[0].innerHTML = ev.target.value;
		aav = ev.target.parentElement.parentElement.childNodes[ 3 ].childNodes[0];
	} 
	aav.innerHTML = ( ev.target.innerHTML == '-' ) ? --( aav.innerHTML ) : ++( aav.innerHTML );
	ev.target.parentElement.parentElement.querySelector("input").value = aav.innerHTML;
}



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

//Handles fetching and serializing participant results from previous weeks 
function modalGetNextResults(ev) {
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
		
	var note = [].slice.call( 
		document.querySelectorAll("textarea[name=ps_notes]") );

	var pidValue = pidDom[0]["value"];
	var noteValue = note[0]["value"];

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
		"&pid=" + pidValue 
	);
}


//Handle user sessions
function save_session_users (ev) {
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
				console.log( this.responseText );
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

	//Send a POST to the server
	xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update.cfm", true );
	xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
	xhr.send( payload );
	//console.log( payload );console.log( xhr.responseText );
	return false;
};


//Simply lists what functions are being called with each listener.
function whatFunct( f ) {
	console.log( f );
}


//Update exercise session list
function updateExerciseSession ( ev ) {
	//Get the current PID
	var pid, ilocarr = location.href.split("?")[1].split("=");
	for ( n=0; n < ilocarr.length; n++ )
		{ if ( ilocarr[n] == "id" ) pid = ilocarr[n + 1];	}
	
	//And finally get the field to change
	var p = ev.target.parentElement.parentElement.parentElement;
	var q = p.querySelector( "table tr:nth-of-type(3) td:nth-child(2) ul.dasch" );
	
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
	 ,{ domSelector: ".modal-load"         , event: "click"   , f: modalGetNextResults }
	 ,{ domSelector: ".modal-activate"     , event: "click"   , f: makeModal }
	 ,{ domSelector: ".incrementor"        , event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: "select[name=ps_week]", event: "change"  , f: updateExerciseSession }
	]

	,"input": [
		{ domSelector: ".slider"            , event: "input"   , f: changeSliderNeighborValue } 
	 ,{ domSelector: ".incrementor"       , event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: ".modal-activate"    , event: "click"   , f: makeModal }
	]

	,"/":      [
		{ domSelector: ".part-drop-list li" , event: "dragstart"   , attr: { draggable: true }, f: drag }
	 ,{ domSelector: ".part-drop-list li" , event: "touchstart"  , attr: { checked:true, draggable: true }, f: ts }
	 ,{ domSelector: ".listing"           , event: "touchEnd"    , f: te }
	 ,{ domSelector: ".listing"           , event: "touchMove"   , f: tm }
	 ,{ domSelector: ".listing"           , event: "touchCancel" , f: tc }
	 ,{ domSelector: "#wash-id"           , event: "click"       , f: save_session_users }
	]
};


//main()
document.addEventListener("DOMContentLoaded", function(ev) {
	rx = new Routex({routes:Router, verbose:0});
	rx.init();
});
