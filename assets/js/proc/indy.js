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

function checkAtSubmit( ev ) {
	//Check that all ranges have been touched 
}


function updateTickler( ev ) {
	//Save the reference somewhere
	console.log( ev );
}


function alerter( ev ) {
	//Save the reference somewhere
	console.log( "Alert, alert, alert" );
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
	butt.addEventListener( "click", function (ev) {
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
	});
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


//This structure handles routing
Router = {
	"check-in": [
		//In JS however, I have to use JSON for an object, meaning that I have to specify the key for each "column" I want.  This is a lot of typing... 
		{ domSelector: "input[ type=range ]" , event: "change"  , f: updateTickler }  
	 ,{ domSelector: "input[ type=submit ]", event: "click"   , f: checkAtSubmit }
	 ,{ domSelector: "select"              , event: "click"   , f: [ alerter, updateTickler ] }
	 ,{ domSelector: "#ps_note_save"       , event: "click"   , f: checkInSaveNote }
	 ,{ domSelector: ".modal-load"         , event: "click"   , f: modalGetNextResults }
	 ,{ domSelector: ".modal-activate"    , event: "click"   , f: makeModal }
	]

	,"input": [
		{ domSelector: ".slider" , event: "input"  , f: function(ev) { ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value; } }
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
	//Define a list of error strings.
	var errors = [
		"Invalid selector specified: %s."
	];

	//Define another list of verbosity strings.
	var verbosity = [
		0
	];

	//Create a simple router
	locarr = location.href.split( "/" ) ;
	loc = ( locarr[ locarr.length - 1 ] == "" ) ? "/" : locarr[ locarr.length - 1 ];
	console.log( loc );

	//Loop through the elements in the route specified.
	//	( VERBOSE ) ? console.log( "Loading handlers for route '" + loc + "'" ) : 0;
	for ( Route in Router ) {
		if ( loc.indexOf( Route ) > -1 ) {
			for ( t in Router[ Route ] ) {
				tt = Router[ Route ][ t ];
				try {
					//Find the DOM elements This call will only fail if the syntax of the selector was wrong.
					//TODO: Would it be helpful to let the dev know that this has occurred and on which index?
					dom = [].slice.call( document.querySelectorAll( tt.domSelector ) );
					( VERBOSE ) ? console.log( dom ) : 0;
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
							( VERBOSE ) ? console.log( "Setting key '" + key + "' to '" + tt.attr[ key ] + "'" + " on element " + tt.domSelector + "(" + d + ")"  ) : 0;
							dom[d].setAttribute( key, tt.attr[ key ] );
						} 	
					} 	
				}

				//Bind function(s) to event
				if ( typeof tt.f === 'function' && typeof tt.event === 'string' ) {
					( VERBOSE ) ? console.log( "Time to do some single function binding..." ) : 0;
					for ( d in dom ) dom[ d ].addEventListener( tt.event, tt.f ); 
				}
				else if ( typeof tt.f === 'object' && typeof tt.event === 'string' ) {
					( VERBOSE ) ? console.log( "Time to do some object binding..." ) : 0;
					for ( d in dom ) {
						( VERBOSE ) ? console.log( "object binding: ", dom[ d ] ) : 0;
						for ( ff in tt.f ) {
							dom[d].addEventListener( tt.event, tt.f[ ff ] ); 
						}
					}
				}
			}
		}
	}
}); 
