// An example Javascript implementation (w/o Angular or Vue) might look something like this...

// For check-in
var local_data = {};

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

document.addEventListener("DOMContentLoaded", function(ev) {
router = {
"check-in": [
/*
 * //I want this Routing structure to have a schema like the following
 * { DOMSelector           , event     , function (or functions)      } 
 *
 */

/*
	//In C, structs aren't marked.  Like the following.  Very easy to specify a typesafe row of data. 
	{ "input[ type=range ]" , "click"   , updateTickler }  
 ,{ "input[ type=submit ]", "click"   , checkAtSubmit }
*/

	//In JS however, I have to use JSON for an object, meaning that I have to specify the key for each "column" I want.  This is a lot of typing... 
	{ domSelector: "input[ type=range ]" , event: "change"   , f: updateTickler }  
 ,{ domSelector: "input[ type=submit ]", event: "click"   , f: checkAtSubmit }
 ,{ domSelector: "select"              , event: "click"   , f: [ alerter, updateTickler ] }
/*
*/
/*
	//The best move may come down to doing something like this and defining an enum (as best as you can in JS)
	[ "input[ type=range ]" , "click"   , updateTickler ]
 ,[ "input[ type=submit ]", "click"   , checkAtSubmit ]
*/
]
}

//Define a list of error strings 
var errors = [
	"Invalid selector specified: %s."
];

for ( Route in router ) {
	//Just return the first character or the key name (provided it's not a number)
	console.log( Route[ 0 ] ); 

	//Then go into the object and start doing work
	for ( t in router[ Route ] ) {
		//Would a DOM Selector always exist?  I'm thinking no...
		tt = router[ Route ][ t ];

		//Find the DOM elements This call will only fail if the syntax of the selector was wrong.
		//TODO: Would it be helpful to let the dev know that this has occurred and on which index?
		try {
			dom = [].slice.call( document.querySelectorAll( tt.domSelector ) );
			console.log( dom );
		}
		catch ( e ) {
			//Handle SYNTAX_ERR (is there an errno?)
			console.log( e.message );
		}


		//Bind function(s) to event
		console.log( typeof tt.f );
		if ( typeof tt.f === 'function' && typeof tt.event === 'string' ) {
			console.log( "Time to do some single function binding..." );
			document.addEventListener( tt.event, tt.f ); 
		}
		else if ( typeof tt.f === 'object' && typeof tt.event === 'string' ) {
			console.log( "Time to do some object binding..." );
			for ( ff in tt.f ) {
				document.addEventListener( tt.event, tt.f[ ff ] ); 
			}
		}
	}
}
}); 
