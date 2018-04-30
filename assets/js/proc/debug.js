/*debug.js*/
document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//Do an XHR every time to a resource called 'sessdata' to see what's going on when the app changes pages.
	if ( sid = document.getElementById( "sessionKey" ) ) { 
		xhr = new XMLHttpRequest();
		sid = sid.innerHTML;
		xhr.onreadystatechange = function ( ) {if ( this.readyState == 4 ) {console.log( this.responseText );}}
		xhr.open( "GET", "/motrpac/web/secure/dataentry/iv/sessdata.cfm?sid="+sid, true );
		xhr.send( );
	}

	//Initialize a debugger window here...
	if ( aa = document.getElementById( "debugger" ) ) {
		button = document.createElement( "button" );
		button.innerHTML = "Wipe!";
		button.style.width = "100px";
		button.style.color = "black";
		button.style.fontSize = "0.8em";
		button.style.height = "20px";
		aa.appendChild( button );

		div = document.createElement( "div" );
		div.className = "inner";
		aa.appendChild( div );

		button.addEventListener( "click", function (ev) {
			//Get rid of all children...
			document.querySelectorAll( "#debugger .inner" )[0].innerHTML = "";
		} );
	}


	//If the crazy debug id is there, do some stuff
	if ( db = document.getElementById( "mega-debug" ) ) {
		db_open = document.querySelector( "#mega-debug button.op" );
		db_close = document.querySelector( "#mega-debug button.cl" );
		db_close.addEventListener( "click", function (ev) {
			db.style.height = "50px";	
		});
		db_open.addEventListener( "click", function (ev) {
			db.style.height = "50%";	
		});
	}
} );
