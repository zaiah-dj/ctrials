/*weekview.js*/

/*
 * This file exists to manage week view behavior when clicking on different links within the 'Exercise Session' modal pop-up window.
 *
 */

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



document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//Create a ghetto router
	locarr = location.href.split( "/" ) ;
	loc = locarr[ locarr.length - 1 ];

	//AJAX notes
	if ( loc.indexOf( "check-in.cfm" ) > -1 || loc.indexOf( "input.cfm" ) > -1 ) {
		var aa = [].slice.call( 
			document.querySelectorAll( ".modal-load" )); 

		for ( n in aa ) {
			aa[n].addEventListener( "click", getNextResults );
		}
	}
} );
