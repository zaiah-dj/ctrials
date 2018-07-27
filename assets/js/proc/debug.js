/*debug.js*/


//Log things to XHR on devices that this seems to be incredibly hard on...
function xlogger ( message ) {
	var x = new XMLHttpRequest();
	x.onreadystatechange = function () {if ( this.readyState = 4 ) { 0; }};
	msg = ( message ) ? message : "someone did something with javascript.";
	x.open( "POST", "/motrpac/web/secure/dataentry/iv/robocop.cfm", true );
	x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	x.send( "message=" + msg );
}


//Create a window and initialize a debugger window here...
function DINIT ( ) {
	//TODO: PLEASE clean this up...
	var local = {};

	//Create the window
	local.dn = dn = document.createElement("div");
	dn.style.className = "debug";
	dn.style.position= "fixed";
	dn.style.width= "400px";
	dn.style.height= "300px";
	dn.style.color= "white";
	dn.style.backgroundColor= "maroon";
	dn.style.zIndex= "99";
	dn.style.right= "30px";
	dn.style.top= "10px";
	dn.style.padding= "10px";
	dn.style.overflowY = "scroll";
	dn.style.opacity = "0.7";
	dn.style.transition = "height 0.1s";

	//Header titles something, can't remember what
	local.h2 = 
	    dnh2 = document.createElement("h2");
	dnh2.style.position= "relative";
	dnh2.style.fontSize= "1.1em";
	dnh2.style.fontWeight= "bold";
	dnh2.style.marginBottom= "20px";
	dnh2.style.marginTop= "0px";
	dnh2.style.textDecoration= "underline";
	dnh2.innerHTML = "Dev Window";
	dn.appendChild( dnh2 );

	//Hide and show 
	ex = document.createElement( "button" );
	ex.innerHTML = "X";
	ex.fontSize = "20px";
	ex.style.color = "black";
	ex.style.position = "absolute";
	ex.style.top = "0px";
	ex.style.right = "0px";
	ex.style.width = "40px";
	hy = document.createElement( "button" );
	hy.innerHTML = "_";
	hy.fontSize = "20px";
	hy.style.color = "black";
	hy.style.position = "absolute";
	hy.style.right = "40px";
	hy.style.top = "0px";
	hy.style.width = "40px";
	local.clicked = 0;
	hy.addEventListener( "click", function (ev) { 
		dn.style.height = ( !local.clicked ) ? "20px" : "50%"; 
		hy.innerHTML    = ( !local.clicked ) ? "+" : "_"; 
		local.clicked   = ( !local.clicked ) ? 1 : 0; 
	} );
	dn.appendChild( ex );
	dn.appendChild( hy );

	//Button
	local.bn = 
	      bn = document.createElement( "button" );
	bn.style.position= "relative";
	bn.innerHTML = "Wipe!";
	bn.style.width = "100px";
	bn.style.color = "black";
	bn.style.fontSize = "0.8em";
	bn.style.height = "20px";
	dn.appendChild( bn );

	//Divvy div mcdividdiv
	local.div =
			  div = document.createElement( "div" );
	div.style.position= "relative";
	div.className = "inner";
	dn.appendChild( div );
	bn.addEventListener( "click", function (ev) { div.innerHTML = ""; } );

	//Add to DOM
	document.body.appendChild( dn );


	//Log stuff	
	return {
		log : function ( text ) {
			//if ( !(a = document.querySelectorAll( "#debugger .inner" )[0]) )console.log( text );else{
				newdiv = document.createElement( "div" );
				newdiv.innerHTML = text;
				local.div.appendChild( newdiv );
			//}
		}
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


//...
DebugRouter = {
};


//Query server at each new request to see what is going on behind the scenes
document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//Do an XHR every time to a resource called 'sessdata' to see what's going on when the app changes pages.
	/*
	if ( sid = document.getElementById( "sessionKey" ) ) { 
		xhr = new XMLHttpRequest();
		sid = sid.innerHTML;
		xhr.onreadystatechange = function ( ) {if ( this.readyState == 4 ) {console.log( this.responseText );}}
		xhr.open( "GET", "/motrpac/web/secure/dataentry/iv/sessdata.cfm?sid="+sid, true );
		xhr.send( );
	}
	*/

	//dd = DINIT();
	//dd.log( "yadda" );
	//Initialize debugging routes
	//dx = new Routex({routes:DebugRouter, verbose:1});
	//dx.init();
} );
