/*routex.js - Run a router and execute thigns in data structures*/


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

/*
routes = {
	"check-in": [
		//In JS however, I have to use JSON for an object, meaning that I have to specify the key for each "column" I want.  This is a lot of typing... 
		{ domSelector: "input[ type=range ]" , event: "input"  , f: [ updateTickler, updateNeighborBox ] }  
	 ,{ domSelector: "input[ type=submit ]", event: "click"   , f: checkAtSubmit }
	 ,{ domSelector: "select"              , event: "click"   , f: [ updateTickler ] }
	 ,{ domSelector: "#ps_note_save"       , event: "click"   , f: checkInSaveNote }
	 ,{ domSelector: ".modal-load"         , event: "click"   , f: modalGetNextResults }
	 ,{ domSelector: ".modal-activate"     , event: "click"   , f: makeModal }
	 ,{ domSelector: ".incrementor"        , event: "click"   , f: updateNeighborBoxFromSI }
	 ,{ domSelector: "select[name=ps_week]", event: "change"  , f: updateExerciseSession }
	]
};
*/

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

	//local development stuff
	if ( local.dev ) {

	}	
	

	return {
		init: function ( ) {
			//Loop through the elements in the route specified.
			//	( VERBOSE ) ? console.log( "Loading handlers for route '" + loc + "'" ) : 0;
			console.log( local.routes );
			console.log( local.currentLocation );
			for ( r in local.routes ) {
			console.log( r );
				if ( local.currentLocation.indexOf( r ) > -1 ) {
					for ( t in local.routes[ r ] ) {
						tt = local.routes[ r ][ t ];
						try {
							//Find the DOM elements This call will only fail if the syntax of the selector was wrong.
							//TODO: Would it be helpful to let the dev know that this has occurred and on which index?
							dom = [].slice.call( document.querySelectorAll( tt.domSelector ) );
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
