function LOG( text ) {
	//if ( !(a = document.getElementById( "debugger" )) )
	if ( !(a = document.querySelectorAll( "#debugger .inner" )[0]) )
		console.log( text );
	else {
		div = document.createElement( "div" );
		div.innerHTML = text;
		a.appendChild( div );
	}
}


//Log things to XHR on devices that this seems to be incredibly hard on...
function xlogger ( message ) {
	var x = new XMLHttpRequest();
	x.onreadystatechange = function () {if ( this.readyState = 4 ) { 0; }};
	msg = ( message ) ? message : "someone did something with javascript.";
	x.open( "POST", "/motrpac/web/secure/dataentry/iv/robocop.cfm", true );
	x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	x.send( "message=" + msg );
}
