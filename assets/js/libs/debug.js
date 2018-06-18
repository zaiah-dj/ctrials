//....
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


//Create a window
	//Initialize a debugger window here...
function DINIT ( ) {
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
}


//...
function DDDDDDDDDDDDD () { 
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
}


//Query server at each new request to see what is going on behind the scenes
