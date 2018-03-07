var subLink = "/motrpac/web/secure/dataentry/iv/update.cfm";


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


document.addEventListener( "DOMContentLoaded", function (ev) 
{
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



	//???What is this?
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


	//Create a ghetto router
	locarr = location.href.split( "/" ) ;
	loc = locarr[ locarr.length - 1 ];

	if ( loc.indexOf( "input.cfm" ) > -1 ) 
	{

		//********************************************************** 
		//******      CONTROL EXERCISE DETAILS               *******
		//********************************************************** 
		if ( v = document.getElementById( "choose_mode" ) ) {
			v.addEventListener( "change", function (ev) {

				console.log( ev.target.value );	
				console.log( document.getElementById( "_cycle" ) ); 
			
		//INSTEAD OF AN ID AND DIV, USE A QUERY SELECTOR AND DROP
		//CAN PROBABLY DO SOME ANIMATION TO MAKE IT LOOK SMOOTH AND FLY
		/*
				if ( ev.target.value == 1 ) 
				{
					document.getElementById( "_cycle" ).style.display = "block";
					document.getElementById( "_treadmill" ).style.display = "none";
				}
				else if ( ev.target.value == 2 )
				{
					document.getElementById( "_cycle" ).style.display = "none";
					document.getElementById( "_treadmill" ).style.display = "block";
				}
				else if ( ev.target.value == 3 )
				{
					document.getElementById( "_cycle" ).style.display = "none";
					document.getElementById( "_treadmill" ).style.display = "none";
				}
		*/
			});
		}

		//********************************************************** 
		//******      INPUT SLIDER FUNCTIONALITY            *******
		//********************************************************** 
		//Add an event listener to these input slider
		var b = [].slice.call( document.querySelectorAll( ".slider" ) );  

		//...
		for ( i = 0; i < b.length; i++ ) {
			//Get that nice slider effect going
			b[i].addEventListener( "input", function (ev) {
				ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
			} );

			//This allows this to fire and save when the user is done
			b[i].addEventListener( "change", function (ev) {
				//ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
				//alert( "New value is: " + ev.target.value );
				var xhr = new XMLHttpRequest();
				LOG( ev.target.value );
				LOG( ev.target.name );
				LOG( ev.target.getAttribute( "data-attr-table" ) );

				//Read that XML	
				xhr.onreadystatechange = function (ev) { 
					if ( this.readyState == 4 && this.status == 200 ) {
						LOG( "SUB TO SERVER GOT BACK 200!" );
						//parsed = JSON.parse( this.responseText );
						LOG( this.responseText );
						//LOG( parsed );	
					}
				}

				xhr.open( "POST", subLink, true );
				xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded");

				if ( 1 ) { 
				xhr.send( [ 
					"value=" + ev.target.value,
					"name="  + ev.target.name,
					"id="    + 33,
					"table=" + ev.target.getAttribute( "data-attr-table" )
				].join('&'));
				}
				else {
xhr.send( 'value={value:33,name:"Antonio Collins",table:"ermigerd",id:12}' );
				}
			} );
		}



	}
		
})
