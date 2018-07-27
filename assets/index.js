var subLink = "/motrpac/web/secure/dataentry/iv/update.cfm";

document.addEventListener( "DOMContentLoaded", function (ev) 
{
	/*
	//Do an XHR every time to a resource called 'sessdata' to see what's going on when the app changes pages.
	var xhr = new XMLHttpRequest();
	xhr.onreadystatechange = function ( ) {if ( this.readystate == 4 ) {console.log( this.responseText );}}
	xhr.open( "GET", "/motrpac/web/secure/dataentry/iv/sessdata.cfm", true );
	xhr.send( );
	*/
	
	
	//Basic filter search works
	if ( ip = document.getElementById( "bigly-search" ) ) { 
		ip.addEventListener( "keyup", function (ev) {
			vv = [].slice.call( document.querySelectorAll( "ul.part-drop-list li" ) );
			for ( i=0; i < vv.length; i++ ) {
				nod =         vv[i].children[0].parentElement;
				key = String( vv[i].children[0].innerHTML );
				val = ev.target.value;
				nod.style.display = ( key.toLowerCase().indexOf( val.toLowerCase() ) == -1 ) ? "none" : "block"; 
		}});
	}

	//What is this?
	a = [].slice.call( document.querySelectorAll( ".participants li" ) );
	for ( i = 0 ; i < a.length; i++ ) {
		//make it big if clicked
		a[i].addEventListener( "click", function ( ev ) {
			if ( ev.target.parentElement.className.indexOf( "active" ) == -1 ) {
				ev.target.parentElement.className += "active";
				ev.target.parentElement.focus();
			}	
			else {
				ev.target.parentElement.className = "";
			}	
		} );
	}

	//Create a quick router
	locarr = location.href.split( "/" ) ;
	loc = locarr[ locarr.length - 1 ];

	if ( loc.indexOf( "input.cfm" ) > -1 || loc.indexOf( "check-in.cfm" ) > -1 )
	{
		//Add an event listener to these input slider
		var b = [].slice.call( document.querySelectorAll( ".slider" ) );  

		//Get that nice slider effect going
		for ( i = 0; i < b.length; i++ ) {
			b[i].addEventListener( "input", function (ev) {
				ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
				xlogger( "Slider value changed to: " + ev.target.value );
			} );

			if (( aac = b[i].parentElement.parentElement.childNodes[7] ) ) {
				//console.log(aac.childNodes[1]);console.log(aac.childNodes[3]);

				aac.childNodes[1].addEventListener( "click", function (ev) {
					ev.preventDefault();
					aav = ev.target.parentElement.parentElement.childNodes[3];
					ev.target.value = aav.innerHTML = ++(aav.innerHTML); //console.log( v);
				} ); 
				aac.childNodes[3].addEventListener( "click", function (ev) {
					ev.preventDefault();
					aav = ev.target.parentElement.parentElement.childNodes[3];
					ev.target.value = aav.innerHTML=--(aav.innerHTML); //console.log( v);
				} ); 
			}
		}
	}
})
